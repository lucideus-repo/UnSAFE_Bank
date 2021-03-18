//
//  MakeJson.swift
//  damnVIA
//
//  Created by Sahil Pahwa on 16/09/18.
//  Copyright © 2018 lucideus. All rights reserved.
//

import Foundation
import UIKit

struct JSONKeys {
    
    static let requestBody = "requestBody"
    static let timestamp = "timestamp"
    static let device = "device"
    static let deviceId = "deviceid"
    static let os = "os"
    static let host = "host"
    static let data = "data"
    static let userId = "userid"
    static let token = "token"
    static let passwd = "passwd"
    static let accoutNumber = "account_number"
    static let firstName = "firstname"
    static let lastname = "lastname"
    static let gender = "gndr"
    static let mobile = "mobile"
    static let email = "email"
    static let password = "passwd"
    static let countryId = "countryId"
    static let address = "address"
    static let dob = "dob"
    static let alias = "alias"
    static let otp_type = "otp_type"
    static let otp = "otp"
    static let ifsc = "ifsc_code"
    static let otpResponse = "otp_response"
    static let amount = "amount"
    static let remarks = "remarks"
    static let newPassword = "new_pass"
    static let from_date = "from_date"
    static let to_date = "to_date"
    static let trans_type = "trans_type"
    static let old_pass = "old_pass"
    static let new_pass = "new_pass"
}

class JSONHelpers {
    
    static func prepareLoginJSON(username: String, password: String) -> [String:Any] {
        
        let currentDate = Date()
        let timestamp = Int64(currentDate.timeIntervalSince1970)
        
        let params: [String:Any] = [
        "\(JSONKeys.requestBody)": [
            "\(JSONKeys.timestamp)" : "\(timestamp)",
            "\(JSONKeys.device)" : [
                "\(JSONKeys.deviceId)" : UIDevice.current.identifierForVendor?.uuidString,
                "\(JSONKeys.os)" : "iOS",
                "\(JSONKeys.host)" : "lucideustech.com"
                ],
            "\(JSONKeys.data)": [
                "\(JSONKeys.userId)" : username,
                "\(JSONKeys.passwd)": password
                ]
            ]
        ]
        return params
    }
    
    static func prepareListBeneficiariesJSON() -> [String:Any] {
        
        let currentDate = Date()
        let timestamp = Int64(currentDate.timeIntervalSince1970)
        
        let userDefaults = UserDefaults.standard
        let token = userDefaults.object(forKey: "token") as! String
       // let username = userDefaults.object(forKey: "username") as! String

        let params: [String:Any] = [
            "\(JSONKeys.requestBody)": [
                "\(JSONKeys.timestamp)" : "\(timestamp)",
                "\(JSONKeys.token)" : token,
                "\(JSONKeys.device)" : [
                    "\(JSONKeys.deviceId)" : UUID.init().uuidString,
                    "\(JSONKeys.os)" : "iOS",
                    "\(JSONKeys.host)" : "lucideustech.com"
                ],
                "\(JSONKeys.data)" : []
            ]
        ]
        return params
    }
    
    static func prepareGetOtpJSON(otp_type: String) -> [String:Any] {
        
        let currentDate = Date()
        let timestamp = Int64(currentDate.timeIntervalSince1970)
        
        let userDefaults = UserDefaults.standard
        let token = userDefaults.object(forKey: "token") as! String
        // let username = userDefaults.object(forKey: "username") as! String
        
        let params: [String:Any] = [
            "\(JSONKeys.requestBody)": [
                "\(JSONKeys.timestamp)" : "\(timestamp)",
                "\(JSONKeys.token)" : token,
                "\(JSONKeys.device)" : [
                    "\(JSONKeys.deviceId)" : UUID.init().uuidString,
                    "\(JSONKeys.os)" : "iOS",
                    "\(JSONKeys.host)" : "lucideustech.com"
                ],
                "\(JSONKeys.data)" : [
                    "\(JSONKeys.otp_type)" : otp_type
                ]
            ]
        ]
        return params
    }
    
    
    
