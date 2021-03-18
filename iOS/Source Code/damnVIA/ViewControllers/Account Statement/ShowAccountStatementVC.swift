//
//  showAccountStatementVC.swift
//  damnVIA
//
//  Created by Sahil on 27/02/18.
//  Copyright © 2018 lucideus. All rights reserved.
//

import UIKit

class showAccountStatementVC: UIViewController {
    
    let indicator = UIActivityIndicatorView(style: .whiteLarge)
    let transactionType = ["All","Debit","Credit"]
    
    @IBOutlet weak var fromDateTF: UITextField!
    @IBOutlet weak var showTransactionTF: UITextField!
    @IBOutlet weak var toDateTF: UITextField!
    
    var fromdate:String?
    var toDate:String?
    var showTransactionType:String?
    
    let pickerView:UIPickerView = {
        let pickerView = UIPickerView()
        pickerView.showsSelectionIndicator = true
        return pickerView
    }()
    
    let fromDatePicker:UIDatePicker = {
        let datePickerView:UIDatePicker = UIDatePicker()
        datePickerView.datePickerMode = UIDatePicker.Mode.date
        datePickerView.addTarget(self, action: #selector(fromDatePickerValueChanged(sender:)), for: UIControl.Event.valueChanged)
        return datePickerView
    }()
    
    let toDatePicker:UIDatePicker = {
        let datePickerView:UIDatePicker = UIDatePicker()
        datePickerView.datePickerMode = UIDatePicker.Mode.date
        datePickerView.addTarget(self, action: #selector(toDatePickerValueChanged(sender:)), for: UIControl.Event.valueChanged)
        return datePickerView
    }()
    
    var dataReceived: accountStatementDetailsData!
    var filteredDataReceived: filteredAccountStatementResponseModel!
    
    @objc func doneTapped() {
     
        if showTransactionTF.isEditing{
            let row = self.pickerView.selectedRow(inComponent: 0)
            self.pickerView.selectRow(row, inComponent: 0, animated: false)
            self.showTransactionTF.text = self.transactionType[row]
            self.showTransactionType = self.transactionType[row].uppercased()
            self.showTransactionTF.resignFirstResponder()
        }
        
        if fromDateTF.isEditing{
            let dateFormatter = DateFormatter()
            dateFormatter.dateStyle = DateFormatter.Style.medium
            dateFormatter.timeStyle = DateFormatter.Style.none
            fromDateTF.text = dateFormatter.string(from: fromDatePicker.date)
            
            dateFormatter.dateFormat = "yyyy-MM-dd"
            self.fromdate = dateFormatter.string(from: fromDatePicker.date)
            print("from date is : \(self.fromdate ?? "not found")")
        }
        
        if toDateTF.isEditing{
            let dateFormatter = DateFormatter()
            dateFormatter.dateStyle = DateFormatter.Style.medium
            dateFormatter.timeStyle = DateFormatter.Style.none
            toDateTF.text = dateFormatter.string(from: toDatePicker.date)
            
            dateFormatter.dateFormat = "yyyy-MM-dd"
            self.toDate = dateFormatter.string(from: toDatePicker.date)
            print("from date is : \(self.toDate ?? "not found")")
        }
        
        self.view.endEditing(true)
    }
    
    @objc func fromDatePickerValueChanged(sender: UIDatePicker) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = DateFormatter.Style.medium
        dateFormatter.timeStyle = DateFormatter.Style.none
        fromDateTF.text = dateFormatter.string(from: sender.date)
    }
    
    @objc func toDatePickerValueChanged(sender: UIDatePicker) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = DateFormatter.Style.medium
        dateFormatter.timeStyle = DateFormatter.Style.none
        toDateTF.text = dateFormatter.string(from: sender.date)
    }
    
