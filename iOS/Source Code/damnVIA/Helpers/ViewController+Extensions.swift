//
//  ViewController+Extensions.swift
//  damnVIA
//
//  Created by Sahil Pahwa on 08/01/19.
//  Copyright © 2019 lucideus. All rights reserved.
//

import Foundation
import UIKit

extension UIViewController {
    
    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
       // tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
    func showActivityIndicator(indicator: UIActivityIndicatorView) {
        indicator.center = self.view.center
        indicator.hidesWhenStopped = true
        indicator.color = UIColor.darkGray
        indicator.startAnimating()
        self.view.addSubview(indicator)
    }
    
    func hideActivityIndicator(indicator: UIActivityIndicatorView) {
        indicator.stopAnimating()
    }
    
    func showAlert(withTitle title: String, andMessage message: String?, handler: ((UIAlertAction)-> Void)?) {
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: handler))
        self.present(alert, animated: true, completion: nil)
    }
    
    func showAlertForConnection(handler: ((UIAlertAction)-> Void)?){
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.tabStops = [NSTextTab(textAlignment: .justified, location: 15.0, options: [:])]
        paragraphStyle.defaultTabInterval = 15
        paragraphStyle.firstLineHeadIndent = 0
        paragraphStyle.headIndent = 15
        paragraphStyle.lineSpacing = 2
        
        let messageText = NSMutableAttributedString(string: """

        Make sure:
        •\tThe server IP address and port is correct.
        •\tThe device is connected to same network.
        •\tThe server is up and running.

        """, attributes: [NSAttributedString.Key.paragraphStyle :  paragraphStyle,NSAttributedString.Key.font: UIFont.systemFont(ofSize: 14)])
        
        let alert = UIAlertController(title: "Connection Error", message: nil, preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: handler))
        alert.setValue(messageText, forKey: "attributedMessage")
        self.present(alert, animated: true, completion: nil)
    }
    
    func showLogout(indicator: UIActivityIndicatorView) {

        let alertController = UIAlertController(title: "Logout", message: "Are you sure you want to logout?", preferredStyle: .alert)
        
        let noAction = UIAlertAction(title: "No", style: .default, handler: nil)
        let yesAction = UIAlertAction(title: "Yes", style: .default) { [weak self](action) in
            self?.hitLogout(indicator: indicator)
        }
        alertController.addAction(noAction)
        alertController.addAction(yesAction)
        self.present(alertController, animated: true, completion: nil)

    }
    
    func checkNetworkConnectivity()->Bool{
        guard APIHelpers.isConnectedToInternet() else{
              self.showAlert(withTitle: AlertTitles.error, andMessage: AlertMessages.noInternetConnection, handler: nil)
              return false
          }
        
        return true
    }
    
    func openAppSettings(){
        let alertController = UIAlertController (title: "Notification", message: "Kindly enable push notification in order to receive OTP", preferredStyle: .alert)

        let settingsAction = UIAlertAction(title: "Settings", style: .default) { (_) -> Void in

            guard let settingsUrl = URL(string: UIApplication.openSettingsURLString) else {
                return
            }

            if UIApplication.shared.canOpenURL(settingsUrl) {
                UIApplication.shared.open(settingsUrl, completionHandler: { (success) in
                    print("Settings opened: \(success)") // Prints true
                })
            }
        }
        
        alertController.addAction(settingsAction)
        let cancelAction = UIAlertAction(title: "Cancel", style: .default, handler: nil)
        alertController.addAction(cancelAction)

        present(alertController, animated: true, completion: nil)
    }
    
    func checkNotificationAllowed(_ completion:@escaping (Bool)->()){
        let center = UNUserNotificationCenter.current()
        center.getNotificationSettings {[weak self] (settings) in
            DispatchQueue.main.async {
                if settings.authorizationStatus != .authorized {
                    self?.openAppSettings()
                    completion(false)
                }else{
                   completion(true)
                }
            }
         }
    }
    
    func hitLogout(indicator: UIActivityIndicatorView) {
        
        guard self.checkNetworkConnectivity() else{return}
        
        self.showActivityIndicator(indicator: indicator)
        
        APIHelpers.hitLogout { [weak self] (data,error) in
        
            guard let data = data else {
                DispatchQueue.main.async {
                    self?.hideActivityIndicator(indicator: indicator)
                    self?.showAlert(withTitle: AlertTitles.error, andMessage: error?.localizedDescription ?? "Something went wrong", handler: nil)
                }
                return
            }
            
            
            do {
               // guard let data = data else {return}
                let decoder = JSONDecoder()
                let receivedJSON = try decoder.decode(logoutResponseModel.self, from: data)
                print(receivedJSON)
                
                DispatchQueue.main.async {
                    self?.hideActivityIndicator(indicator: indicator)
                    if receivedJSON.status == statusMessages.success {
                        self?.dismiss(animated: true, completion: {
                            
                        })
                    }
                    else {
                        self?.showAlert(withTitle: receivedJSON.status_code, andMessage: receivedJSON.message, handler: nil)
                    }
                }
            }
            catch {
                DispatchQueue.main.async {
                    self?.hideActivityIndicator(indicator: indicator)
                    self?.showAlert(withTitle: AlertTitles.parsingErrorTitle, andMessage: AlertMessages.parsingErrorMessage, handler: nil)
                }
            }
        }
    }
}


extension UINavigationController {
    
    func popToViewController(ofClass: AnyClass, animated: Bool = true) {
        if let vc = viewControllers.filter({$0.isKind(of: ofClass)}).last {
            popToViewController(vc, animated: animated)
        }
    }
}
