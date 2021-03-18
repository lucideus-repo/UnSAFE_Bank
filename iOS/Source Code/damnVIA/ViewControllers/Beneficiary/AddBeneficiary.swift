//
//  AddBeneficiary.swift
//  damnVIA
//
//  Created by Sahil Pahwa on 07/12/18.
//  Copyright © 2018 lucideus. All rights reserved.
//

import UIKit

//EMAIL REMOVED FOR THE TIME BEING

class AddBeneficiary: UIViewController {

    var benfAccNoTF: String!
    var reEnterBenfAccNoTF: String!
    var aliasTF: String!
    var ifscCodeTF: String!
    @IBOutlet weak var tableView: UITableView!
    // @IBOutlet weak var emailTF: UITextField!
    var activeField: UITextField?
    let indicator = UIActivityIndicatorView(style: .whiteLarge)
    var encrypted_otp: String!
    
    @IBAction func logoutPressed(_ sender: UIBarButtonItem) {
        showLogout(indicator: indicator)
    }

    

    
    @IBAction func addBeneficiaryPressed(_ sender: UIButton) {
        
        self.view.endEditing(true)
        guard let accNumber1 = benfAccNoTF else {return}
        guard let accNumber2 = reEnterBenfAccNoTF else {return}
        guard let alias = aliasTF else {return}
       // guard let email = emailTF.text else {return}
        guard let ifsc = ifscCodeTF else {return}
        
        if accNumber1.isEmpty || accNumber2.isEmpty {
            showAlert(withTitle: "Empty Field", andMessage: "Account number field cannot be empty", handler: nil)
            return
        }
        
        if !accNumber1.isEmpty && !accNumber2.isEmpty && accNumber1 != accNumber2 {
            //check if both are same and proceed further
            showAlert(withTitle: "Account Number Mismatch", andMessage: "The account numbers entered don't match", handler: nil)
            return
        }
        
        if alias.trimmingCharacters(in: .whitespaces).isEmpty {
            showAlert(withTitle: "Empty Field", andMessage: "Alias field cannot be empty", handler: nil)
            return
        }
        
//        if !email.isEmpty {
//            let result = validateEmail(value: email)
//
//            if !result {
//                showAlert(withTitle: "Invalid Email", andMessage: "The entered email is not correct", handler: nil)
//                return
//            }
//        }
        
        if ifsc.isEmpty {
            showAlert(withTitle: "Empty Field", andMessage: "IFSC field cannot be empty", handler: nil)
            return
        }
        
        guard validateIFSCCode() else{
            showAlert(withTitle: "Invalid Input", andMessage: "Please provide a valid IFSC code", handler: nil)
            return
        }
        guard self.checkNetworkConnectivity() else{return}
        
        self.checkNotificationAllowed({[weak self] (isAllowed) in
            if isAllowed{self?.hitGetOTPAPI(accNumber1, alias, ifsc)}
            else{self?.hideActivityIndicator(indicator: self!.indicator)}
        })
    }
    
