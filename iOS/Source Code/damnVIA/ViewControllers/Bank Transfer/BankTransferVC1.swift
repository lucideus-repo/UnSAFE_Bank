//
//  bankTransferVC1.swift
//  damnVIA
//
//  Created by Sahil on 26/02/18.
//  Copyright © 2018 lucideus. All rights reserved.
//

import UIKit

class BankTransferVC1: UIViewController {
    
    @IBOutlet weak var fromAccountTF: UITextField!
    @IBOutlet weak var beneficiaryTF: UITextField!
    @IBOutlet weak var nextBtn: UIButton! {
        didSet {
            nextBtn.setTitleColor(UIColor.init(white: 1, alpha: 0.4), for: .disabled)
            nextBtn.setTitleColor(UIColor.init(white: 1, alpha: 1), for: .normal)
        }
    }
    let indicator = UIActivityIndicatorView(style: .whiteLarge)
    var bnfcDetails: [String]?
    
    var acctNo: String!
    var selectedIndex: Int!
    var selectedBnfcName: String!
    var selectedBnfcAccNo: String!
    
    @IBAction func submitForm(_ sender: UIButton) {
        
        self.performSegue(withIdentifier: segues.bankTransferVC2, sender: nil)
    }
    
    @IBAction func logoutPressed(_ sender: UIBarButtonItem) {
        
        showLogout(indicator: indicator)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let userDefaults = UserDefaults.standard
        acctNo = userDefaults.string(forKey: "acctNo")
        fromAccountTF.text = acctNo + " - " + "Primary"
        nextBtn.isEnabled = false
        self.hideKeyboardWhenTappedAround()

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        guard self.checkNetworkConnectivity() else{return}
        showActivityIndicator(indicator: indicator)
        APIHelpers.getBeneficiaryForBt(params: [:]) { [weak self] (data,error) in
        
            guard let data = data else {
                DispatchQueue.main.async {
                    self?.hideActivityIndicator(indicator: self!.indicator)
                    self?.showAlert(withTitle: AlertTitles.error, andMessage: error?.localizedDescription ?? "Something went wrong", handler: nil)
                    self?.setupViews()
                }
                return
            }
            
            do {
               // guard let data = data else {return}
                let decoder = JSONDecoder()
                let receivedJSON = try decoder.decode(getBnfcForFundTransferResponseModel.self, from: data)
                DispatchQueue.main.async {
                    self?.hideActivityIndicator(indicator: self!.indicator)
                    if receivedJSON.status == statusMessages.success {
                        guard let data = receivedJSON.data else {return}
                        self?.bnfcDetails = data.result
                    }
                    else {
                        self?.showAlert(withTitle: receivedJSON.status_code, andMessage: receivedJSON.message, handler: { (action) in
                            if receivedJSON.status_code == "ERRO06"{self?.dismiss(animated: true, completion: {})}
                        })
                    }
                    
                    self?.setupViews()
                }
            }
            catch {
                DispatchQueue.main.async {
                    self?.hideActivityIndicator(indicator: self!.indicator)
                    self?.showAlert(withTitle: AlertTitles.parsingErrorTitle, andMessage: AlertMessages.parsingErrorMessage, handler: nil)
                    self?.setupViews()
                }
            }
            
            
        }
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    private func setupViews(){
        //Check if beneficiary details exists
         if bnfcDetails?.count != 0 {
             DispatchQueue.global(qos: .background).async { [weak self] in
                 self?.maskValues()
                 DispatchQueue.main.async {
                     self?.setupPicker()
                 }
             }
         }
         else {
             beneficiaryTF.isUserInteractionEnabled = false // the reason to make it false: it will open up the pickerview with 0 rows, so better don't let it open.
             beneficiaryTF.placeholder = "No Beneficiaries found" // Message to client
             return
         }
    }
    
    private func maskValues() {
        
        guard let beneficiaryDetails = self.bnfcDetails,beneficiaryDetails.count != 0 else{return}
        
        let alias = beneficiaryDetails.compactMap({$0.split(separator: " ").first})
        let accNo = beneficiaryDetails.compactMap({$0.split(separator: " ").last})
        var maskedAccNo = [String]()
        var finalArray = [String]()
        
        for acc in accNo {
            let conditionIndex = acc.count - 4
            let maskedAcc =  String(acc.enumerated().map { (index, element) -> Character in
                return index < conditionIndex ? "X" : element
            })
            maskedAccNo.append(maskedAcc)
        }
        
        for index in 0...alias.count - 1 {
            let newStr = String(alias[index]) + " - " + String(maskedAccNo[index])
            finalArray.append(newStr)
        }
        self.bnfcDetails?.removeAll()
        self.bnfcDetails = finalArray.map({$0})
    }
    
    private func setupPicker() {
        let pickerView = UIPickerView()
        pickerView.delegate = self
        pickerView.dataSource = self
        let toolBar = UIToolbar()
        toolBar.barStyle = UIBarStyle.default
        toolBar.isTranslucent = true
        toolBar.sizeToFit()
        let cancelButton = UIBarButtonItem(title: "Cancel", style: UIBarButtonItem.Style.plain, target: self, action: #selector(cancelPickerButton))
        let flexibleSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let doneButton = UIBarButtonItem(title: "Done", style: UIBarButtonItem.Style.done, target: self, action: #selector(donePickerButton))
        toolBar.setItems([cancelButton, flexibleSpace, doneButton], animated: false)
        toolBar.isUserInteractionEnabled = true
        beneficiaryTF.inputView = pickerView
        beneficiaryTF.inputAccessoryView = toolBar
        beneficiaryTF.delegate = self
        
        pickerView.selectRow(0, inComponent: 0, animated: true)
        //selectedIndex = 0
    }
    
    @objc func donePickerButton() {
        self.view.endEditing(true)
        
        if selectedIndex == nil {
            selectedIndex = 0
        }
        
        
        guard let beneficiaryDetails = self.bnfcDetails else{return}
        
        beneficiaryTF.text = beneficiaryDetails[selectedIndex]
        guard let bnfcName = beneficiaryDetails[selectedIndex].split(separator: " ").first else {return}
        selectedBnfcName = String(bnfcName)
        guard let bnfcAccNo = beneficiaryDetails[selectedIndex].split(separator: " ").last else {return}
        selectedBnfcAccNo = String(bnfcAccNo)
        nextBtn.isEnabled = true
    }
    
    @objc func cancelPickerButton() {
        self.view.endEditing(true)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == segues.bankTransferVC2 {
            let vc = segue.destination as! BankTransferVC2
            vc.selectedBnfcName = selectedBnfcName
            vc.selectedBnfcAccNo = selectedBnfcAccNo
            vc.fromAccountNumber = acctNo
        }
    }
    
    
}

extension BankTransferVC1:UITextFieldDelegate{
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        if textField == self.beneficiaryTF{
            guard let beneficiaryDetails = self.bnfcDetails else{return false}
            if beneficiaryDetails.count == 0 {return false}
        }
        return true
    }
}

extension BankTransferVC1: UIPickerViewDelegate, UIPickerViewDataSource {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        guard let beneficiaryDetails = self.bnfcDetails else{return 0}
        return beneficiaryDetails.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return bnfcDetails![row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        selectedIndex = row
    }
}
