//
//  bankTransferVC2.swift
//  damnVIA
//
//  Created by Sahil on 26/02/18.
//  Copyright © 2018 lucideus. All rights reserved.
//

import UIKit

class BankTransferVC3: UIViewController {

    @IBAction func confirmForm(_ sender: UIButton) {
        self.performSegue(withIdentifier: segues.confirmSegue, sender: nil)
    }
    
    var desc: String!
    var amount: String!
    var fromAccountNumber: String!
    var bnfcAccNumber: String!
    var bnfcName: String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if isJailbroken() {
            jailbreakAlert(withTitle: AlertTitles.jailbreakTitle, andMessage: AlertMessages.jailbreakMessage)
        }
    }
    
    @objc func isJailbroken() -> Bool {
        
        guard let cydiaUrlScheme = NSURL(string: "cydia://package/lighttpd") else { return false }
        if UIApplication.shared.canOpenURL(cydiaUrlScheme as URL) {
            return true
        }
        #if arch(i386) || arch(x86_64)
        return false
        #endif
        
        //This is a Simulator not an idevice
        
        
        let fileManager = FileManager.default
        if fileManager.fileExists(atPath: "/Applications/Cydia.app") ||
            fileManager.fileExists(atPath: "/Library/MobileSubstrate/MobileSubstrate.dylib") ||
            fileManager.fileExists(atPath: "/bin/bash") ||
            fileManager.fileExists(atPath: "/usr/sbin/sshd") ||
            fileManager.fileExists(atPath: "/etc/apt") ||
            fileManager.fileExists(atPath: "/usr/bin/ssh") ||
            fileManager.fileExists(atPath: "/private/var/lib/apt") {
            return true
        }
        
        if canOpen(path: "/Applications/Cydia.app") ||
            canOpen(path: "/Library/MobileSubstrate/MobileSubstrate.dylib") ||
            canOpen(path: "/bin/bash") ||
            canOpen(path: "/usr/sbin/sshd") ||
            canOpen(path: "/etc/apt") ||
            canOpen(path: "/usr/bin/ssh") {
            return true
        }
        
        let path = "/private/" + NSUUID().uuidString
        do {
            try "anyString".write(toFile: path, atomically: true, encoding: String.Encoding.utf8)
            try fileManager.removeItem(atPath: path)
            return true
        } catch {
            return false
        }
    }
    
    func canOpen(path: String) -> Bool {
        let file = fopen(path, "r")
        guard file != nil else { return false }
        fclose(file)
        return true
    }
    
    
    private func jailbreakAlert(withTitle title: String, andMessage message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: { [weak self](action) in
            //pop back to the parent
            self?.navigationController?.popToViewController(ofClass: fundsTransferVC.self)
        }))
        self.present(alert, animated: true, completion: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == segues.confirmSegue {
            let vc = segue.destination as! BankTransferVC4
            guard let amt = amount else {return}
            let temp2 = amt.digitsOnly
           // print("temp2 == \(temp2)")
            vc.amount = temp2
            vc.bnfcName = bnfcName
            vc.remarks = desc
            vc.fromAccountNumber = fromAccountNumber
        }
    }
}

extension BankTransferVC3: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "confirmCell") as! confirmTableViewCell
        
        cell.beneficiaryAccountNumber.text = bnfcAccNumber
        cell.beneficiaryName.text = bnfcName
        cell.desc.text = desc
        cell.fromAccountNumber.text = fromAccountNumber
        cell.amount.text = amount
        
        return cell
    }
}
