//
//  ViewController.swift
//  damnVIA
//
//  Created by Sahil on 18/02/18.
//  Copyright © 2018 lucideus. All rights reserved.
//

import UIKit
import Alamofire
//import AVKit

class ViewController: UIViewController {

    @IBOutlet weak var customeridTF: UITextField!
    @IBOutlet weak var passwordTF: UITextField!
    @IBOutlet weak var signupBtn: UIButton!
    @IBAction func changeConnection(_ sender: UIButton) {
        setupIPAlertView()
        return
    }
    
    var center = UNUserNotificationCenter.current()
    var loginResponse: loginResponseModel!
    var alamofireManager:SessionManager?
    var validConnection:Bool = true
    let indicator = UIActivityIndicatorView(style: .whiteLarge)
    
    @IBAction func signUpPressed(_ sender: UIButton) {
       // guard validConnection else{return}
        guard !globalIP.isEmpty else{self.setupIPAlertView();return}
        self.performSegue(withIdentifier: segues.signUpSegue, sender: nil)
    }
    
    @IBAction func recoveryPressed(_ sender: UIButton) {
        guard !globalIP.isEmpty else{self.setupIPAlertView();return}
        self.performSegue(withIdentifier: "ForgotPasswordSegue", sender: nil)
    }
    @IBAction func continuePressed(_ sender: UIButton) {
        
        guard !globalIP.isEmpty else{self.setupIPAlertView();return}
        guard let customerId = customeridTF.text else {return}
        guard let password = passwordTF.text else {return}
        
        if customerId != "" && password != "" {
            guard self.checkNetworkConnectivity() else{return}
            showActivityIndicator()
            APIHelpers.hitLogin(username: customerId, password: password) { [weak self] (data,error) in
                
                guard let data = data else {
                    DispatchQueue.main.async {
                        self?.hideActivityIndicator()
                        self?.showAlert(withTitle: AlertTitles.error, andMessage: error?.localizedDescription ?? "Something went wrong", handler: nil)
                    }
                    return
                }
                
                do {
                    let decoder = JSONDecoder()
                    //let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String : Any]
                   // print(json)
                    let receivedJSON = try decoder.decode(loginResponseModel.self, from: data)
                    DispatchQueue.main.async {
                        self?.hideActivityIndicator()
                        if receivedJSON.status == statusMessages.failed {
                            self?.showAlert(withTitle: receivedJSON.status_code, andMessage: receivedJSON.message, handler: nil)
                        }
                        else {
                            self?.loginResponse = receivedJSON
                            print(receivedJSON)
                            guard let userData = receivedJSON.data else {return}
                            StaticHelpers.saveUserData(params: userData)
                            if let username = userData.userid{StaticHelpers.saveToUserDefaults(params: ["LastUserid":username])}
                            StaticHelpers.saveToKeychain(param: userData.token!)
                            self?.performSegue(withIdentifier: segues.dashboardSegue, sender: nil)
                        }
                    }
                }
                catch {
                    DispatchQueue.main.async {
                        self?.hideActivityIndicator()
                        self?.showAlert(withTitle: AlertTitles.parsingErrorTitle, andMessage: AlertMessages.parsingErrorMessage, handler: nil)
                    }
                    return
                }
            }
        }
        else {
            showAlert(withTitle: AlertTitles.fieldEmptyTitle, andMessage: AlertMessages.fieldEmptyMessage, handler: nil)
        }
    }
    
