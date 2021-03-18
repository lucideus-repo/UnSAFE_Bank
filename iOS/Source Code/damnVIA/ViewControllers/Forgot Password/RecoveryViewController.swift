//
//  RecoveryViewController.swift
//  damnVIA
//
//  Created by Sahil Pahwa on 02/08/19.
//  Copyright © 2019 lucideus. All rights reserved.
//

import UIKit

class RecoveryViewController: UIViewController {

    @IBOutlet weak var customerIdTF: UITextField!
    
    let indicator = UIActivityIndicatorView(style: .whiteLarge)
    var encrypted_otp: String!

    @IBAction func dismissPressed(_ sender: UIBarButtonItem) {
        
        self.dismiss(animated: true, completion: nil)
        //self.presentingViewController?.dismiss(animated: true, completion: nil)
    }
    
    
    
    @IBAction func verifyPressed(_ sender: UIButton) {
        
        guard let customerId =  customerIdTF.text else {return}
        
        if customerId.trimmingCharacters(in: .whitespaces).isEmpty {
            showAlert(withTitle: "Whitespaces", andMessage: "The field should not contain whitespaces", handler: nil)
            return
        }
        
        guard self.checkNetworkConnectivity() else{return}
        
        self.showActivityIndicator(indicator: self.indicator)
        
        self.checkNotificationAllowed({[weak self] (isAllowed) in
            if isAllowed{self?.hitRecoveryAPI(customerId)}
            else{self?.hideActivityIndicator(indicator: self!.indicator)}
        })
    }
    
    fileprivate func hitRecoveryAPI(_ customerId: String) {
        APIHelpers.passwordRecovery(params: [JSONKeys.userId: customerId, JSONKeys.otp_type: OtpType.forgotPassword]) { [weak self] (data,error) in
            
            guard let self = self else{return}
            
            guard let data = data else {
                DispatchQueue.main.async {
                    self.hideActivityIndicator(indicator: self.indicator)
                    self.showAlert(withTitle: AlertTitles.error, andMessage: error?.localizedDescription ?? "Something went wrong", handler: nil)
                }
                return
            }
            
            do {
                // guard let data = data else {return}
                let decoder = JSONDecoder()
                //                let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String : Any]
                //                print(json)
                let receivedJSON = try decoder.decode(getOtpResponseModel.self, from: data)
                //print(receivedJSON)
                DispatchQueue.main.async {
                    self.hideActivityIndicator(indicator: self.indicator)
                    if receivedJSON.status == statusMessages.failed {
                        self.showAlert(withTitle: receivedJSON.status_code, andMessage: receivedJSON.message, handler: nil)
                    }
                    else {
                        guard let data = receivedJSON.data else {return}
                        self.encrypted_otp = data.response
                        //print(self?.encrypted_otp)
                        // print(receivedJSON)
                        // guard let encrypted_otp = receivedJSON.data else {return}
                        self.performSegue(withIdentifier: segues.confirmOtpSegue, sender: [JSONKeys.userId: customerId, JSONKeys.otpResponse: self.encrypted_otp])
                    }
                }
            }
            catch {
                DispatchQueue.main.async {
                    self.hideActivityIndicator(indicator: self.indicator)
                    self.showAlert(withTitle: AlertTitles.parsingErrorTitle, andMessage: AlertMessages.parsingErrorMessage, handler: nil)
                }
                return
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == segues.confirmOtpSegue {
            
            let destination = segue.destination as! RecoveryOtpViewController
            let params = sender as? NSDictionary
            destination.params = params as? [String:String]
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.hideKeyboardWhenTappedAround()
    }
}
