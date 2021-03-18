//
//  RecoverPasswordViewController.swift
//  damnVIA
//
//  Created by Sahil Pahwa on 05/08/19.
//  Copyright © 2019 lucideus. All rights reserved.
//

import UIKit

class RecoverPasswordViewController: UIViewController {
    
    var params: [String: String]!
    let indicator = UIActivityIndicatorView(style: .whiteLarge)
    
    @IBOutlet weak var enterPasswordTF: UITextField!
    @IBOutlet weak var reenterPasswordTF: UITextField!
    
    private func validatePassword(value: String) -> Bool {
        
        return value.count >= 1
        
        // OLD CODE
//        if value.count > 7 {
//            let PASSWORD_REGEX = "^(?=.*\\d)(?=.*[a-z])(?=.*[A-Z])[0-9a-zA-Z!@#$%^&*()\\-_=+{}|?>.<,:;~`’]{8,}$"
//            let passwordTest = NSPredicate(format: "SELF MATCHES %@", PASSWORD_REGEX)
//            let result = passwordTest.evaluate(with: value)
//            return result
//        }
//        else {
//            return false
//        }
    }
    
    func displayAlert(title: String, message: String) {
        
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        self.present(alertController, animated: true, completion: nil)
        let action = UIAlertAction(title: "Ok", style: .default) { (action:UIAlertAction) in
        }
        alertController.addAction(action)
    }
    
    @IBAction func changePasswordPressed(_ sender: UIButton) {
        
        guard let enterPassword = enterPasswordTF.text else {return}
        guard let reenterPassword = reenterPasswordTF.text else {return}
        
        if enterPassword == reenterPassword {
            if !validatePassword(value: enterPassword) {
                displayAlert(title: "Password Policy", message: "The password should be greater than 7 characters and should include one capital, one special and one numeric character")
                return
            }
            params[JSONKeys.newPassword] = reenterPassword
        }
        else {
            displayAlert(title: "Password Mismatch", message: "The passwords entered do not match")
            return
        }
        
        guard self.checkNetworkConnectivity() else{return}
        
        self.showActivityIndicator(indicator: self.indicator)
        
        APIHelpers.passwordReset(params: params) { [weak self] (data,error) in
        
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
                let receivedJSON = try decoder.decode(resetPasswordResponseModel.self, from: data)
                DispatchQueue.main.async {
                    self?.hideActivityIndicator(indicator: self!.indicator)
                    if receivedJSON.status == statusMessages.failed {
                        self?.showAlert(withTitle: receivedJSON.status_code, andMessage: receivedJSON.message, handler: nil)
                    }
                    else {
                        self?.showAlert(withTitle: receivedJSON.status_code, andMessage: receivedJSON.message, handler: {(action) in
                            
                            self?.dismiss(animated: true, completion: nil)
                        })
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
            self.hideKeyboardWhenTappedAround()
        }
}