    static func prepareAddBeneficiariesJSON() -> [String:Any] {
        
        let currentDate = Date()
        let timestamp = Int64(currentDate.timeIntervalSince1970)
        
        let userDefaults = UserDefaults.standard
        let token = userDefaults.object(forKey: "token") as! String
        let username = userDefaults.object(forKey: "username") as! String
        
        let params: [String:Any] = [
            "\(JSONKeys.requestBody)": [
                "\(JSONKeys.timestamp)" : "\(timestamp)",
                "\(JSONKeys.token)" : token,
                "\(JSONKeys.device)" : [
                    "\(JSONKeys.deviceId)" : UUID.init().uuidString,
                    "\(JSONKeys.os)" : "iOS",
                    "\(JSONKeys.host)" : "lucideustech.com"
                ],
                "\(JSONKeys.data)": [
                    "\(JSONKeys.userId)" : username
                ]
            ]
        ]
        return params
    }
    static func prepareFetchBenfcJSON(alias: String) -> [String:Any] {
        
        let currentDate = Date()
        let timestamp = Int64(currentDate.timeIntervalSince1970)
        
        let userDefaults = UserDefaults.standard
        let token = userDefaults.object(forKey: "token") as! String
        
        let params: [String:Any] = [
            "\(JSONKeys.requestBody)": [
                "\(JSONKeys.timestamp)" : "\(timestamp)",
                "\(JSONKeys.token)" : token,
                "\(JSONKeys.device)" : [
                    "\(JSONKeys.deviceId)" : UUID.init().uuidString,
                    "\(JSONKeys.os)" : "iOS",
                    "\(JSONKeys.host)" : "lucideustech.com"
                ],
                "\(JSONKeys.data)": [
                    "\(JSONKeys.alias)" : alias
                ]
            ]
        ]
        return params
    }
    
    static func prepareAccountDetailsJSON() -> [String:Any] {
        
        let currentDate = Date()
        let timestamp = Int64(currentDate.timeIntervalSince1970)
        
        let userDefaults = UserDefaults.standard
        let username = userDefaults.object(forKey: "username") as! String
        let token = userDefaults.object(forKey: "token") as! String
        
        let params: [String:Any] = [
            "\(JSONKeys.requestBody)": [
                "\(JSONKeys.timestamp)" : "\(timestamp)",
                "\(JSONKeys.token)" : token,
                "\(JSONKeys.device)" : [
                    "\(JSONKeys.deviceId)" : UUID.init().uuidString,
                    "\(JSONKeys.os)" : "iOS",
                    "\(JSONKeys.host)" : "lucideustech.com"
                ],
                "\(JSONKeys.data)": [
                    "\(JSONKeys.userId)" : username
                ]
            ]
        ]
        return params
    }
    
    static func prepareAccountStatementJSON() -> [String:Any] {
        
        let currentDate = Date()
        let timestamp = Int64(currentDate.timeIntervalSince1970)
        
        let userDefaults = UserDefaults.standard
       // let username = userDefaults.object(forKey: "username") as! String
        let token = userDefaults.object(forKey: "token") as! String
        
        let params: [String:Any] = [
            "\(JSONKeys.requestBody)": [
                "\(JSONKeys.timestamp)" : "\(timestamp)",
                "\(JSONKeys.token)" : token,
                "\(JSONKeys.device)" : [
                    "\(JSONKeys.deviceId)" : UUID.init().uuidString,
                    "\(JSONKeys.os)" : "iOS",
                    "\(JSONKeys.host)" : "lucideustech.com"
                ],
                "\(JSONKeys.data)": [
                ]
            ]
        ]
        return params
    }
    
    static func prepareFilterStatementJSON(details: [String:String]) -> [String:Any]{
    
       let currentDate = Date()
        let timestamp = Int64(currentDate.timeIntervalSince1970)
        
        let userDefaults = UserDefaults.standard
        // let username = userDefaults.object(forKey: "username") as! String
        let token = userDefaults.object(forKey: "token") as! String
    
        let params: [String: Any] = [
            "\(JSONKeys.requestBody)": [
                "\(JSONKeys.timestamp)" : "\(timestamp)",
                "\(JSONKeys.token)" : token,
                "\(JSONKeys.device)" : [
                    "\(JSONKeys.deviceId)" : UUID.init().uuidString,
                    "\(JSONKeys.os)" : "iOS",
                    "\(JSONKeys.host)" : "lucideustech.com"
                ],
                "\(JSONKeys.data)": [
                    "\(JSONKeys.from_date)" : details[JSONKeys.from_date],
                    "\(JSONKeys.to_date)" : details[JSONKeys.to_date],
                    "\(JSONKeys.trans_type)" : details[JSONKeys.trans_type],
                ]
            ]
        ]
        return params
    
    }
    
