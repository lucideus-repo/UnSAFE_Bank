//
//  SignUpController.swift
//  damnVIA
//
//  Created by Sahil Pahwa on 21/11/18.
//  Copyright © 2018 lucideus. All rights reserved.
//

import UIKit

protocol SignupDelegate:class{
    func didCompleteSignup(customerId:String)
}

class SignUpController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var firstLabel: UILabel!
    @IBOutlet weak var secondLabel: UILabel!
    @IBOutlet weak var firstTF: UITextField!
    @IBOutlet weak var secondTF: UITextField!
    @IBOutlet weak var btn: UIButton!
    @IBOutlet weak var pageControl: UIPageControl!
    
    weak var delegate:SignupDelegate?
    
    let datePicker:UIDatePicker = {
         let datePickerView:UIDatePicker = UIDatePicker()
         datePickerView.datePickerMode = UIDatePicker.Mode.date
         datePickerView.addTarget(self, action: #selector(datePickerValueChanged(sender:)), for: UIControl.Event.valueChanged)
        
         let calendar = Calendar(identifier: .gregorian)
         let currentDate = Date()
        
         var components = DateComponents()
         components.calendar = calendar
         components.year = -18
         components.month = 12
        
         let maxDate = calendar.date(byAdding: components, to: currentDate)
        
         components.year = -99
         let minDate = calendar.date(byAdding: components, to: currentDate)
        
         datePickerView.maximumDate = maxDate
         datePickerView.minimumDate = minDate
        
         return datePickerView
     }()
    
    
    let indicator = UIActivityIndicatorView(style: .whiteLarge)
    var availResponse: chkAvailDetailsData!
    var signUpResponse: signUpResponseModel!
    var moveFwd: Bool = false
    var dob:String?
    
    var first = ["FIRST NAME", "MOBILE", "PASSWORD", "ADDRESS"]
    var second = ["LAST NAME", "E-MAIL", "REPEAT PASSWORD", "DATE OF BIRTH (DD-MM-YYYY)"]
    
    var firstKey = [JSONKeys.firstName, JSONKeys.mobile, JSONKeys.password, JSONKeys.address]
    var secondKey = [JSONKeys.lastname, JSONKeys.email, JSONKeys.password, JSONKeys.dob]
    
    var userInfo = [String: String]()
    
    private let SNStockCellSelectionAccessoryViewPlusIconSelected:UIImage = UIImage(named:"tick1")!
    private let SNStockCellSelectionAccessoryViewPlusIcon:UIImage = UIImage(named:"arrow")!
    
    private func SNStockCellSelectionAccessoryViewImage(selected:Bool) -> UIImage {
        return selected ? SNStockCellSelectionAccessoryViewPlusIconSelected : SNStockCellSelectionAccessoryViewPlusIcon
    }
    
    var selected: Bool = false {
        willSet(selected) {
            let expandTransform:CGAffineTransform = CGAffineTransform(scaleX: 1.15, y: 1.15);
            if (!self.selected && selected) {
                UIView.transition(with: self.btn, duration:0.1, options: UIView.AnimationOptions.transitionCrossDissolve, animations: {
                    self.btn.setImage(self.SNStockCellSelectionAccessoryViewImage(selected: selected), for: UIControl.State.normal)
                    self.btn.transform = expandTransform
                    
                }, completion: {(finished: Bool) in
                    UIView.animate(withDuration: 0.4, delay:0.0, usingSpringWithDamping:0.40, initialSpringVelocity:0.2, options:UIView.AnimationOptions.curveEaseOut, animations: {
                        self.btn.transform = expandTransform.inverted()
                    }, completion:nil)
                })
            }
        }
    }
    
    @IBAction func btnPressed(_ sender: Any) {
        
        processTF()
        firstTF.becomeFirstResponder()
        
        //        btn.addCornerRadiusAnimation(from: btn.layer.cornerRadius, to: 0, duration: 0.6)
        //        var finalFrame = btn.frame.size
        //        finalFrame.width = 90
        //
        //        UIView.animate(withDuration: 0.3, delay: 0.2, options: .curveLinear, animations: {
        //            self.btn.frame.size = finalFrame
        //        }, completion: nil)
    }
    
    @IBAction func dismissPressed(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    func processTF() {
        
        // do sanity checks first
        
        guard let firstText = firstTF.text else {return}
        guard let secondText = secondTF.text else {return}
        
        
        if pageControl.currentPage == 0 {
            
            // normal field check
            //cross site client side checks, only alphanumeric characters are allowed
            let characterset = CharacterSet(charactersIn: "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ")
            
            if firstText.rangeOfCharacter(from: characterset.inverted) == nil && secondText.rangeOfCharacter(from: characterset.inverted) == nil { // leave the sanity check for password and the last form fields
                if firstTF.text != "" && secondTF.text != "" {
                    userInfo[firstKey[pageControl.currentPage]] = firstTF.text
                    userInfo[secondKey[pageControl.currentPage]] = secondTF.text
                    handleAnimation()
                }
            }
            else {
                displayAlert(title: "Sanity Check", message: "Invalid characters in the input field")
                return
            }
        }
            
        else if pageControl.currentPage == 1 {
            let result1 = validatePhone(value: firstText)
            let result2 = validateEmail(value: secondText)
            
            //  print(result1, result2)
            self.showActivityIndicator(indicator: indicator)
            if result1 && result2 { // for mobile and email
                userInfo[firstKey[pageControl.currentPage]] = firstText
                userInfo[secondKey[pageControl.currentPage]] = secondText
                
                guard self.checkNetworkConnectivity() else{return}
                
                APIHelpers.hitCheckAvailability(details: [JSONKeys.mobile: firstText, JSONKeys.email: secondText]) { [weak self] (data,error) in
                
                    guard let data = data else {
                        DispatchQueue.main.async {
                            self?.hideActivityIndicator(indicator: self!.indicator)
                            self?.showAlert(withTitle: AlertTitles.error, andMessage: error?.localizedDescription ?? "Something went wrong", handler: nil)
                        }
                        return
                    }
                    
                    do {
                      //  guard let data = data else {return}
                        let decoder = JSONDecoder()
                        let receivedJSON = try decoder.decode(checkAvailabilityResponseModel.self, from: data)
                        DispatchQueue.main.async {
                            self?.hideActivityIndicator(indicator: self!.indicator)
                            if receivedJSON.status == statusMessages.failed {
                                self?.showAlert(withTitle: receivedJSON.status_code, andMessage: receivedJSON.message, handler: nil)
                            }
                            else {
                                guard let result = receivedJSON.data?.result else {return}
                                print(receivedJSON)
                                if (result == "true") {
                                    self?.moveFwd = true
                                    self?.handleAnimation()
                                }
                                else {
                                    //not available
                                    self?.moveFwd = false
                                    self?.displayAlert(title: "Availability" , message: "Either email or mobile already exists")
                                    return
                                }
                            }
                        }
                    }
                    catch {
                        DispatchQueue.main.async {
                            self?.hideActivityIndicator(indicator: self!.indicator)
                            self?.dismiss(animated: true, completion: nil)
                        }
                        return
                    }
                }
               // handleAnimation()
                return // placed this return here, otherwise it will call the sanity popup down. Also, mobile and email sanity check is done separately.
            }
            else if !result1 && !result2 {
                self.hideActivityIndicator(indicator: self.indicator)
                displayAlert(title: "Phone or Email Incorrect" , message: "Either phone or email address is incorrect")
                return
            }
            else if !result1{
                self.hideActivityIndicator(indicator: self.indicator)
                displayAlert(title: "Invalid Phone Number", message: "Enter a valid phone number")
                firstTF.becomeFirstResponder()
                return
            }
            else if !result2 {
                self.hideActivityIndicator(indicator: self.indicator)
                displayAlert(title: "Invalid Email Address", message: "Enter a valid email address")
                secondTF.becomeFirstResponder()
                return
            }
        }
        else if pageControl.currentPage == 2 {
            
            if firstText == secondText {
                if !validatePassword(value: firstText) {
                    displayAlert(title: "Password Policy", message: "The password should be greater than 7 characters and should include one capital, one special and one numeric character")
                    return
                }
                else {
                    userInfo[firstKey[pageControl.currentPage]] = firstText
                    userInfo[secondKey[pageControl.currentPage]] = secondText
                    handleAnimation()
                    return // placed here, otherwise it will enter bottom sanity check
                }
            }
                
            else if firstText != secondText {
                displayAlert(title: "Password Mismatch", message: "Entered passwords do not match")
                return
            }
        }
            
        else if pageControl.currentPage == 3 {
            userInfo[firstKey[pageControl.currentPage]] = firstText
            
            if let dob = self.dob{
               userInfo[secondKey[pageControl.currentPage]] = dob
            }else{
                self.showAlert(withTitle: "Error", andMessage: "Please Enter Date of birth", handler: nil)
            }
            
            
            guard self.checkNetworkConnectivity() else{return}
            
            self.showActivityIndicator(indicator: indicator)
            
            APIHelpers.hitSignup(details: userInfo) { [weak self] (data,error) in
            
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
                    //let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String : Any]
                    // print(json)
                    let receivedJSON = try decoder.decode(signUpResponseModel.self, from: data)
                    print(receivedJSON)
                    DispatchQueue.main.async {
                        self?.hideActivityIndicator(indicator: self!.indicator)
                        if receivedJSON.status == statusMessages.failed {
                            self?.showAlert(withTitle: receivedJSON.status_code, andMessage: receivedJSON.message, handler: nil)
                        }
                        else {
                            self?.signUpResponse = receivedJSON
                            guard let userData = receivedJSON.data else {return}
                            guard let userId = userData.userId else {return}
                            self?.selected = true
                            //display alert and pop the controller
                            
                            DispatchQueue.main.asyncAfter(deadline: .now() + 1, execute: {
                                self?.view.endEditing(true)
                                self?.dismiss(animated: true, completion: {[weak self] in
                                    self?.delegate?.didCompleteSignup(customerId: userId)
                                })
                            })
                            //                            self?.performSegue(withIdentifier: segues.dashboardSegue, sender: nil)
                        }
                    }
                }
                catch {
                    DispatchQueue.main.async {
                        self?.hideActivityIndicator(indicator: self!.indicator)
                        //self?.showAlert(withTitle: AlertTitles.parsingErrorTitle, andMessage: AlertMessages.parsingErrorMessage, handler: nil)
                        self?.dismiss(animated: true, completion: nil)
                    }
                    return
                }
            }
            handleAnimation()
            return
        }
    }
    
    private func validatePhone(value: String) -> Bool {
        
        if value.count == 10{
            let PHONE_REGEX = "^((\\+)|(00))[0-9]{6,14}|[0-9]{6,14}$"
            let phoneTest = NSPredicate(format: "SELF MATCHES %@", PHONE_REGEX)
            let result =  phoneTest.evaluate(with: value)
            return result
        }
        else {
            return false
        }
    }
    
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
    
    private func handleAnimation() {
        
        if pageControl.currentPage < first.count - 1 {
            pageControl.currentPage += 1
            firstLabel.slideToRight()
            firstLabel.text = first[pageControl.currentPage]
            secondLabel.slideToRight()
            secondLabel.text = second[pageControl.currentPage]
            firstTF.slideToRight()
            secondTF.slideToRight()
            firstTF.text = ""
            secondTF.text = ""
            
            firstTF.autocapitalizationType = .sentences
            secondTF.autocapitalizationType = .sentences
            
            //phone keypad
            if pageControl.currentPage == 1 && firstLabel.text == "MOBILE"{
                firstTF.keyboardType = .phonePad
                firstTF.autocapitalizationType = .sentences
                secondTF.autocapitalizationType = .none
                secondTF.keyboardType = .emailAddress
                firstTF.reloadInputViews()
                secondTF.reloadInputViews()
            }
            else if pageControl.currentPage == 2 {
                firstTF.keyboardType = .default
                secondTF.keyboardType = .default
                firstTF.autocapitalizationType = .none
                secondTF.autocapitalizationType = .none
                firstTF.reloadInputViews()
                secondTF.reloadInputViews()
                firstTF.isSecureTextEntry = true
                secondTF.isSecureTextEntry = true // repeat password field
            }
            else if pageControl.currentPage == 3{
                secondTF.isSecureTextEntry = false
                firstTF.isSecureTextEntry = false
                firstTF.autocapitalizationType = .sentences
                secondTF.autocapitalizationType = .none
                self.setupDatePicker(secondTF)
            }
            else {
                firstTF.keyboardType = .default
                firstTF.autocapitalizationType = .sentences
                firstTF.reloadInputViews()
                secondTF.isSecureTextEntry = false //make the field normal again, after the password field
                firstTF.isSecureTextEntry = false
            }
        }
    }
    
    func setupDatePicker(_ tf : UITextField){
        let toolBar = UIToolbar()
        toolBar.barStyle = UIBarStyle.default
        toolBar.isTranslucent = true
        toolBar.tintColor = .black
        toolBar.sizeToFit()
        
        let doneButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(self.doneTapped))
        let spaceButton = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        
        toolBar.setItems([spaceButton, doneButton], animated: true)
        toolBar.isUserInteractionEnabled = true
        
        tf.inputView = datePicker
        tf.inputAccessoryView = toolBar
    }
    
    @objc func doneTapped() {
        if secondTF.isEditing{
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "dd-MM-yyyy"
            secondTF.text = dateFormatter.string(from: datePicker.date)
            
            dateFormatter.dateFormat = "yyyy-MM-dd"
            dob = dateFormatter.string(from: datePicker.date)
            
            self.view.endEditing(true)
        }
    }
    
    @objc func datePickerValueChanged(sender: UIDatePicker) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd-MM-yyyy"
        secondTF.text = dateFormatter.string(from: datePicker.date)
        
        dateFormatter.dateFormat = "YYYY-MM-dd"
        dob = dateFormatter.string(from: datePicker.date)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        pageControl.numberOfPages = first.count
        pageControl.currentPage = 0
        
        firstLabel.text = first[pageControl.currentPage]
        secondLabel.text = second[pageControl.currentPage]
        firstTF.delegate = self
        secondTF.delegate = self
        self.hideKeyboardWhenTappedAround()

    }
    
    func displayAlert(title: String, message: String) {
        
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        self.present(alertController, animated: true, completion: nil)
        let action = UIAlertAction(title: "Ok", style: .default) { (action:UIAlertAction) in
        }
        alertController.addAction(action)
    }
}

extension SignUpController {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        if textField == firstTF {
            secondTF.becomeFirstResponder()
        }
        else {
            self.view.endEditing(true)
        }
        return true
    }    
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        if textField == firstTF && pageControl.currentPage == 1 {
            let maxLength = 10
            let currentString: NSString = textField.text! as NSString
            let newString: NSString =
                currentString.replacingCharacters(in: range, with: string) as NSString
            return newString.length <= maxLength
        }
        return true
    }
}