    func setupInputViews(){
        let toolBar = UIToolbar()
        toolBar.barStyle = UIBarStyle.default
        toolBar.isTranslucent = true
        toolBar.tintColor = .black
        toolBar.sizeToFit()
        
        let doneButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(self.doneTapped))
        let spaceButton = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        
        toolBar.setItems([spaceButton, doneButton], animated: true)
        toolBar.isUserInteractionEnabled = true
        
        toDateTF.inputView = toDatePicker
        toDateTF.inputAccessoryView = toolBar
        
        fromDateTF.inputView = fromDatePicker
        fromDateTF.inputAccessoryView = toolBar
        
        pickerView.delegate = self
        pickerView.dataSource = self
        showTransactionTF.inputView = pickerView
        showTransactionTF.inputAccessoryView = toolBar
    }
    
    
    @IBAction func submitForm(_ sender: UIButton) {
        guard self.checkNetworkConnectivity() else{return}
        showActivityIndicator()
        
        guard let fromDate = self.fromdate else{
            self.showAlert(withTitle: AlertTitles.fieldEmptyTitle, andMessage: "Please select from date", handler: nil)
            hideActivityIndicator()
            return}
        guard let toDate = self.toDate else {
            self.showAlert(withTitle: AlertTitles.fieldEmptyTitle, andMessage: "Please select to date", handler: nil)
            hideActivityIndicator()
            return
        }
        guard  let transactionType = self.showTransactionType else {
            self.showAlert(withTitle: AlertTitles.fieldEmptyTitle, andMessage: "Please select Transaction Type", handler: nil)
            hideActivityIndicator()
            return
        }
        
        let params = [JSONKeys.from_date:fromDate,JSONKeys.to_date:toDate,JSONKeys.trans_type:transactionType]
        
        APIHelpers.hitFilteredStatement(details:params) { [weak self] (data,error) in
            
            guard let data = data else {
                               DispatchQueue.main.async {
                                   self?.hideActivityIndicator()
                                   self?.showAlert(withTitle: AlertTitles.error, andMessage: error?.localizedDescription ?? "Something went wrong", handler: nil)
                               }
                               return
                           }
            
            do {
               // guard let data = data else {return}
                let decoder = JSONDecoder()
                //let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String : Any]
                //  print(json)
                let receivedJSON = try decoder.decode(accountStatementResponseModel.self, from: data)
                
                DispatchQueue.main.async {
                    self?.hideActivityIndicator()
                    if receivedJSON.status == statusMessages.failed {
                        self?.showAlert(withTitle: receivedJSON.status_code, andMessage: receivedJSON.message, handler: { (action) in
                            if receivedJSON.status_code == "ERRO06"{self?.dismiss(animated: true, completion: {})}
                        })
                    }
                    else {
                        guard let data = receivedJSON.data else {return}
                        self?.dataReceived = data
                        //self?.filteredDataReceived = data
                        guard self?.dataReceived.statement?.count != 0 else{
                            self?.showAlert(withTitle: AlertTitles.error, andMessage: "No data found", handler: nil)
                            return
                        }
                        self?.performSegue(withIdentifier: segues.statementSegue, sender: nil)
                    }
                }
            }
            catch {
                DispatchQueue.main.async {
                    print(error.localizedDescription)
                    self?.hideActivityIndicator()
                    self?.showAlert(withTitle: AlertTitles.parsingErrorTitle, andMessage: AlertMessages.parsingErrorMessage, handler: nil)
                }
                return
            }
        }
    }
    
    @IBAction func logoutPressed(_ sender: UIBarButtonItem) {
        
        showLogout(indicator: indicator)
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideKeyboardWhenTappedAround()
        self.setupInputViews()
    }
    
    

    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == segues.statementSegue {
            let vc = segue.destination as! accountStatementVC
            guard let statement = dataReceived.statement else {return}
            vc.data = statement
        }
    }
}

extension showAccountStatementVC: UIPickerViewDelegate, UIPickerViewDataSource {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return transactionType.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return transactionType[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        showTransactionTF.text = transactionType[row]
        //self.view.endEditing(true)
    }
}

