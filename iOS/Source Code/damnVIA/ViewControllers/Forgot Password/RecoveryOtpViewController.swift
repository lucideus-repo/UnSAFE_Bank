//
//  RecoveryOtpViewController.swift
//  damnVIA
//
//  Created by Sahil Pahwa on 02/08/19.
//  Copyright © 2019 lucideus. All rights reserved.
//

import UIKit
import CryptoSwift
import UserNotifications
import KeychainAccess

class RecoveryOtpViewController: UIViewController {
    
    var params: [String:String]!
    let center = UNUserNotificationCenter.current()
    let indicator = UIActivityIndicatorView(style: .whiteLarge)
    
    @IBOutlet weak var verifyOtpBtn: UIButton!
    @IBOutlet weak var otpTF: UITextField!
    
    @IBAction func verifyOtpPressed(_ sender: UIButton) {
        
        self.showActivityIndicator(indicator: indicator)
       
        guard let enteredOtp = otpTF.text else {return}
        guard let user_id = params[JSONKeys.userId] else {return}
        guard self.checkNetworkConnectivity() else{return}
        
        APIHelpers.hitVerifyOtp(otp: enteredOtp, otp_type: 0, user_id: user_id) { [weak self] (data,error) in
        
            guard let data = data else {
                DispatchQueue.main.async {
                    self?.hideActivityIndicator(indicator: self!.indicator)
                    self?.showAlert(withTitle: AlertTitles.error, andMessage: error?.localizedDescription ?? "Something went wrong", handler: nil)
                }
                return
            }
            do {
               // guard let data = data else {return}//
                let decoder = JSONDecoder()
                let receivedJSON = try decoder.decode(verifyOtpResponseModel.self, from: data)
                //print(receivedJSON)
                DispatchQueue.main.async {
                    if receivedJSON.status == statusMessages.failed {
                        self?.showAlert(withTitle: receivedJSON.status_code, andMessage: receivedJSON.message, handler: {(action) in
                        })
                        self?.hideActivityIndicator(indicator: self!.indicator)
                    }
                    else {
                        guard let res = receivedJSON.data else {return}
                        self?.params[JSONKeys.otpResponse] = res.response
                        self?.hideActivityIndicator(indicator: self!.indicator)
                        // move to next screen when the OTP is verified
                        self?.performSegue(withIdentifier: segues.confirmPasswordSegue, sender: nil)
                    }
                }}
            catch {
                DispatchQueue.main.async {
                    self?.hideActivityIndicator(indicator: self!.indicator)
                    self?.showAlert(withTitle: AlertTitles.parsingErrorTitle, andMessage: AlertMessages.parsingErrorMessage, handler: nil)
                }
                return
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == segues.confirmPasswordSegue {
            let vc = segue.destination as! RecoverPasswordViewController
            vc.params = params
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        guard let params = params else {return}
        guard let encrypted_otp = params[JSONKeys.otpResponse] else {
            verifyOtpBtn.isEnabled = false
            return
        }
        let otp = decryptOTP(otp: encrypted_otp)
        self.hideKeyboardWhenTappedAround()
        guard let checkOtp = otp else {return}
        self.sendOTPNotification(with: checkOtp)
        otpTF.delegate = self
        verifyOtpBtn.isEnabled = false
        verifyOtpBtn.backgroundColor = UIColor.lightGray
    }
    
    func decryptOTP(otp: String) -> String? {
        do {
            let keychain = Keychain(service: keychainService.service)
            let key = try keychain.getString("encryption_key")
            let iv = try keychain.getString("iv")
            let data = Data(base64Encoded: otp, options: .init(rawValue: 0))
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
        let content = UNMutableNotificationContent()
        content.title = "Here's your OTP"
        content.body = """
        Your One Time Password is \(otp.trimmingCharacters(in: .whitespacesAndNewlines)). Do not share this OTP for security reasons.
        """
        content.sound = UNNotificationSound.default
        //content.badge = 1
        //generate random time interval
        let time = Double.random(in: 2..<7)
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: time,repeats: false)
        let identifier = "My Local Notification"
        let request = UNNotificationRequest(identifier: identifier, content: content, trigger: trigger)
        center.add(request, withCompletionHandler: { (error) in
            if error != nil {
                // Something went wrong
            }
        })
    }
}

extension RecoveryOtpViewController:UITextFieldDelegate{
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        let otpText = string != "" ? ((textField.text ?? "") + string) : String((textField.text ?? " ").dropLast())
        
        guard otpText.count <= 6 else{return false}
        
        verifyOtpBtn.isEnabled = (otpText.count == 6) ? true : false
        verifyOtpBtn.backgroundColor = (otpText.count == 6) ? UIColor(displayP3Red: 1.0/255.0, green: 97.0/255.0, blue: 145.0/255.0, alpha: 1.0) : UIColor.lightGray
        
        return true
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        verifyOtpBtn.isEnabled = false
        verifyOtpBtn.backgroundColor = UIColor.lightGray
    }
}
