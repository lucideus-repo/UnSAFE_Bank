//
//  accountStatementVC.swift
//  damnVIA
//
//  Created by Sahil on 26/02/18.
//  Copyright © 2018 lucideus. All rights reserved.
//

import UIKit

class accountStatementVC: UIViewController {

    let indicator = UIActivityIndicatorView(style: .whiteLarge)
    var data: [accountStatementDetailsArray]!

    override func viewDidLoad() {
        super.viewDidLoad()

        
        // Do any additional setup after loading the view.
    }
    
    @IBAction func logoutPressed(_ sender: UIBarButtonItem) {
        
        showLogout(indicator: indicator)
    }
}

extension accountStatementVC: UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if data != nil {
            return data.count
        }
        else {
            return 0
        }
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "statementCell") as! accountStatementTableViewCell
        
        cell.amount.text = String(describing: data[indexPath.row].amount ?? "--")//"₹ 1,000.00"
        //cell.closingBalance.text = data[indexPath.row]."₹ 2,000.00"
        cell.date.text = String(describing: data[indexPath.row].tDate ?? "--")//"28 Feb 2018"
        cell.narration.text = String(describing: data[indexPath.row].remarks ?? "--")//"This is a dummy transaction!"
        cell.refNumber.text = String(describing: data[indexPath.row].referenceNo ?? "--")//"0948394402422"
        cell.transactionType.text = String(describing: data[indexPath.row].type ?? "--")//"Deposit"
        cell.valueDate.text = String(describing: data[indexPath.row].tDate ?? "--")//"28 Feb 2018"
        
        return cell
    }
}