    static func prepareSignUpJSON(details: [String: String]) -> [String: Any] {
        
        let currentDate = Date()
        let timestamp = Int64(currentDate.timeIntervalSince1970)
    
        let params: [String: Any] = [
            "\(JSONKeys.requestBody)": [
                "\(JSONKeys.timestamp)" : "\(timestamp)",
                "\(JSONKeys.device)" : [
                    "\(JSONKeys.deviceId)" : UUID.init().uuidString,
                    "\(JSONKeys.os)" : "iOS",
                    "\(JSONKeys.host)" : "lucideustech.com"
                ],
                "\(JSONKeys.data)": [
                    "\(JSONKeys.firstName)" : details[JSONKeys.firstName],
                    "\(JSONKeys.lastname)" : details[JSONKeys.lastname],
                    //"\(JSONKeys.gender)" : details[JSONKeys.gender],
                    "\(JSONKeys.mobile)" : details[JSONKeys.mobile],
                    "\(JSONKeys.email)" : details[JSONKeys.email],
                    "\(JSONKeys.password)" : details[JSONKeys.password],
                    //"\(JSONKeys.countryId)" : details[JSONKeys.countryId],
                    "\(JSONKeys.address)" : details[JSONKeys.address],
                    "\(JSONKeys.dob)" : details[JSONKeys.dob],
                    "\(JSONKeys.gender)" : "1",
                    "\(JSONKeys.countryId)" : "IND"
                    
                ]
            ]
        ]
        return params
    }
    
    static func prepareCheckAvailability(details: [String: String]) -> [String: Any] {
        
        let currentDate = Date()
        let timestamp = Int64(currentDate.timeIntervalSince1970)
        
        let params: [String: Any] = [
            "\(JSONKeys.requestBody)": [
                "\(JSONKeys.timestamp)" : "\(timestamp)",
                "\(JSONKeys.device)" : [
                    "\(JSONKeys.deviceId)" : UUID.init().uuidString,
                    "\(JSONKeys.os)" : "iOS",
                    "\(JSONKeys.host)" : "lucideustech.com"
                ],
                "\(JSONKeys.data)": [
                    "\(JSONKeys.mobile)" : details[JSONKeys.mobile],
                    "\(JSONKeys.email)" : details[JSONKeys.email]
                ]
            ]
        ]
        return params
    }
    
    static func prepareLogoutJSON() -> [String: Any] {
        
        let currentDate = Date()
        let timestamp = Int64(currentDate.timeIntervalSince1970)
        
        let userDefaults = UserDefaults.standard
        let token = userDefaults.object(forKey: "token") as! String
        
        let params: [String:Any] = [
            "\(JSONKeys.requestBody)": [
                "\(JSONKeys.timestamp)" : "\(timestamp)",
                "\(JSONKeys.token)" : token,
                "\(JSONKeys.device)" : [
                    "\(JSONKeys.deviceId)" : UUID.init().uuidString,
                    "\(JSONKeys.os)" : "iOS",
                    "\(JSONKeys.host)" : "lucideustech.com"
                ],
                "\(JSONKeys.data)": [
                ]
            ]
        ]
        return params
    }
    
    static func prepareVerifyOtpJSON(otp: String) -> [String: Any] {
        
        let currentDate = Date()
        let timestamp = Int64(currentDate.timeIntervalSince1970)
        
        let userDefaults = UserDefaults.standard
        let token = userDefaults.object(forKey: "token") as! String
        
        let params: [String:Any] = [
            "\(JSONKeys.requestBody)": [
                "\(JSONKeys.timestamp)" : "\(timestamp)",
                "\(JSONKeys.token)" : token,
                "\(JSONKeys.device)" : [
                    "\(JSONKeys.deviceId)" : UUID.init().uuidString,
                    "\(JSONKeys.os)" : "iOS",
                    "\(JSONKeys.host)" : "lucideustech.com"
                ],
                "\(JSONKeys.data)": [
                    "\(JSONKeys.otp)": otp
                ]
            ]
        ]
        return params
    }
    
