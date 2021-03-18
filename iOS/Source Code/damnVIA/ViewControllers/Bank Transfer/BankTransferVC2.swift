//
//  BankTransferVC3.swift
//  damnVIA
//
//  Created by Sahil Pahwa on 07/01/19.
//  Copyright © 2019 lucideus. All rights reserved.
//

import UIKit

class BankTransferVC2: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var descriptionTF: UITextField!
    @IBOutlet weak var amountTF: TextField!
    
    var selectedBnfcName: String!
    var selectedBnfcAccNo: String!
    var desc: String!
    var amount: String!
    var fromAccountNumber: String!
    
    @IBAction func descChanged(_ sender: UITextField) {
        
        if sender.text != nil && !(sender.text?.isEmpty)! && amountTF.text != nil && !(amountTF.text?.isEmpty)! {
            submitBtn.isEnabled = true
        }
        else {
            submitBtn.isEnabled = false
        }
    }
    
    @IBOutlet weak var submitBtn: UIButton! {
        didSet {
            submitBtn.setTitleColor(UIColor.init(white: 1, alpha: 0.4), for: .disabled)
            submitBtn.setTitleColor(UIColor.init(white: 1, alpha: 1), for: .normal)
        }
    }
   
    @IBAction func amountChanged(_ sender: TextField) {
      
        if sender.text != nil && !(sender.text?.isEmpty)! && descriptionTF.text != nil && !(descriptionTF.text?.isEmpty)! {
                submitBtn.isEnabled = true
        }
        else {
            submitBtn.isEnabled = false
        }
        
        let formatter = NumberFormatter()
        formatter.locale = Locale(identifier: "en_IN")
        formatter.numberStyle = .decimal
        var digits = sender.text?.digitsOnly ?? "0"

        if sender.text == "₹ " || sender.text == "" { // placed here because we are setting rupee sign below in sender.text, so after removal of the last digit rupee symbol remains
            digits = "0"
        }
        
        let formatted_balance = formatter.string(from: NSNumber(value: Double(digits)!))
        guard let balance = formatted_balance else {return}
        sender.text = "₹ " + balance
    }

    @IBAction func submitPressed(_ sender: UIButton) {
        
        guard let desc = descriptionTF.text else {return}
        guard let amount = amountTF.text else {return}
        
//        let formatter = NumberFormatter()
//        formatter.locale = Locale(identifier: "en_IN")
//        formatter.numberStyle = .decimal
//        let formatted_balance = formatter.string(from: NSNumber(value: Double(amount)!))
        
        if !desc.isEmpty && !amount.isEmpty { //do amount sanitisation check
            self.desc = desc
            self.amount = amount
           // print(amount)
            self.performSegue(withIdentifier: segues.bankTransferVC3, sender: nil)
        }
    }
    
    override func canPerformAction(_ action: Selector, withSender sender: Any?) -> Bool {
        return false
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        submitBtn.isEnabled = false
        self.hideKeyboardWhenTappedAround()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == segues.bankTransferVC3 {
            let vc = segue.destination as! BankTransferVC3
            vc.desc = desc
            vc.amount = amount
            print(amount)
            vc.bnfcAccNumber = selectedBnfcAccNo
            vc.bnfcName = selectedBnfcName
            vc.fromAccountNumber = fromAccountNumber
        }
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        if textField == amountTF {
            let isNumber = CharacterSet.decimalDigits.isSuperset(of: CharacterSet(charactersIn: string))
            
            return isNumber || (string == NumberFormatter().decimalSeparator && textField.text?.contains(string) == false)
        }
        return false
    }
}

extension String {
    var digitsOnly: String {
        return
           components(separatedBy: CharacterSet.decimalDigits.inverted).joined()
    }
}

class TextField: UITextField {
    
    override func canPerformAction(_ action: Selector, withSender sender: Any?) -> Bool {
        if action == #selector(UIResponderStandardEditActions.paste(_:)) || action == #selector(UIResponderStandardEditActions.copy(_:)) {
            return false
        }
        
        return super.canPerformAction(action, withSender: sender)
    }
}