    override func viewDidLoad() {
      
        customeridTF.delegate = self
        passwordTF.delegate = self
        self.hideKeyboardWhenTappedAround()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        //fetch ip from defaults
         let ud = UserDefaults.standard
         
         guard let ip = ud.object(forKey: "ip") as? String else {
             setupIPAlertView()
             return
         }
         
         var port = "80"
         
         if let p = ud.object(forKey: "port") as? String{
             port = p
         }
         globalIP = ip + ":\(port)"

         if let userid = StaticHelpers.fetchFromDefaults(fetch: "LastUserid"){
             customeridTF.text = userid
         }// put here since have to show everytime user login or logout
         
         if validConnection == false{
             self.connectToserver()
         }
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        
        customeridTF.text = ""
        passwordTF.text = ""
    }
    
    

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        center.getNotificationSettings { (settings) in
            if settings.authorizationStatus != .authorized {
                DispatchQueue.main.async {
                    self.openAppSettings()
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
    
    private func setupIPAlertView() {
        
        let alert = UIAlertController(title: "Enter IP Address", message: nil, preferredStyle: UIAlertController.Style.alert)
        
        let action = UIAlertAction(title: "Connect", style: .default) { (alertAction) in
            let textField = alert.textFields![0]
            let portTextField = alert.textFields![1]
            
            guard let input = textField.text else {return}
            let port = portTextField.text == "" ? "80" : (portTextField.text ?? "80")
            if self.validateConnection(input: input,port:port) {
                globalIP = input + ":\(port)"
                StaticHelpers.saveToUserDefaults(params: ["ip" : input])
                StaticHelpers.saveToUserDefaults(params: ["port":port])
                self.connectToserver()
            }
            else {
                self.setupIPAlertView()
            }
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .default) { (cancelAction) in
        
        }
        
        alert.addAction(cancelAction)
        alert.addAction(action)
        
        let ud = UserDefaults.standard
    
        alert.addTextField { (textField) in
            textField.placeholder = "IP Address"
            textField.keyboardType = .decimalPad
            if let ip = ud.object(forKey: "ip") as? String{
                textField.text = ip
            }
        }
        
        alert.addTextField { (textField) in
            textField.placeholder = "Default port is 80"
            textField.keyboardType = .numberPad
            if let port = ud.object(forKey: "port") as? String, port != "80"{
                textField.text = port
            }
        }
        
        self.present(alert, animated: true, completion: nil)
    }
    
    private func validateConnection(input: String,port:String) -> Bool {
        
        let host = validateHostName(host: input)
        let ip = validateIpAddress(ipToValidate: input)
        let isValidPort = validatePort(port: port)
        
        if (host || ip) && isValidPort {
            return true
        }
        else {
            return false
        }
    }
    
    
    private func connectToserver(){
        self.showActivityIndicator()
        APIHelpers.hitConnection(manager: &alamofireManager) { (data, error) in
            DispatchQueue.main.async {
                self.hideActivityIndicator()
                if error != nil{
                    self.showAlertForConnection { (action) in
                        self.resetGlobalIp()
                        self.setupIPAlertView()
                    }
                }else{
                    self.showAlert(withTitle: "Connection Successful", andMessage: nil, handler: nil)
                }
            }
        }
    }
    
    private func resetGlobalIp(){
        globalIP = ""
        StaticHelpers.saveToUserDefaults(params: ["ip" : ""])
        StaticHelpers.saveToUserDefaults(params: ["port":""])
    }
    
    private func validatePort(port:String)-> Bool{
        let validatePortRegex = "^([0-9]{1,4}|[1-5][0-9]{4}|6[0-4][0-9]{3}|65[0-4][0-9]{2}|655[0-2][0-9]|6553[0-5])$"
        
        let portTest = NSPredicate(format: "SELF MATCHES %@", validatePortRegex)
        return portTest.evaluate(with: port)
    }
    
    private func validateIpAddress(ipToValidate: String) -> Bool {
        
        //only ip
        var sin = sockaddr_in()
        var sin6 = sockaddr_in6()

        if ipToValidate.withCString({ cstring in inet_pton(AF_INET6, cstring, &sin6.sin6_addr) }) == 1 {
            // IPv6 peer.
            return true
        }
        else if ipToValidate.withCString({ cstring in inet_pton(AF_INET, cstring, &sin.sin_addr) }) == 1 {
            // IPv4 peer.
            return true
        }
        return false
    }
    private func validateHostName(host: String) -> Bool {

        let validHostnameRegex = "^(([a-zA-Z0-9]|[a-zA-Z0-9][a-zA-Z0-9\\-]*[a-zA-Z0-9])\\.)*([A-Za-z0-9]|[A-Za-z0-9][A-Za-z0-9\\-]*[A-Za-z0-9])$"
        
        //let validHostnameRegex = "(http|https)://((\\w)*|([0-9]*)|([-|_])*)+([\\.|/]((\\w)*|([0-9]*)|([-|_])*))+"
        let urlTest = NSPredicate(format:"SELF MATCHES %@", validHostnameRegex)
        return urlTest.evaluate(with:host)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let vc = segue.destination as? SignUpController{
            vc.delegate = self
        }
    }
}

extension ViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        if textField == customeridTF {
            passwordTF.becomeFirstResponder()
        }
        else {
            textField.resignFirstResponder()
        }
        return false
    }
}

extension ViewController:SignupDelegate{
    func didCompleteSignup(customerId: String) {
        let successVC = self.storyboard?.instantiateViewController(withIdentifier: "SignupSuccessMessageController") as! SignupSuccessMessageController
        successVC.customerID = customerId
        self.present(successVC, animated: true) {[weak self] in
            self?.customeridTF.text = customerId
            StaticHelpers.saveToUserDefaults(params: ["LastUserid":customerId])
        }
    }
}