    static func prepareVerifyOtpForPasswordRecoveryJSON(user_id: String, otp: String) -> [String: Any] {
        
        let currentDate = Date()
        let timestamp = Int64(currentDate.timeIntervalSince1970)
        let params: [String:Any] = [
            "\(JSONKeys.requestBody)": [
                "\(JSONKeys.timestamp)" : "\(timestamp)",
                "\(JSONKeys.device)" : [
                    "\(JSONKeys.deviceId)" : UUID.init().uuidString,
                    "\(JSONKeys.os)" : "iOS",
                    "\(JSONKeys.host)" : "lucideustech.com"
                ],
                "\(JSONKeys.data)": [
                    "\(JSONKeys.userId)": user_id,
                    "\(JSONKeys.otp)": otp
                ]
            ]
        ]
        return params
    }
    
    static func prepareAddBeneficiaryJSON(params: [String:String]) -> [String: Any] {
        let currentDate = Date()
        let timestamp = Int64(currentDate.timeIntervalSince1970)
        
        let userDefaults = UserDefaults.standard
        let token = userDefaults.object(forKey: "token") as! String
        
        let params: [String:Any] = [
            "\(JSONKeys.requestBody)": [
                "\(JSONKeys.timestamp)" : "\(timestamp)",
                "\(JSONKeys.token)" : token,
                "\(JSONKeys.device)" : [
                    "\(JSONKeys.deviceId)" : UUID.init().uuidString,
                    "\(JSONKeys.os)" : "iOS",
                    "\(JSONKeys.host)" : "lucideustech.com"
                ],
                "\(JSONKeys.data)": [
                    "\(JSONKeys.accoutNumber)": params[JSONKeys.accoutNumber],
                    "\(JSONKeys.alias)": params[JSONKeys.alias],
                    "\(JSONKeys.email)": params[JSONKeys.email],
                    "\(JSONKeys.ifsc)": params[JSONKeys.ifsc],
                    "\(JSONKeys.otpResponse)": params[JSONKeys.otpResponse]
                    
                ]
            ]
        ]
        return params
    }
    
    static func prepareGetBeneficiaryForBtJSON(params: [String:String]) -> [String: Any] {
        let currentDate = Date()
        let timestamp = Int64(currentDate.timeIntervalSince1970)
        
        let userDefaults = UserDefaults.standard
        let token = userDefaults.object(forKey: "token") as! String
        
        let params: [String:Any] = [
            "\(JSONKeys.requestBody)": [
                "\(JSONKeys.timestamp)" : "\(timestamp)",
                "\(JSONKeys.token)" : token,
                "\(JSONKeys.device)" : [
                    "\(JSONKeys.deviceId)" : UUID.init().uuidString,
                    "\(JSONKeys.os)" : "iOS",
                    "\(JSONKeys.host)" : "lucideustech.com"
                ],
                "\(JSONKeys.data)": [
                ]
            ]
        ]
        return params
    }
    
    static func preparePayBeneficiaryJSON(params: [String:String]) -> [String: Any] {
        let currentDate = Date()
        let timestamp = Int64(currentDate.timeIntervalSince1970)
        
        let userDefaults = UserDefaults.standard
        let token = userDefaults.object(forKey: "token") as! String
        
        let params: [String:Any] = [
            "\(JSONKeys.requestBody)": [
                "\(JSONKeys.timestamp)" : "\(timestamp)",
                "\(JSONKeys.token)" : token,
                "\(JSONKeys.device)" : [
                    "\(JSONKeys.deviceId)" : UUID.init().uuidString,
                    "\(JSONKeys.os)" : "iOS",
                    "\(JSONKeys.host)" : "lucideustech.com"
                ],
                "\(JSONKeys.data)": [
                    "\(JSONKeys.alias)" : params[JSONKeys.alias],
                    "\(JSONKeys.amount)" : params[JSONKeys.amount],
                    "\(JSONKeys.remarks)" : params[JSONKeys.remarks],
                    "\(JSONKeys.otpResponse)" : params[JSONKeys.otpResponse]
                ]
            ]
        ]
        return params
    }
    
