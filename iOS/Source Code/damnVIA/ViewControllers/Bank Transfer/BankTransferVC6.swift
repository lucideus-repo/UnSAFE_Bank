//
//  BankTransferVC6.swift
//  damnVIA
//
//  Created by Sahil Pahwa on 30/03/19.
//  Copyright © 2019 lucideus. All rights reserved.
//

import UIKit

class BankTransferVC6: UIViewController {

    @IBOutlet weak var dotLabel: UILabel!
    @IBOutlet weak var statusLabel: UILabel!
    var params: [String: String]!
    var timer = Timer()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.hidesBackButton = true
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        guard self.checkNetworkConnectivity() else{return}
        
        dotLabel.makeLoadingAnimation(timer: &timer, text: "")
         APIHelpers.payBeneficiary(params: params) { [weak self] (data,error) in
         
             guard let data = data else {
                 DispatchQueue.main.async {
                    // self?.hideActivityIndicator()
                     self?.showAlert(withTitle: AlertTitles.error, andMessage: error?.localizedDescription ?? "Something went wrong", handler: nil)
                 }
                 return
             }
            
            do {
               // guard let data = data else {return}
                let decoder = JSONDecoder()
//                let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String : Any]
//                print(json)
                let receivedJSON = try decoder.decode(payBeneficiaryResponseModel.self, from: data)
                print(receivedJSON)
                DispatchQueue.main.asyncAfter(deadline: .now() + Double.random(in: 1.71828...2.14159), execute: {
                    self?.showAlert(withTitle: receivedJSON.status_code, andMessage: receivedJSON.message, handler: {(action) in
                        self?.navigationController?.popToViewController(ofClass: fundsTransferVC.self)
                    })
                })
                DispatchQueue.main.async {
                    if receivedJSON.status == statusMessages.failed {
                        if receivedJSON.status_code == "ERR006" { //logout
                            self?.showAlert(withTitle: receivedJSON.status_code, andMessage: receivedJSON.message, handler: {(action) in
                                self?.navigationController?.popToRootViewController(animated: true) //logout
                                self?.navigationController?.dismiss(animated: true, completion: {})
                            })
                        }else{
                            self?.showAlert(withTitle: receivedJSON.status_code, andMessage: receivedJSON.message, handler: {(action) in
                                self?.navigationController?.popToViewController(ofClass: fundsTransferVC.self)
                            })
                        }
                    }
                    else {
                        if receivedJSON.status_code == "BNF015" {
                            // set the global flag on balance changed
                            isBalanceChanged = true
                            guard let res = receivedJSON.data else {return}
                            DispatchQueue.main.asyncAfter(deadline: .now() + Double.random(in: 3.11828...4.04159), execute: {
                                self?.performSegue(withIdentifier: segues.doneSegue, sender: res.transaction_reference)
                            })
                        }
                    }
                }
            }
            catch {
                DispatchQueue.main.async {
                    self?.showAlert(withTitle: AlertTitles.parsingErrorTitle, andMessage: AlertMessages.parsingErrorMessage, handler: { (action) in
                        self?.navigationController?.popToViewController(ofClass: fundsTransferVC.self)
                    })
                }
                return
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let refNo = sender as! String
        if segue.identifier == segues.doneSegue {
            let vc = segue.destination as! BankTransferVC7
            vc.refNo = refNo
        }
    }
}
