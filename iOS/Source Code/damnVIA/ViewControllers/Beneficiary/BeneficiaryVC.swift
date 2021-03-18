//
//  beneficiaryVC.swift
//  damnVIA
//
//  Created by Sahil on 26/02/18.
//  Copyright © 2018 lucideus. All rights reserved.
//

import UIKit

class beneficiaryVC: UIViewController {

    @IBOutlet weak var optionsTv: UITableView!
    
    let icons = [#imageLiteral(resourceName: "add_b"), #imageLiteral(resourceName: "view_b")]
    let titles = ["Add Beneficiary", "View Beneficiaries"]
    let segueNames = ["addBeneficiarySegue", "viewBeneficiarySegue"]
    let indicator = UIActivityIndicatorView(style: .whiteLarge)
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func logoutPressed(_ sender: UIBarButtonItem) {
        
        showLogout(indicator: indicator)
    }
}

extension beneficiaryVC: UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return titles.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "optionsCell") as! beneficiaryTableViewCell
        
        cell.iconView.image = icons[indexPath.row]
        cell.label.text = titles[indexPath.row]
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        self.performSegue(withIdentifier: segueNames[indexPath.row], sender: nil)
    }
}