    fileprivate func hitGetOTPAPI(_ accNumber1: String, _ alias: String, _ ifsc: String) {
        APIHelpers.hitGetOtp(otp_type: OtpType.addBeneficiary) { [weak self] (data,error) in
            
            guard let self = self else{return}
            
            guard let data = data else {
                DispatchQueue.main.async {
                    self.hideActivityIndicator(indicator: self.indicator)
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
                    self.hideActivityIndicator(indicator: self.indicator)
                    if receivedJSON.status == statusMessages.failed {
                        self.showAlert(withTitle: receivedJSON.status_code, andMessage: receivedJSON.message, handler: nil)
                    }
                    else {
                        guard let data = receivedJSON.data else {return}
                        self.encrypted_otp = data.response
                        // print(receivedJSON)
                        // guard let encrypted_otp = receivedJSON.data else {return}
                        self.performSegue(withIdentifier: segues.verifyOTP, sender: [JSONKeys.accoutNumber: accNumber1, JSONKeys.alias: alias, JSONKeys.email: "test@abc.com"/*email*/, JSONKeys.ifsc: ifsc])
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
        registerForKeyboardNotifications()
        self.hideKeyboardWhenTappedAround()
       //scrollView.contentInset = UIEdgeInsets(top: 88, left: 0, bottom: 0, right: 0)
        // Do any additional setup after loading the view.
    }
    
    
    private func validateEmail(value: String) -> Bool {
        
        let characterset = CharacterSet(charactersIn: "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789@.")
        
        if value.rangeOfCharacter(from: characterset.inverted) == nil && value.rangeOfCharacter(from: characterset.inverted) == nil {
            
            let emailRegEx = "[A-Z0-9a-z.-_]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,3}"
            let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
            let result = emailTest.evaluate(with: value)
            return result
        }
        return false
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == segues.verifyOTP {
            let params = sender as? NSDictionary
            let vc = segue.destination as! VerifyOtpVC
            vc.encrypted_otp = encrypted_otp
            vc.otpType = .AddBeneficiary
            vc.params = params as? [String : String]
        }
    }
    
    func registerForKeyboardNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWasShown(aNotification:)), name: UIResponder.keyboardDidShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillBeHidden(aNotification:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @objc func keyboardWasShown(aNotification: NSNotification) {
        let info = aNotification.userInfo as! [String: AnyObject],
        kbSize = (info[UIResponder.keyboardFrameBeginUserInfoKey] as! NSValue).cgRectValue.size,
        contentInsets = UIEdgeInsets(top: 0, left: 0, bottom: kbSize.height, right: 0)
        
        self.tableView.contentInset = contentInsets
        self.tableView.scrollIndicatorInsets = contentInsets
        
        // If active text field is hidden by keyboard, scroll it so it's visible
        // Your app might not need or want this behavior.
        var aRect = self.view.frame
        aRect.size.height -= kbSize.height
        
        guard let activeField = self.activeField else{return}
        
        if !aRect.contains(activeField.frame.origin) {
            self.tableView.scrollRectToVisible(activeField.frame, animated: true)
        }
    }
    
    @objc func keyboardWillBeHidden(aNotification: NSNotification) {
        let contentInsets = UIEdgeInsets.zero
        self.tableView.contentInset = contentInsets
        self.tableView.scrollIndicatorInsets = contentInsets
    }
    
    func validateIFSCCode()->Bool{
        let IFSC_REGEX = "IFSC000([0][1-9]|10)"
        let ifscTest = NSPredicate(format: "SELF MATCHES %@", IFSC_REGEX)
        let result = ifscTest.evaluate(with: self.ifscCodeTF)
        return result
    }
}


extension AddBeneficiary: UITextFieldDelegate {
   
    func textFieldDidBeginEditing(_ textField: UITextField) {
        self.activeField = textField
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
       
        if textField.tag == 100 {
            benfAccNoTF = textField.text
        }
        else if textField.tag == 101 {
            reEnterBenfAccNoTF = textField.text
        }
        else if textField.tag == 102 {
            aliasTF = textField.text
        }
        else if textField.tag == 103 {
            ifscCodeTF = textField.text
        }
        self.activeField = nil
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        let text = string != "" ? (textField.text ?? "" + string) : String((textField.text ?? " ").dropLast())
        if ((textField.tag == 100) || (textField.tag == 101)) && text.count >= 12 {return false}
        if ((textField.tag == 103)) && text.count >= 9{return false}
        
        return true
    }
}

extension AddBeneficiary: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "addBeneficiaryCell") as! addBeneficiaryTableViewCell
        cell.benfAccNoTF.delegate = self
        cell.ifscCodeTF.delegate = self
        cell.reEnterBenfAccNoTF.delegate = self
        cell.aliasTF.delegate = self
        return cell
    }
}

