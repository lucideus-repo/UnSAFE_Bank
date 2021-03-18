//
//  VerifyOtpVC.swift
//  damnVIA
//
//  Created by Sahil Pahwa on 14/02/19.
//  Copyright © 2019 lucideus. All rights reserved.
//

import UIKit
import CryptoSwift
import UserNotifications
import KeychainAccess

enum OtpVerificationType:Int{
    case AddBeneficiary = 0
    case DeleteBeneficiary
}

class VerifyOtpVC: UIViewController {
    
    @IBOutlet weak var otpTF: UITextField!
    var encrypted_otp: String!
    var params: [String: String]!
    var otpType:OtpVerificationType!
    let center = UNUserNotificationCenter.current()
    let indicator = UIActivityIndicatorView(style: .whiteLarge)
    @IBOutlet weak var verifyOTPButton: UIButton!
    
    @IBAction func verifyOTPPressed(_ sender: UIButton) {
        
        //print(params)
        self.showActivityIndicator(indicator: indicator)
        guard let enteredOtp = otpTF.text else {return}
        guard self.checkNetworkConnectivity() else{return}
        APIHelpers.hitVerifyOtp(otp: enteredOtp, otp_type: 1, user_id: nil) { [weak self] (data,error) in
        
            guard let data = data else {
                DispatchQueue.main.async {
                    self?.hideActivityIndicator(indicator: self!.indicator)
                    self?.showAlert(withTitle: AlertTitles.error, andMessage: error?.localizedDescription ?? "Something went wrong", handler: nil)
                }
                return
            }
            
            
            do {
               // guard let data = data else {return}
                let decoder = JSONDecoder()
                let receivedJSON = try decoder.decode(verifyOtpResponseModel.self, from: data)
                print(receivedJSON)
                DispatchQueue.main.async {
                    if receivedJSON.status == statusMessages.failed {
                        if receivedJSON.status_code == "ERR006" { //logout
                            self?.showAlert(withTitle: receivedJSON.status_code, andMessage: receivedJSON.message, handler: {(action) in
                                self?.navigationController?.popToRootViewController(animated: true) //logout
                            })
                        }else{
                            self?.showAlert(withTitle: receivedJSON.status_code, andMessage: receivedJSON.message + " " + (receivedJSON.data?.response ?? ""), handler: {(action) in
                                //perform some action here like, going back.
                                self?.hideActivityIndicator(indicator: self!.indicator)
                            })
                        }
                    }
                    else {
                        guard let res = receivedJSON.data else {return}
                        // make request to add beneficiary when the OTP is verified
                        self?.params[JSONKeys.otpResponse] = res.response
                        switch self?.otpType{
                        case .AddBeneficiary:
                            self?.makeAddBeneficiaryRequest()
                            break
                        case .DeleteBeneficiary:
                            self?.hitDeleteBeneficiaryRequest()
                            break
                        case .none:
                            break
                        }
                    }
                }
            }
            catch {
                DispatchQueue.main.async {
                    self?.hideActivityIndicator(indicator: self!.indicator)
                    self?.showAlert(withTitle: AlertTitles.parsingErrorTitle, andMessage: AlertMessages.parsingErrorMessage, handler: nil)
                }
                return
            }
        }
    }
    
