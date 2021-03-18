//
//  sendOtpVC.swift
//  damnVIA
//
//  Created by Sahil on 26/02/18.
//  Copyright © 2018 lucideus. All rights reserved.
//

import UIKit
import UserNotifications

class BankTransferVC4: UIViewController {

    @IBOutlet weak var checkBox: UIButton!
    @IBOutlet weak var mobileNo: UILabel!
    
    
    var center = UNUserNotificationCenter.current()
    var amount: String!
    var remarks: String!
    var bnfcName: String!
    var fromAccountNumber: String!
    
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
    
    @IBOutlet weak var sendOtpBtn: UIButton! {
        didSet {
            sendOtpBtn.setTitleColor(UIColor.init(white: 1, alpha: 0.4), for: .disabled)
            sendOtpBtn.setTitleColor(UIColor.init(white: 1, alpha: 1), for: .normal)
        }
    }
    
    var isChecked: Bool = false
    
    let indicator = UIActivityIndicatorView(style: .whiteLarge)
    var encrypted_otp: String!

   
    
    @IBAction func sendOTP(_ sender: UIButton) {
        
        if isChecked {
            guard self.checkNetworkConnectivity() else{return}
            
            self.checkNotificationAllowed({[weak self] (isAllowed) in
                if isAllowed{self?.hitGetOTPAPI()}
                else{self?.hideActivityIndicator(indicator: self!.indicator)}
            })
            
            
//            let content = UNMutableNotificationContent()
//            content.title = "Here's your OTP"
//            content.body = "Your One Time Password for the transaction is \(num)"
//            content.sound = UNNotificationSound.default
//            //content.badge = 1
//            let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 3,
//                                                            repeats: false)
//
//            let identifier = "My Local Notification"
//            let request = UNNotificationRequest(identifier: identifier,
//                                                content: content, trigger: trigger)
//            center.add(request, withCompletionHandler: { (error) in
//                if let error = error {
//                    // Something went wrong
//                }
//            })
        }
    }
    
    fileprivate func hitGetOTPAPI() {
           //            let num = generateRandomNumber()
           APIHelpers.hitGetOtp(otp_type: OtpType.fundTransfer) { [weak self] (data,error) in
               
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
                   let receivedJSON = try decoder.decode(getOtpResponseModel.self, from: data)
                   print(receivedJSON)
                   DispatchQueue.main.async {
                       self?.hideActivityIndicator(indicator: self!.indicator)
                       if receivedJSON.status == statusMessages.failed {
                           self?.showAlert(withTitle: receivedJSON.status_code, andMessage: receivedJSON.message, handler: { (action) in
                               if receivedJSON.status_code == "ERRO06"{self?.dismiss(animated: true, completion: {})}
                           })
                       }
                       else {
                           guard let data = receivedJSON.data else {return}
                           self?.encrypted_otp = data.response
                           self?.checkNotificationAllowed({ (isAllowed) in
                               self?.performSegue(withIdentifier: segues.verifyOTP, sender: self?.encrypted_otp)
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
    
    @IBAction func checkBoxPressed(_ sender: UIButton) {
        
        if isChecked {
            isChecked = false
            checkBox.setImage(nil, for: .normal)
            sendOtpBtn.isEnabled = false
        }
        else {
            isChecked = true
            checkBox.setImage(UIImage(named: "tick"), for: .normal)
            sendOtpBtn.isEnabled = true
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        sendOtpBtn.isEnabled = false
        checkBox.layer.borderWidth = 0.5
        checkBox.layer.borderColor = UIColor.darkGray.cgColor
        checkBox.layer.cornerRadius = 6.0
        
        let userDefaults = UserDefaults.standard
        let mobNo = userDefaults.string(forKey: "mobileNo")
        guard let last4 = mobNo?.suffix(4) else {
            mobileNo.text = "XXXXXXXXXX"
            checkBox.isUserInteractionEnabled = false
            return
        }
        
        let maskedMobile = "XXXXXX" + last4
        mobileNo.text = maskedMobile
        self.navigationItem.hidesBackButton = true
        // Do any additional setup after loading the view.
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == segues.verifyOTP {
            let otp = sender as! String
            let vc = segue.destination as! BankTransferVC5
            vc.amount = amount
            vc.alias = bnfcName
            vc.remarks = remarks
            vc.encrypted_otp = otp
        }
    }
    
    
    
    
//    @objc func generateRandomNumber() -> String{
//
//        let num = arc4random_uniform(1000000)
//        return String(describing: num)
//    }
}
