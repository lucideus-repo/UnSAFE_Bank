//
//  dashboardVC.swift
//  damnVIA
//
//  Created by Sahil on 21/02/18.
//  Copyright © 2018 lucideus. All rights reserved.
//

import UIKit

class dashboardVC: UIViewController {

    @IBOutlet weak var optionsTv: UITableView!
    @IBOutlet weak var accNoLabel: UILabel!
    @IBOutlet weak var balanceLabel: UILabel!
    @IBOutlet weak var gridView: UIView!
   
    var username: String!
    let indicator = UIActivityIndicatorView(style: .whiteLarge)
    
    
    let icons = [#imageLiteral(resourceName: "account_statement"),#imageLiteral(resourceName: "beneficiary"),#imageLiteral(resourceName: "fund_transfer"),#imageLiteral(resourceName: "policy"),#imageLiteral(resourceName: "wallet"),#imageLiteral(resourceName: "password"),#imageLiteral(resourceName: "small_logo")]
    let titles = ["View Account Statement", "Beneficiaries", "Funds Transfer", "Insurance Policies", "My Wallet","Change Password","About Us"]
    let segueNames = ["viewStatementSegue", "beneficiarySegue", "transferSegue", "policySegue", "walletSegue","ChangePasswordSegue"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let userDefaults = UserDefaults.standard
        let balance = userDefaults.object(forKey: "acctBalance") as! String
        let acctNo = userDefaults.object(forKey: "acctNo") as! String
        
        let formatter = NumberFormatter()
        formatter.locale = Locale(identifier: "en_IN")
        formatter.numberStyle = .decimal
        let formatted_balance = formatter.string(from: NSNumber(value: Double(balance)!))
        
        accNoLabel.text = acctNo
        balanceLabel.text = "₹ " + formatted_balance!
        
        let gesture = UITapGestureRecognizer(target: self, action: #selector(self.gridClicked))
        self.gridView.addGestureRecognizer(gesture)
    }
    
    @objc private func gridClicked() {
        self.performSegue(withIdentifier: segues.gridSegue, sender: nil)
    }
   
    @IBAction func logoutPressed(_ sender: UIBarButtonItem) {
        
        showLogout(indicator: indicator)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        guard isBalanceChanged == true else {return}
        
        showActivityIndicator(indicator: indicator)
        APIHelpers.hitAccountDetails { [weak self] (data,error) in
            defer{isBalanceChanged = false}
            do {
                guard let data = data else {return}
                let decoder = JSONDecoder()
                //                let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String : Any]
                //                print(json!)
                let receivedJSON = try decoder.decode(accountDetailsResponseModel.self, from: data)
                print(receivedJSON)
                
                DispatchQueue.main.async {
                    self?.hideActivityIndicator(indicator: self!.indicator)
                    if receivedJSON.status == statusMessages.success {
                        
                        guard let data = receivedJSON.data else {return}
                        guard let acctBalance = data.accountBalance else {return}
                        
                        let formatter = NumberFormatter()
                        formatter.locale = Locale(identifier: "en_IN")
                        formatter.numberStyle = .decimal
                        let formatted_balance = formatter.string(from: NSNumber(value: Double(acctBalance)!))
            
                        // update the balance label
                        self?.balanceLabel.text = "₹ " + formatted_balance!
                        
                        // save the data to user defaults
                        let userDefaults = UserDefaults.standard
                        userDefaults.set(acctBalance, forKey:"acctBalance")
                        userDefaults.synchronize()
                        
                        // set global is balance changed variable to false
                        isBalanceChanged = false
                    }
                    else {
                        self?.showAlert(withTitle: receivedJSON.status_code, andMessage: receivedJSON.message, handler: nil)
                    }
                }
            }
            catch {
                DispatchQueue.main.async {
                    self?.hideActivityIndicator(indicator: self!.indicator)
                    self?.showAlert(withTitle: AlertTitles.parsingErrorTitle, andMessage: AlertMessages.parsingErrorMessage, handler: nil)
                }
            }
        }
    }
    
} //have to do viewDidAppear refresh everytime

extension dashboardVC: UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return titles.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "optionCell") as! optionsTableViewCell
        
        cell.iconView.image = icons[indexPath.row]
        cell.label.text = titles[indexPath.row]
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if indexPath.row == titles.count - 1{
            let webView = WebViewVC()
            webView.urlString = urlPathsEnum.aboutus.path
            webView.title = titles[indexPath.row]
            self.navigationController?.pushViewController(webView, animated: true)
            return
        }
        
        self.performSegue(withIdentifier: segueNames[indexPath.row], sender: nil)
    }
}