    private func makeAddBeneficiaryRequest() {
        guard self.checkNetworkConnectivity() else{return}
        APIHelpers.hitAddBeneficiary(params: params) { [weak self] (data,error) in
        
            guard let data = data else {
                DispatchQueue.main.async {
                  //  self?.hideActivityIndicator()
                    self?.showAlert(withTitle: AlertTitles.error, andMessage: error?.localizedDescription ?? "Something went wrong", handler: nil)
                }
                return
            }
            
            
            do {
               // guard let data = data else {return}
                let decoder = JSONDecoder()
                let receivedJSON = try decoder.decode(addBnfcResponseModel.self, from: data)
                print(receivedJSON)
                DispatchQueue.main.async {
                    self?.hideActivityIndicator(indicator: self!.indicator)
                    if receivedJSON.status == statusMessages.failed {
                        if receivedJSON.status_code == "ERR006" { //logout
                            self?.showAlert(withTitle: receivedJSON.status_code, andMessage: receivedJSON.message, handler: {(action) in
                                self?.navigationController?.popToRootViewController(animated: true) //logout
                            })
                        }
                        else {
                            self?.showAlert(withTitle: receivedJSON.status_code, andMessage: receivedJSON.message, handler: nil)
                        }
                    }
                    else {
                        if receivedJSON.status == statusMessages.success {
                            self?.showAlert(withTitle: "Add Beneficiary", andMessage: "Beneficiary added successfully", handler: ({ (action) in
                                
                                self?.navigationController?.popToViewController(ofClass: beneficiaryVC.self)
                            }))
                        }
                        else {
                            self?.showAlert(withTitle: receivedJSON.status_code, andMessage: receivedJSON.message, handler: nil)
                        }
                    }
                }
            }
            catch {
                DispatchQueue.main.async {
                    self?.hideActivityIndicator(indicator: self!.indicator)
                    self?.showAlert(withTitle: AlertTitles.parsingErrorTitle, andMessage: AlertMessages.parsingErrorMessage, handler: nil)
                }
                return
            }
        }
    }
    
    
    private func hitDeleteBeneficiaryRequest(){
        guard self.checkNetworkConnectivity() else{return}
        
        APIHelpers.deleteBeneficiary(params: params) { [weak self] (data,error) in
        
            guard let data = data else {
                DispatchQueue.main.async {
                  //  self?.hideActivityIndicator()
                    self?.showAlert(withTitle: AlertTitles.error, andMessage: error?.localizedDescription ?? "Something went wrong", handler: nil)
                }
                return
            }
            
            
            do {
               // guard let data = data else {return}
                let decoder = JSONDecoder()
                let receivedJSON = try decoder.decode(addBnfcResponseModel.self, from: data)
                print(receivedJSON)
                DispatchQueue.main.async {
                    self?.hideActivityIndicator(indicator: self!.indicator)
                    if receivedJSON.status == statusMessages.failed {
                        if receivedJSON.status_code == "ERR006" { //logout
                            self?.showAlert(withTitle: receivedJSON.status_code, andMessage: receivedJSON.message, handler: {(action) in
                                self?.navigationController?.popToRootViewController(animated: true) //logout
                            })
                        }
                        else {
                            self?.showAlert(withTitle: receivedJSON.status_code, andMessage: receivedJSON.message, handler: nil)
                        }
                    }
                    else {
                        if receivedJSON.status == statusMessages.success {
                            self?.showAlert(withTitle: "Add Beneficiary", andMessage: "Beneficiary added successfully", handler: ({ (action) in
                                
                                self?.navigationController?.popToViewController(ofClass: ListBeneficiary.self)
                            }))
                        }
                        else {
                            self?.showAlert(withTitle: receivedJSON.status_code, andMessage: receivedJSON.message, handler: nil)
                        }
                    }
                }
            }
            catch {
                DispatchQueue.main.async {
                    self?.hideActivityIndicator(indicator: self!.indicator)
                    self?.showAlert(withTitle: AlertTitles.parsingErrorTitle, andMessage: AlertMessages.parsingErrorMessage, handler: nil)
                }
                return
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let otp = decryptOTP()
        self.hideKeyboardWhenTappedAround()
        guard let checkOtp = otp else {return}
        self.sendOTPNotification(with: checkOtp)
        otpTF.delegate = self
        verifyOTPButton.isEnabled = false
        verifyOTPButton.backgroundColor = UIColor.lightGray
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
}

extension VerifyOtpVC:UITextFieldDelegate{
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        let otpText = string != "" ? ((textField.text ?? "") + string) : String((textField.text ?? " ").dropLast())
        
        guard otpText.count <= 6 else{return false}
        
        verifyOTPButton.isEnabled = (otpText.count == 6) ? true : false
        verifyOTPButton.backgroundColor = (otpText.count == 6) ? UIColor(displayP3Red: 1.0/255.0, green: 97.0/255.0, blue: 145.0/255.0, alpha: 1.0) : UIColor.lightGray
        
        return true
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        verifyOTPButton.isEnabled = false
        verifyOTPButton.backgroundColor = UIColor.lightGray
    }
}
