//
//  BankTransferVC5.swift
//  damnVIA
//
//  Created by Sahil Pahwa on 24/03/19.
//  Copyright © 2019 lucideus. All rights reserved.
//

import UIKit
import CryptoSwift
import UserNotifications
import KeychainAccess

class BankTransferVC5: UIViewController {

    @IBOutlet weak var otpTF: UITextField!
    @IBOutlet weak var verifyOtpButton: UIButton!
    
    var alias: String!
    var remarks: String!
    var amount: String!
    
    var encrypted_otp: String!
    let center = UNUserNotificationCenter.current()
    let indicator = UIActivityIndicatorView(style: .whiteLarge)
    
    @IBAction func cancelPressed(_ sender: UIBarButtonItem) {
        
        let alert = UIAlertController(title: "Ongoing Transaction", message: "Are you sure you want to cancel this transaction?", preferredStyle: .alert)
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { (cancelAction) in
            
        }
        
        let yesAction = UIAlertAction(title: "Yes", style: .default) { [weak self] (yesAction) in
            self?.navigationController?.popToViewController(ofClass: fundsTransferVC.self)
        }
        
        alert.addAction(cancelAction)
        alert.addAction(yesAction)
        
        self.present(alert, animated: true, completion: nil)
    }
    
    @IBAction func verifyOTPPressed(_ sender: UIButton) {
        
        //print(params)
        guard self.checkNetworkConnectivity() else{return}
        self.showActivityIndicator(indicator: indicator)
        guard let enteredOtp = otpTF.text else {return}
        APIHelpers.hitVerifyOtp(otp: enteredOtp, otp_type: 1, user_id: nil) { [weak self] (data,error) in
            
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
                let receivedJSON = try decoder.decode(verifyOtpResponseModel.self, from: data)
                //print(receivedJSON)
                DispatchQueue.main.async {
                    self.hideActivityIndicator(indicator: self.indicator)
                    if receivedJSON.status == statusMessages.failed {
                        if receivedJSON.status_code == "ERR006" { //logout
                            self.showAlert(withTitle: receivedJSON.status_code, andMessage: receivedJSON.message, handler: {(action) in
                                self.navigationController?.popToRootViewController(animated: true) //logout
                            })
                        }
                    }
                    else {
                        guard let res = receivedJSON.data else {return}
                        self.performSegue(withIdentifier: segues.paymentProcess, sender: [JSONKeys.alias: self.alias, JSONKeys.amount: self.amount, JSONKeys.remarks: self.remarks, JSONKeys.otpResponse: res.response])
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let otp = decryptOTP()
        guard let checkOtp = otp else {return}
        self.sendOTPNotification(with: checkOtp)
        self.hideKeyboardWhenTappedAround()
        self.navigationItem.hidesBackButton = true
        
        otpTF.delegate = self
        verifyOtpButton.isEnabled = false
        verifyOtpButton.backgroundColor = UIColor.lightGray
    }
    
    func decryptOTP() -> String? {
        do {
            let keychain = Keychain(service: keychainService.service)
            let key = try keychain.getString("encryption_key")
            let iv = try keychain.getString("iv")
            let data = Data(base64Encoded: encrypted_otp, options: .init(rawValue: 0))
            let dec = try AES(key: key!, iv: iv!, padding: .zeroPadding).decrypt((data?.bytes)!)
            let decData = Data(bytes: dec, count: dec.count)
            let decryptedData = String(data: decData, encoding: String.Encoding.utf8)
            guard let otp = decryptedData else {return nil}
            return otp
        }
            
        catch {
            showAlert(withTitle: "Encryption Error", andMessage: "Something went wrong", handler: nil)
            return nil
        }
    }
    
    func sendOTPNotification(with otp: String) {
        center.getNotificationSettings { (settings) in
            if settings.authorizationStatus != .authorized {
                self.openAppSettings()
                return
            }
        }
        
        let content = UNMutableNotificationContent()
        content.title = "Here's your OTP"
        content.body = """
        Your One Time Password is \(otp.trimmingCharacters(in: .whitespacesAndNewlines)). Do not share this OTP for security reasons.
        """
        content.sound = UNNotificationSound.default
        //content.badge = 1
        //generate random time interval
        let time = Double.random(in: 2..<7)
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: time,
                                                        repeats: false)
        
        let identifier = "My Local Notification"
        let request = UNNotificationRequest(identifier: identifier, content: content, trigger: trigger)
        center.add(request, withCompletionHandler: { (error) in
            if error != nil {
                // Something went wrong
            }
        })
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == segues.paymentProcess {
            
            let params = sender as? NSDictionary
            let vc = segue.destination as! BankTransferVC6
            vc.params = params as? [String : String]
        }
    }
}


extension BankTransferVC5:UITextFieldDelegate{
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let otpText = string != "" ? ((textField.text ?? "") + string) : String((textField.text ?? " ").dropLast())
        
        guard otpText.count <= 6 else{return false}
        
        verifyOtpButton.isEnabled = (otpText.count == 6) ? true : false
        verifyOtpButton.backgroundColor = (otpText.count == 6) ? UIColor(displayP3Red: 1.0/255.0, green: 97.0/255.0, blue: 145.0/255.0, alpha: 1.0) : UIColor.lightGray
        
        return true
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
      verifyOtpButton.isEnabled = false
      verifyOtpButton.backgroundColor = UIColor.lightGray
    }
}
