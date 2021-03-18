//
//  StaticHelpers.swift
//  damnVIA
//
//  Created by Sahil Pahwa on 17/09/18.
//  Copyright © 2018 lucideus. All rights reserved.
//

import Foundation
import KeychainAccess

class StaticHelpers {
    
    static func saveToUserDefaults(params: [String: Any]) {
        
        let userDefaults = UserDefaults.standard
        let keys = Array(params.keys)
        for key in keys {
            userDefaults.set(params[key], forKey: key)
        }
    }
    
    static func fetchFromDefaults(fetch forKey: String) -> String? {
        let userDefaults = UserDefaults.standard
        let value = userDefaults.object(forKey: forKey) as? String
        return value
    }
    
    static func saveUserData(params: loginData) {
        let userDefaults = UserDefaults.standard
        userDefaults.set(params.userid, forKey: "username")
        userDefaults.set(params.fname, forKey:"fname")
        userDefaults.set(params.lname, forKey:"lname")
        userDefaults.set(params.aadharId, forKey:"aadharId")
        userDefaults.set(params.acctBalance, forKey:"acctBalance")
        userDefaults.set(params.acctNo, forKey:"acctNo")
        userDefaults.set(params.accountOpeningDate, forKey:"acctOpeningDate")
        userDefaults.set(params.address, forKey:"address")
        userDefaults.set(params.countryId, forKey:"countryId")
        userDefaults.set(params.dob, forKey:"dob")
        userDefaults.set(params.email, forKey:"email")
        userDefaults.set(params.gender, forKey:"gender")
        userDefaults.set(params.incomeTaxNumber, forKey:"incomeTaxNumber")
        userDefaults.set(params.mobileNo, forKey:"mobileNo")
        userDefaults.set(params.panCardId, forKey:"panCardId")
        userDefaults.set(params.token, forKey:"token")
        userDefaults.set(params.walletId, forKey:"walletId")
    }
    
    static func saveToKeychain(param: String) {
        let keychain = Keychain(service: keychainService.service)
        keychain["token"] = param
    }
    
}
