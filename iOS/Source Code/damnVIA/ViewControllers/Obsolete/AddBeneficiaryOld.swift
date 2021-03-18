//
//  AddBeneficiary.swift
//  damnVIA
//
//  Created by Sahil Pahwa on 18/09/18.
//  Copyright © 2018 lucideus. All rights reserved.
//

import UIKit

class AddBeneficiaryOld: UIViewController {

//    @IBOutlet weak var beneficiaryTv: UITableView!
//
//    var beneficiaries: [addBeneficiaryData1]!
//    let indicator = UIActivityIndicatorView(style: .whiteLarge)
//    var selected: String!
//
//
//
//    override func viewDidLoad() {
//        super.viewDidLoad()
//    }
//
//    private func showActivityIndicator() {
//        indicator.center = self.view.center
//        indicator.hidesWhenStopped = true
//        indicator.color = UIColor.darkGray
//        indicator.startAnimating()
//        self.view.addSubview(indicator)
//    }
//
//
//    private func hideActivityIndicator() {
//        indicator.stopAnimating()
//    }
//
//    override func viewWillAppear(_ animated: Bool) {
//        super.viewWillAppear(animated)
//
//        showActivityIndicator()
//        APIHelpers.hitAddBeneficiary(completionHandler: { [weak self] (data) in
//            do {
//                guard let data = data else {return}
//                let decoder = JSONDecoder()
////                                    let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String : Any]
////                                    print(json)
//                let receivedJSON = try decoder.decode(addBeneficiaryResponseModel.self, from: data)
//                DispatchQueue.main.async {
//                    self?.hideActivityIndicator()
//                    if receivedJSON.status == statusMessages.failed {
//                        self?.showAlert(withTitle: receivedJSON.status_code, andMessage: receivedJSON.message)
//                    }
//                    else {
//                        guard let data = receivedJSON.data else {return}
//                        self?.beneficiaries = data.bnfc
//                        self?.beneficiaryTv.reloadData()
//                    }
//                }
//            }
//            catch {
//                DispatchQueue.main.async {
//                    self?.hideActivityIndicator()
//                    self?.showAlert(withTitle: AlertTitles.parsingErrorTitle, andMessage: AlertMessages.parsingErrorMessage)
//                }
//                return
//            }
//        })
//    }
//}
//
//extension AddBeneficiary: UITableViewDataSource, UITableViewDelegate {
//
//    func numberOfSections(in tableView: UITableView) -> Int {
//        return 1
//    }
//
//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//
//        if beneficiaries != nil {
//            return beneficiaries.count
//        }
//        else {
//            return 0
//        }
//    }
//
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        let cell = tableView.dequeueReusableCell(withIdentifier: "optionsCell") as! optionsTableViewCell
//
//        cell.label.text = beneficiaries[indexPath.row].fname
//
//        return cell
//    }
//
//    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        selected = beneficiaries[indexPath.row].acctNo
//        self.performSegue(withIdentifier: segues.viewSelectedBeneficiary, sender: nil)
//    }
//
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//
//        if segue.identifier == segues.viewSelectedBeneficiary {
//            let vc = segue.destination as! viewSelectedBeneficiary
//            vc.accNo = selected
//        }
//    }
}
