//
//  fundsTransferVC.swift
//  damnVIA
//
//  Created by Sahil on 26/02/18.
//  Copyright © 2018 lucideus. All rights reserved.
//

import UIKit

class fundsTransferVC: UIViewController {

    let icons = [#imageLiteral(resourceName: "transfer1"), #imageLiteral(resourceName: "transfer2")]
    let titles = ["Bank Transfer", "To wallet"]
    
    let segueNames = ["bankTransferSegue", "walletTransferSegue"]
    let indicator = UIActivityIndicatorView(style: .whiteLarge)

    
    @IBOutlet weak var optionsTv: UITableView!
   
    @IBAction func logoutPressed(_ sender: UIBarButtonItem) {
        
        showLogout(indicator: indicator)
    }

    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
}

extension fundsTransferVC: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return titles.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "fundsOptionsCell") as! fundsTransferTableViewCell
        
        cell.iconView.image = icons[indexPath.row]
        cell.label.text = titles[indexPath.row]
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.performSegue(withIdentifier: segueNames[indexPath.row], sender: nil)
    }
}
