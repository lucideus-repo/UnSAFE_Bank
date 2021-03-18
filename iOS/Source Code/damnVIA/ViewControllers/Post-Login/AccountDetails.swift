//
//  AccountDetails.swift
//  damnVIA
//
//  Created by Sahil Pahwa on 19/09/18.
//  Copyright © 2018 lucideus. All rights reserved.
//

import UIKit

class AccountDetails: UIViewController {

    @IBOutlet weak var accountDetailsTv: UITableView!
    let indicator = UIActivityIndicatorView(style: .whiteLarge)
    let icons = [#imageLiteral(resourceName: "user"),#imageLiteral(resourceName: "home"),#imageLiteral(resourceName: "cake"),#imageLiteral(resourceName: "smartphone"),#imageLiteral(resourceName: "email"),#imageLiteral(resourceName: "document"),#imageLiteral(resourceName: "document"),#imageLiteral(resourceName: "number"),#imageLiteral(resourceName: "rupee"),#imageLiteral(resourceName: "document")]
    
    var accountDetails: accountDetailsData?
    var fname: String!
    var lname: String!
    var gender: String!
    var address: String!
    var dob: String!
    var mobileNo: String!
    var email: String!
    var aadharId: String!
    var panCardId: String!
    var acctNo: String!
    var acctBalance: String!
    var incomeTaxNumber: String!
    var acctOpeningDate: String!
    var token: String!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        self.accountDetailsTv.rowHeight = UITableView.automaticDimension
//        self.accountDetailsTv.estimatedRowHeight = 80
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        guard self.checkNetworkConnectivity() else{return}
        showActivityIndicator()
        APIHelpers.hitAccountDetails { [weak self] (data,error) in
        
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
                //                let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String : Any]
                //                print(json!)
                let receivedJSON = try decoder.decode(accountDetailsResponseModel.self, from: data)
                print(receivedJSON)
                
                DispatchQueue.main.async {
                    self?.hideActivityIndicator()
                    if receivedJSON.status == statusMessages.success {
                        
                        guard let data = receivedJSON.data else {return}
                        guard let fname = data.fname else {return}
                        guard let lname = data.lname else {return}
                        guard let gender = data.gender else {return}
                        guard let address = data.address else {return}
                        guard let dob = data.dob else {return}
                        guard let mobileNo = receivedJSON.data?.mobileNo else {return}
                        guard let email = data.email else {return}
                        guard let aadharId = data.aadharId else {return}
                        guard let panCardId = data.panCardId else {return}
                        guard let acctNo = data.accountNumber else {return}
                        guard let acctBalance = data.accountBalance else {return}
                        guard let incomeTaxNumber = data.incomeTaxNumber else {return}
                        guard let acctOpeningDate = data.openDate else {return}
                        self?.accountDetails = data
                        self?.fname = fname
                        self?.lname = lname
                        self?.gender = gender
                        self?.address = address
                        self?.dob = self?.changeDOBFormat(dob: dob)
                        self?.mobileNo = mobileNo
                        self?.email = email
                        self?.aadharId = aadharId
                        self?.panCardId = panCardId
                        self?.acctNo = acctNo
                        self?.acctBalance = acctBalance
                        self?.incomeTaxNumber = incomeTaxNumber
                        self?.acctOpeningDate = acctOpeningDate
                        
                        self?.accountDetailsTv.reloadData()
                    }
                    else {
                        self?.showAlert(withTitle: receivedJSON.status_code, andMessage: receivedJSON.message, handler: { (action) in
                            if receivedJSON.status_code == "ERRO06"{self?.dismiss(animated: true, completion: {})}
                        })
                    }
                }
            }
            catch {
                DispatchQueue.main.async {
                    self?.hideActivityIndicator()
                    self?.showAlert(withTitle: AlertTitles.parsingErrorTitle, andMessage: AlertMessages.parsingErrorMessage, handler: nil)
                }
            }
        }
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
    
    private func changeDOBFormat(dob:String)->String?{
        let inputDateFormatter = DateFormatter()
        inputDateFormatter.dateFormat = "yyyy-MM-dd"
        
        let outputDateFormatter = DateFormatter()
        outputDateFormatter.dateFormat = "dd-MM-yyyy"
        
        let date = inputDateFormatter.date(from: dob) ?? Date()
        return outputDateFormatter.string(from: date)
    }
}

extension AccountDetails: UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if accountDetails != nil {
            return 10
        }
        else {
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "optionsCell") as! optionsTableViewCell
    
        switch indexPath.row {
        case 0 : cell.label.text = "Name: " + fname + " " + lname
                 cell.iconView.image = icons[indexPath.row]
            break
            
        case 1: cell.label.text = "Address: " + address
                cell.iconView.image = icons[indexPath.row]
            break
            
        case 2: cell.label.text = "Date of Birth: " + dob
                cell.iconView.image = icons[indexPath.row]
            break
            
        case 3: cell.label.text = "Mobile: " + mobileNo
                cell.iconView.image = icons[indexPath.row]
            break
            
        case 4: cell.label.text = "E-mail: " + email
                cell.iconView.image = icons[indexPath.row]
            break
            
        case 5: cell.label.text = "Aadhar Card: " + aadharId
                cell.iconView.image = icons[indexPath.row]
            break
            
        case 6: cell.label.text = "Pan Card: " + panCardId
                cell.iconView.image = icons[indexPath.row]
            break
            
        case 7: cell.label.text = "Acc No.: " + acctNo
                cell.iconView.image = icons[indexPath.row]
            break
            
        case 8:
                let formatter = NumberFormatter()
                formatter.locale = Locale(identifier: "en_IN")
                formatter.numberStyle = .decimal
                let formatted_balance = formatter.string(from: NSNumber(value: Double(acctBalance)!))
                cell.label.text = "Balance: " + "₹ " + formatted_balance!
                cell.iconView.image = icons[indexPath.row]
            break
            
        case 9: cell.label.text = "TIN: " + incomeTaxNumber
                cell.iconView.image = icons[indexPath.row]
            break
            
        case 10: cell.label.text = "Opening Date: " + acctOpeningDate
                 cell.iconView.image = icons[indexPath.row]
            break
        default:
            return cell
        }
        return cell
    }
}
