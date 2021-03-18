//
//  myWalletVC.swift
//  damnVIA
//
//  Created by Sahil on 03/03/18.
//  Copyright © 2018 lucideus. All rights reserved.
//

import UIKit

class myWalletVC: UIViewController {

    
    let indicator = UIActivityIndicatorView(style: .whiteLarge)

    let icons = [#imageLiteral(resourceName: "passbook"),#imageLiteral(resourceName: "send_money"), #imageLiteral(resourceName: "add_money")]
    let titles = ["Passbook", "Send Money", "Add Money"]
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func logoutPressed(_ sender: UIBarButtonItem) {
        
        showLogout(indicator: indicator)
    }
}

extension myWalletVC: UITableViewDataSource, UITableViewDelegate {
   
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
    
}
