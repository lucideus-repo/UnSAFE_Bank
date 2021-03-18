//
//  viewSelectedBeneficiary.swift
//  damnVIA
//
//  Created by Sahil Pahwa on 19/09/18.
//  Copyright © 2018 lucideus. All rights reserved.
//

import UIKit

class ListBeneficiary: UIViewController {

    @IBOutlet weak var bnfcTv: UITableView!
    let icon = #imageLiteral(resourceName: "user")
    let indicator = UIActivityIndicatorView(style: .whiteLarge)
    
    var accNo: String!
    var alias: [String]!
    var bankName: String!
    var branch: String!
    var bankCode: String!

    override func viewDidLoad() {
        super.viewDidLoad()
        bnfcTv.delegate = self
        bnfcTv.dataSource = self
    }

    private func showActivityIndicator() {
        indicator.center = self.view.center
        indicator.hidesWhenStopped = true
        indicator.color = UIColor.darkGray
        indicator.startAnimating()
        self.view.addSubview(indicator)
    }
    
    private func hideActivityIndicator() {
        indicator.stopAnimating()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        guard self.checkNetworkConnectivity() else{return}
        showActivityIndicator()
        
        APIHelpers.hitListBeneficiaries(completionHandler: { [weak self] (data,error) in
        
            guard let data = data else {
                DispatchQueue.main.async {
                    self?.hideActivityIndicator()
                    self?.showAlert(withTitle: AlertTitles.error, andMessage: error?.localizedDescription ?? "Something went wrong", handler: nil)
                }
                return
            }
            
            do {
               // guard let data = data else {return}
                let decoder = JSONDecoder()
                let receivedJSON = try decoder.decode(listBenfcResponseModel.self, from: data)
                print(receivedJSON)
                DispatchQueue.main.async {
                    self?.hideActivityIndicator()
                    if receivedJSON.status == statusMessages.failed {
                        self?.showAlert(withTitle: receivedJSON.status_code, andMessage: receivedJSON.message, handler: { (action) in
                            if receivedJSON.status_code == "ERRO06"{self?.dismiss(animated: true, completion: {})}
                        })
                    }
                    else {
                        guard let data = receivedJSON.data else {return}
                        self?.alias = data.alias
                        self?.bnfcTv.reloadData()
                    }
                }
            }
            catch {
                DispatchQueue.main.async {
                    self?.hideActivityIndicator()
                    self?.showAlert(withTitle: AlertTitles.parsingErrorTitle, andMessage: AlertMessages.parsingErrorMessage, handler: nil)
                }
                return
            }
        })
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        let destination = segue.destination as! FetchBeneficiaryDetails
        let indexPath = sender as! IndexPath
        destination.alias = alias[indexPath.row]
    }
}

extension ListBeneficiary: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if alias != nil {
            return alias.count
        }
        else {
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "optionsCell") as! optionsTableViewCell
        cell.iconView.image = icon
        cell.label.text = alias[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        performSegue(withIdentifier: "FetchBeneficiaryVC", sender: indexPath)
    }
}

