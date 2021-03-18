//
//  ChangePasswordVC.swift
//  UnSAFE_Bank
//
//  Created by Tarun Kaushik on 30/03/20.
//  Copyright © 2020 lucideus. All rights reserved.
//

import UIKit

class ChangePasswordVC: UIViewController {
    @IBOutlet weak var oldPassTF: UITextField!
    @IBOutlet weak var newPassTF: UITextField!
    @IBOutlet weak var confirmPassTF: UITextField!
    
    var params: [String: String]! = [:]
    let indicator = UIActivityIndicatorView(style: .whiteLarge)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideKeyboardWhenTappedAround()
        confirmPassTF.delegate = self
    }
    
    @IBAction func changePasswordTapped(_ sender: Any) {
        guard let newPass = newPassTF.text else{return}
        guard let confirmPass = confirmPassTF.text else{return}
        guard let oldPass = oldPassTF.text else{return}
        
        if newPass.isEmpty || confirmPass.isEmpty && oldPass.isEmpty{
            showAlert(withTitle: "Empty Field", andMessage: "fields cannot be empty", handler: nil)
            return
        }
        
        if newPass == confirmPass {
            if !validatePassword(value: newPass) {
                displayAlert(title: "Password Policy", message: "The password should be greater than 7 characters and should include one capital, one special and one numeric character")
                return
            }
            params[JSONKeys.new_pass] = confirmPass
            params[JSONKeys.old_pass] = oldPass
        }
        else {
            displayAlert(title: "Password Mismatch", message: "The passwords entered do not match")
            return
        }
        
        guard self.checkNetworkConnectivity() else{return}
        self.showActivityIndicator(indicator: self.indicator)
        
        APIHelpers.hitChangePassword(params: params) {[weak self] (data, error) in
            
            guard let self = self else{return}
            
            guard let data = data else {
                DispatchQueue.main.async {
                    self.hideActivityIndicator(indicator: self.indicator)
                    self.showAlert(withTitle: AlertTitles.error, andMessage: error?.localizedDescription ?? "Something went wrong", handler: nil)
                }
                return
            }
            
            do{
                let decoder = JSONDecoder()
                let receivedJson = try decoder.decode(resetPasswordResponseModel.self, from: data)
                
                DispatchQueue.main.async {
                    self.hideActivityIndicator(indicator: self.indicator)
                    if receivedJson.status == statusMessages.failed{
                        self.showAlert(withTitle: receivedJson.status_code, andMessage: receivedJson.message, handler: nil)
                    }else{
                        self.showAlert(withTitle: receivedJson.status_code, andMessage: receivedJson.message) { (action) in
                            self.navigationController?.popViewController(animated: true)
                        }
                    }
                }
            }catch{
                DispatchQueue.main.async {
                    self.hideActivityIndicator(indicator: self.indicator)
                    self.showAlert(withTitle: AlertTitles.parsingErrorTitle, andMessage: AlertMessages.parsingErrorMessage, handler: nil)
                }
            }
        }
    }
    
    private func validatePassword(value: String) -> Bool {
            
        return value.count >= 1
            
        // OLD CODE
        if value.count > 7 {
            let PASSWORD_REGEX = "^(?=.*\\d)(?=.*[a-z])(?=.*[A-Z])[0-9a-zA-Z!@#$%^&*()\\-_=+{}|?>.<,:;~`’]{8,}$"
            let passwordTest = NSPredicate(format: "SELF MATCHES %@", PASSWORD_REGEX)
            let result = passwordTest.evaluate(with: value)
            return result
        }
        else {
            return false
        }
    }
    
    func displayAlert(title: String, message: String) {
        
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        self.present(alertController, animated: true, completion: nil)
        let action = UIAlertAction(title: "Ok", style: .default) { (action:UIAlertAction) in
        }
        alertController.addAction(action)
    }
    
}


extension ChangePasswordVC:UITextFieldDelegate{
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
}