    static func prepareDeleteBeneficiaryJSON(params: [String:String]) -> [String: Any] {
        let currentDate = Date()
        let timestamp = Int64(currentDate.timeIntervalSince1970)
        
        let userDefaults = UserDefaults.standard
        let token = userDefaults.object(forKey: "token") as! String
        
        let params: [String:Any] = [
            "\(JSONKeys.requestBody)": [
                "\(JSONKeys.timestamp)" : "\(timestamp)",
                "\(JSONKeys.token)" : token,
                "\(JSONKeys.device)" : [
                    "\(JSONKeys.deviceId)" : UUID.init().uuidString,
                    "\(JSONKeys.os)" : "iOS",
                    "\(JSONKeys.host)" : "lucideustech.com"
                ],
                "\(JSONKeys.data)": [
                    "\(JSONKeys.alias)" : params[JSONKeys.alias],
                    "\(JSONKeys.otpResponse)" : params[JSONKeys.otpResponse]
                ]
            ]
        ]
        return params
    }
    
    static func prepareRecoveryJSON(params: [String: String]) -> [String:Any] {
        
        let currentDate = Date()
        let timestamp = Int64(currentDate.timeIntervalSince1970)
        
        let params: [String:Any] = [
            "\(JSONKeys.requestBody)": [
                "\(JSONKeys.timestamp)" : "\(timestamp)",
                "\(JSONKeys.device)" : [
                    "\(JSONKeys.deviceId)" : UUID.init().uuidString,
                    "\(JSONKeys.os)" : "iOS",
                    "\(JSONKeys.host)" : "lucideustech.com"
                ],
                "\(JSONKeys.data)": [
                    "\(JSONKeys.userId)" : params[JSONKeys.userId],
                    "\(JSONKeys.otp_type)" : params[JSONKeys.otp_type]
                ]
            ]
        ]
        return params
    }
    
    static func passwordResetJSON(params: [String: String]) -> [String:Any] {
        
        let currentDate = Date()
        let timestamp = Int64(currentDate.timeIntervalSince1970)
        
        let params: [String:Any] = [
            "\(JSONKeys.requestBody)": [
                "\(JSONKeys.timestamp)" : "\(timestamp)",
                "\(JSONKeys.device)" : [
                    "\(JSONKeys.deviceId)" : UUID.init().uuidString,
                    "\(JSONKeys.os)" : "iOS",
                    "\(JSONKeys.host)" : "lucideustech.com"
                ],
                "\(JSONKeys.data)": [
                    "\(JSONKeys.userId)" : params[JSONKeys.userId],
                    "\(JSONKeys.otpResponse)" : params[JSONKeys.otpResponse],
                    "\(JSONKeys.newPassword)": params[JSONKeys.newPassword]
                ]
            ]
        ]
        return params
    }
    
    static func changePasswordJSON(params: [String: String]) -> [String:Any] {
        
        let currentDate = Date()
        let timestamp = Int64(currentDate.timeIntervalSince1970)
        
        let userDefaults = UserDefaults.standard
        let token = userDefaults.object(forKey: "token") as! String
        
        let params: [String:Any] = [
            "\(JSONKeys.requestBody)": [
                "\(JSONKeys.timestamp)" : "\(timestamp)",
                "\(JSONKeys.token)" : token,
                "\(JSONKeys.device)" : [
                    "\(JSONKeys.deviceId)" : UUID.init().uuidString,
                    "\(JSONKeys.os)" : "iOS",
                    "\(JSONKeys.host)" : "lucideustech.com"
                ],
                "\(JSONKeys.data)": [
                    "\(JSONKeys.old_pass)" : params[JSONKeys.old_pass],
                    "\(JSONKeys.new_pass)" : params[JSONKeys.new_pass],
                ]
            ]
        ]
        
        return params
    }


}



