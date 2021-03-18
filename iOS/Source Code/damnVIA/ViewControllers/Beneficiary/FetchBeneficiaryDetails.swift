//
//  viewBeneficiaryVC.swift
//  damnVIA
//
//  Created by Sahil on 26/02/18.
//  Copyright © 2018 lucideus. All rights reserved.
//

import UIKit

class FetchBeneficiaryDetails: UIViewController {

    @IBOutlet weak var beneficiaryTv: UITableView!
    @IBOutlet weak var deleteButton: UIButton!
    let indicator = UIActivityIndicatorView(style: .whiteLarge)
    var details: fetchBnfcData!
    var alias: String!
    var encrypted_otp: String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.deleteButton.isHidden = true
        // Do any additional setup after loading the view.
    }
    
    @IBAction func deleteBtnAction(_ sender: Any) {
        self.hitGetOTPAPI(alias)
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        guard self.checkNetworkConnectivity() else{return}
        showActivityIndicator()
        
        APIHelpers.fetchSelectedBeneficiary(alias: alias) { [weak self] (data,error) in
        
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
                let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String : Any]
                print(json!)
                let receivedJSON = try decoder.decode(fetchBnfcResponseModel.self, from: data)
                print(receivedJSON)
                
                DispatchQueue.main.async {
                    self?.hideActivityIndicator()
                    if receivedJSON.status == statusMessages.success {
                        guard let data = receivedJSON.data else {return}
                        guard let _ = data.alias else{
                            self?.showAlert(withTitle: "Error", andMessage: "No Beneficiary Details Found", handler: { (action) in
                                self?.navigationController?.popViewController(animated: true)
                            })
                            return
                        }
                        self?.details = data
                        self?.beneficiaryTv.reloadData()
                        self?.deleteButton.isHidden = false
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
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == segues.deleteBeneficaryOTP {
            let params = sender as? NSDictionary
            let vc = segue.destination as! VerifyOtpVC
            vc.encrypted_otp = encrypted_otp
            vc.otpType = .DeleteBeneficiary
            vc.params = params as? [String : String]
        }
    }
    
    fileprivate func hitGetOTPAPI(_ alias: String) {
        guard self.checkNetworkConnectivity()else{return}
        self.showActivityIndicator()
        APIHelpers.hitGetOtp(otp_type: OtpType.deleteBeneficiary) { [weak self] (data,error) in
            
            guard let self = self else{return}
            
            guard let data = data else {
                DispatchQueue.main.async {
                    self.hideActivityIndicator()
                    self.showAlert(withTitle: AlertTitles.error, andMessage: error?.localizedDescription ?? "Something went wrong", handler: nil)
                }
                return
            }
            
            do {
                //  guard let data = data else {return}
                let decoder = JSONDecoder()
                //                let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String : Any]
                //                print(json)
                let receivedJSON = try decoder.decode(getOtpResponseModel.self, from: data)
                //print(receivedJSON)
                DispatchQueue.main.async {
                    self.hideActivityIndicator()
                    if receivedJSON.status == statusMessages.failed {
                        self.showAlert(withTitle: receivedJSON.status_code, andMessage: receivedJSON.message, handler: nil)
                    }
                    else {
                        guard let data = receivedJSON.data else {return}
                        self.encrypted_otp = data.response
                        self.performSegue(withIdentifier: segues.deleteBeneficaryOTP, sender: [JSONKeys.alias: alias])
                    }
                }
            }
            catch {
                DispatchQueue.main.async {
                    self.hideActivityIndicator()
                    self.showAlert(withTitle: AlertTitles.parsingErrorTitle, andMessage: AlertMessages.parsingErrorMessage, handler: nil)
                }
                return
            }
        }
    }
}

extension FetchBeneficiaryDetails: UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
//        if availBenef != nil {
//            return availBenef.count
//        }
//        else {
//            return 0
//        }
        if details != nil {
            return 1
        }
        else {
            return 0
        }
    }
    
    private func changeDateFormat(dob:String?)->String?{
        guard let dateOfBirth = dob else{return ""}
        
        let inputDateFormatter = DateFormatter()
        inputDateFormatter.dateFormat = "yyyy-mm-dd HH:mm:ss"
        
        let outputDateFormatter = DateFormatter()
        outputDateFormatter.dateFormat = "dd-MM-yyyy"
        
        let date = inputDateFormatter.date(from: dateOfBirth) ?? Date()
        return outputDateFormatter.string(from: date)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "beneficiaryCell") as! viewBeneficiaryTableViewCell
        
        cell.accountNumber.text = details.accountNumber
        cell.accountType.text = changeDateFormat(dob: details.creationDateTime)
        cell.ifscCode.text = details.ifscCode
        cell.beneficiaryName.text = details.alias
//        cell.email.text = details.email
//        cell.date.text = details.creationDateTime
        return cell
    }
    
    
}
