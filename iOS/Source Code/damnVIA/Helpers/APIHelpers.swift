//
//  ApiHelpers.swift
//  damnVIA
//
//  Created by Sahil Pahwa on 15/09/18.
//  Copyright © 2018 lucideus. All rights reserved.
//

import Foundation
import Alamofire

enum AppError:Error{
    case ConnectionError
}

extension AppError:LocalizedError{
    var errorDescription: String?{
        switch self{
        case .ConnectionError:
            return "Please check the server IP address and port"
        }
    }
}

class APIHelpers {
    
    class func isConnectedToInternet()->Bool{
        return NetworkReachabilityManager()!.isReachable
    }
    
    static func hitConnection(manager:inout SessionManager?,completionHandler: @escaping (String?,Error?) -> ()) {
        
        let queue = DispatchQueue(label: "com.lucideustech.vulnbank", qos: .userInteractive, attributes: .concurrent, autoreleaseFrequency: .inherit, target: DispatchQueue.global())
        
        guard let url = URL(string: urlPathsEnum.connectionCheck.path) else { return }
        let configuration = URLSessionConfiguration.default
        configuration.timeoutIntervalForRequest = 10
        configuration.timeoutIntervalForResource = 10
        manager = Alamofire.SessionManager(configuration: configuration)
        
        print("connecting to url : \(urlPathsEnum.connectionCheck.path)")
            
        // for debug
        manager!.request(url, method: .get, parameters: nil, encoding: JSONEncoding.default).responseString(queue: queue) { (response) in
                print(response)
            switch response.result{
            case .success(let string):
                if string.contains("Welcome"){
                    completionHandler(string,nil)
                }else{
                    completionHandler(nil,AppError.ConnectionError)
                }
                break
            case .failure(let error):
                print(error.localizedDescription)
                completionHandler(nil,error)
            }
        }
        
    }
    
    static func hitLogin(username: String, password: String, completionHandler: @escaping (Data?,Error?) -> ()) {
        
        let params: [String:Any] = JSONHelpers.prepareLoginJSON(username: username, password: password)
        let queue = DispatchQueue(label: "com.lucideustech.login", qos: .userInteractive, attributes: .concurrent, autoreleaseFrequency: .inherit, target: DispatchQueue.global())
        
        guard let url = URL(string: urlPathsEnum.login.path) else { return }
        let manager = Alamofire.SessionManager.default
        manager.session.configuration.timeoutIntervalForRequest = 300
        
        manager.request(url, method: .post, parameters: params, encoding: JSONEncoding.default).responseData(queue: queue) { (response) in
            
            switch response.result{
            case .success(let data):
                completionHandler(data,nil)
            case .failure(let error):
                print(error.localizedDescription)
                completionHandler(nil,error)
            }
        }        
    }
    
    // list all beneficiaries for a particular user --> recently changed, look to it
    static func hitListBeneficiaries(completionHandler: @escaping (Data?,Error?) -> ()) {
        let params: [String:Any] = JSONHelpers.prepareListBeneficiariesJSON()
        let queue = DispatchQueue(label: "com.lucideustech.avlBnfc", qos: .userInteractive, attributes: .concurrent, autoreleaseFrequency: .inherit, target: DispatchQueue.global())
        
        guard let url = URL(string: urlPathsEnum.listBeneficiaries.path) else { return }
        let manager = Alamofire.SessionManager.default
        manager.session.configuration.timeoutIntervalForRequest = 300
        
        manager.request(url, method: .post, parameters: params, encoding: JSONEncoding.default).responseData(queue: queue) { (response) in
            switch response.result{
            case .success(let data):
                completionHandler(data,nil)
            case .failure(let error):
                print(error.localizedDescription)
                completionHandler(nil,error)
            }
        }
    }
    
    static func hitGetOtp(otp_type: String, completionHandler: @escaping (Data?,Error?) -> ()) {
        let params: [String:Any] = JSONHelpers.prepareGetOtpJSON(otp_type: otp_type)
        let queue = DispatchQueue(label: "com.lucideustech.getOtp", qos: .userInteractive, attributes: .concurrent, autoreleaseFrequency: .inherit, target: DispatchQueue.global())
        
        guard let url = URL(string: urlPathsEnum.getOTP.path) else { return }
        let manager = Alamofire.SessionManager.default
        manager.session.configuration.timeoutIntervalForRequest = 300
  
        manager.request(url, method: .post, parameters: params, encoding: JSONEncoding.default).responseData(queue: queue) { (response) in
            switch response.result{
            case .success(let data):
                completionHandler(data,nil)
            case .failure(let error):
                print(error.localizedDescription)
                completionHandler(nil,error)
            }
        }
    }
    
//    static func hitAddBeneficiary(completionHandler: @escaping (Data?) -> ()) {
//        let params: [String:Any] = JSONHelpers.prepareAddBeneficiariesJSON()
//        let queue = DispatchQueue(label: "com.lucideustech.addBnfc", qos: .userInteractive, attributes: .concurrent, autoreleaseFrequency: .inherit, target: DispatchQueue.global())
//        
//        guard let url = URL(string: urlPaths.addBeneficiary) else { return }
//        let manager = Alamofire.SessionManager.default
//        manager.session.configuration.timeoutIntervalForRequest = 300
//        
//        manager.request(url, method: .post, parameters: params, encoding: JSONEncoding.default).responseData(queue: queue) { (response) in
//            completionHandler(response.data)
//        }
//    }
    
    //complete
    static func fetchSelectedBeneficiary(alias: String, completionHandler: @escaping (Data?,Error?) -> ()) {
        let params: [String:Any] = JSONHelpers.prepareFetchBenfcJSON(alias: alias)
        let queue = DispatchQueue(label: "com.lucideustech.viewSlctdBnfc", qos: .userInteractive, attributes: .concurrent, autoreleaseFrequency: .inherit, target: DispatchQueue.global())
        
        guard let url = URL(string: urlPathsEnum.fetchBeneficiaryDetails.path) else { return }
        let manager = Alamofire.SessionManager.default
        manager.session.configuration.timeoutIntervalForRequest = 300
        
        manager.request(url, method: .post, parameters: params, encoding: JSONEncoding.default).responseData(queue: queue) { (response) in
            switch response.result{
            case .success(let data):
                completionHandler(data,nil)
            case .failure(let error):
                print(error.localizedDescription)
                completionHandler(nil,error)
            }
        }
    }
    
    
    static func hitAccountDetails(completionHandler: @escaping (Data?,Error?) -> ()) {
        let params: [String:Any] = JSONHelpers.prepareAccountDetailsJSON()
        let queue = DispatchQueue(label: "com.lucideustech.hitAccDet", qos: .userInteractive, attributes: .concurrent, autoreleaseFrequency: .inherit, target: DispatchQueue.global())
        
        guard let url = URL(string: urlPathsEnum.accountDetails.path) else { return }
        let manager = Alamofire.SessionManager.default
        manager.session.configuration.timeoutIntervalForRequest = 300
        
        manager.request(url, method: .post, parameters: params, encoding: JSONEncoding.default).responseData(queue: queue) { (response) in
            switch response.result{
            case .success(let data):
                completionHandler(data,nil)
            case .failure(let error):
                print(error.localizedDescription)
                completionHandler(nil,error)
            }
        }
    }
    
    static func hitAccountStatement(completionHandler: @escaping (Data?,Error?)  -> ()) {
        
        let params: [String:Any] = JSONHelpers.prepareAccountStatementJSON()
        let queue = DispatchQueue(label: "com.lucideustech.hitAccStmnt", qos: .userInteractive, attributes: .concurrent, autoreleaseFrequency: .inherit, target: DispatchQueue.global())
        
        //let userDefaults = UserDefaults.standard
        //let username = userDefaults.object(forKey: "username") as! String
        
        print(params)
        
        guard let url = URL(string: urlPathsEnum.accountStatement.path) else { return }
        let manager = Alamofire.SessionManager.default
        manager.session.configuration.timeoutIntervalForRequest = 300
        
        manager.request(url, method: .post, parameters: params, encoding: JSONEncoding.default).responseData(queue: queue) { (response) in
            
            switch response.result{
            case .success(let data):
                completionHandler(data,nil)
            case .failure(let error):
                print(error.localizedDescription)
                completionHandler(nil,error)
            }
        }
        
                // used for debugging
                manager.request(url, method: .post, parameters: params, encoding: JSONEncoding.default).responseString { (response) in
                    print(response)
                }
    }
    
    static func hitFilteredStatement(details: [String: String], completionHandler: @escaping (Data?,Error?)  -> ()) {
        let params: [String:Any] = JSONHelpers.prepareFilterStatementJSON(details: details)
        let queue = DispatchQueue(label: "com.lucideustech.hitAccStmnt", qos: .userInteractive, attributes: .concurrent, autoreleaseFrequency: .inherit, target: DispatchQueue.global())
        
        //let userDefaults = UserDefaults.standard
        //let username = userDefaults.object(forKey: "username") as! String
        print(params)
        
        guard let url = URL(string: urlPathsEnum.filteredStatement.path) else { return }
        let manager = Alamofire.SessionManager.default
        manager.session.configuration.timeoutIntervalForRequest = 300
        
        manager.request(url, method: .post, parameters: params, encoding: JSONEncoding.default).responseData(queue: queue) { (response) in
            
            switch response.result{
            case .success(let data):
                completionHandler(data,nil)
            case .failure(let error):
                print(error.localizedDescription)
                completionHandler(nil,error)
            }
        }
        
                // used for debugging
                manager.request(url, method: .post, parameters: params, encoding: JSONEncoding.default).responseString { (response) in
                    print(response)
                }
    }
    
    static func hitSignup(details: [String: String], completionHandler: @escaping (Data?,Error?) -> ()) {
        
        let params: [String:Any] = JSONHelpers.prepareSignUpJSON(details: details)
        let queue = DispatchQueue(label: "com.lucideustech.hitSignup", qos: .userInteractive, attributes: .concurrent, autoreleaseFrequency: .inherit, target: DispatchQueue.global())
        
        print(params)
        
        guard let url = URL(string: urlPathsEnum.signUp.path) else { return }
        let manager = Alamofire.SessionManager.default
        manager.session.configuration.timeoutIntervalForRequest = 300
        
        manager.request(url, method: .post, parameters: params, encoding: JSONEncoding.default).responseData(queue: queue) { (response) in
            print(response)
            switch response.result{
            case .success(let data):
                completionHandler(data,nil)
            case .failure(let error):
                print(error.localizedDescription)
                completionHandler(nil,error)
            }
        }
    }
    
    static func hitCheckAvailability(details: [String: String], completionHandler: @escaping (Data?,Error?) -> ()) {
        
        let params: [String:Any] = JSONHelpers.prepareCheckAvailability(details: details)
        print(params)
        let queue = DispatchQueue(label: "com.lucideustech.hitCheckAvailability", qos: .userInteractive, attributes: .concurrent, autoreleaseFrequency: .inherit, target: DispatchQueue.global())
        
        guard let url = URL(string: urlPathsEnum.checkAvailability.path) else { return }
        let manager = Alamofire.SessionManager.default
        manager.session.configuration.timeoutIntervalForRequest = 300
        
        manager.request(url, method: .post, parameters: params, encoding: JSONEncoding.default).responseData(queue: queue) { (response) in
            switch response.result{
            case .success(let data):
                completionHandler(data,nil)
            case .failure(let error):
                print(error.localizedDescription)
                completionHandler(nil,error)
            }
        }
    }
    
    static func hitLogout(completionHandler: @escaping (Data?,Error?) ->()) {
        let params: [String:Any] = JSONHelpers.prepareLogoutJSON()
        let queue = DispatchQueue(label: "com.lucideustech.hitLogout", qos: .userInteractive, attributes: .concurrent, autoreleaseFrequency: .inherit, target: DispatchQueue.global())
        
        guard let url = URL(string: urlPathsEnum.logout.path) else { return }
        let manager = Alamofire.SessionManager.default
        manager.session.configuration.timeoutIntervalForRequest = 300
        
        manager.request(url, method: .post, parameters: params, encoding: JSONEncoding.default).responseData(queue: queue) { (response) in
            switch response.result{
            case .success(let data):
                completionHandler(data,nil)
            case .failure(let error):
                print(error.localizedDescription)
                completionHandler(nil,error)
            }
        }
    }
    
    static func hitVerifyOtp(otp: String, otp_type: Int, user_id: String?, completionHandler: @escaping (Data?,Error?) ->()) {
        let params: [String:Any] = otp_type > 0 ? JSONHelpers.prepareVerifyOtpJSON(otp: otp): JSONHelpers.prepareVerifyOtpForPasswordRecoveryJSON(user_id: user_id!,otp: otp)
        let queue = DispatchQueue(label: "com.lucideustech.hitVerifyOtp", qos: .userInteractive, attributes: .concurrent, autoreleaseFrequency: .inherit, target: DispatchQueue.global())
        
        guard let url = URL(string: otp_type > 0 ? urlPathsEnum.verifyOTP.path: urlPathsEnum.verifyUser.path) else { return }
        let manager = Alamofire.SessionManager.default
        manager.session.configuration.timeoutIntervalForRequest = 300
        
        manager.request(url, method: .post, parameters: params, encoding: JSONEncoding.default).responseData(queue: queue) { (response) in
            switch response.result{
            case .success(let data):
                completionHandler(data,nil)
            case .failure(let error):
                print(error.localizedDescription)
                completionHandler(nil,error)
            }
        }
    }
    
    static func hitAddBeneficiary(params: [String: String], completionHandler: @escaping (Data?,Error?) ->()) {
        let params: [String:Any] = JSONHelpers.prepareAddBeneficiaryJSON(params: params)
        let queue = DispatchQueue(label: "com.lucideustech.addBeneficiary", qos: .userInteractive, attributes: .concurrent, autoreleaseFrequency: .inherit, target: DispatchQueue.global())
        
        guard let url = URL(string: urlPathsEnum.addBeneficiary.path) else { return }
        let manager = Alamofire.SessionManager.default
        manager.session.configuration.timeoutIntervalForRequest = 300
        
        manager.request(url, method: .post, parameters: params, encoding: JSONEncoding.default).responseData(queue: queue) { (response) in
            switch response.result{
            case .success(let data):
                completionHandler(data,nil)
            case .failure(let error):
                print(error.localizedDescription)
                completionHandler(nil,error)
            }
        }
    }
    
    static func getBeneficiaryForBt(params: [String: String], completionHandler: @escaping (Data?,Error?) ->()) {
        let params: [String:Any] = JSONHelpers.prepareGetBeneficiaryForBtJSON(params: params)
        let queue = DispatchQueue(label: "com.lucideustech.getBeneficiaryForBt", qos: .userInteractive, attributes: .concurrent, autoreleaseFrequency: .inherit, target: DispatchQueue.global())
        
        guard let url = URL(string: urlPathsEnum.getBeneficiaryForBankTransfer.path) else { return }
        let manager = Alamofire.SessionManager.default
        manager.session.configuration.timeoutIntervalForRequest = 300
        
        manager.request(url, method: .post, parameters: params, encoding: JSONEncoding.default).responseData(queue: queue) { (response) in
            switch response.result{
            case .success(let data):
                completionHandler(data,nil)
            case .failure(let error):
                print(error.localizedDescription)
                completionHandler(nil,error)
            }
        }
    }
    
    static func payBeneficiary(params: [String: String], completionHandler: @escaping (Data?,Error?) ->()) {
        let params: [String:Any] = JSONHelpers.preparePayBeneficiaryJSON(params: params)
        let queue = DispatchQueue(label: "com.lucideustech.payBeneficiary", qos: .userInteractive, attributes: .concurrent, autoreleaseFrequency: .inherit, target: DispatchQueue.global())
        
        guard let url = URL(string: urlPathsEnum.payBeneficiary.path) else { return }
        let manager = Alamofire.SessionManager.default
        manager.session.configuration.timeoutIntervalForRequest = 300
        
        print(params)
        
        manager.request(url, method: .post, parameters: params, encoding: JSONEncoding.default).responseData(queue: queue) { (response) in
            switch response.result{
            case .success(let data):
                completionHandler(data,nil)
            case .failure(let error):
                print(error.localizedDescription)
                completionHandler(nil,error)
            }
        }
    }
    
    static func passwordRecovery(params: [String: String], completionHandler: @escaping (Data?,Error?) ->()) {
        let params: [String:Any] = JSONHelpers.prepareRecoveryJSON(params: params)
        let queue = DispatchQueue(label: "com.lucideustech.passwordRecovery", qos: .userInteractive, attributes: .concurrent, autoreleaseFrequency: .inherit, target: DispatchQueue.global())
        
        guard let url = URL(string: urlPathsEnum.passwordRecovery.path) else { return }
        let manager = Alamofire.SessionManager.default
        manager.session.configuration.timeoutIntervalForRequest = 300
        
        manager.request(url, method: .post, parameters: params, encoding: JSONEncoding.default).responseData(queue: queue) { (response) in
            switch response.result{
            case .success(let data):
                completionHandler(data,nil)
            case .failure(let error):
                print(error.localizedDescription)
                completionHandler(nil,error)
            }
        }
    }
    
    static func passwordReset(params: [String: String], completionHandler: @escaping (Data?,Error?) ->()) {
        let params: [String:Any] = JSONHelpers.passwordResetJSON(params: params)
        let queue = DispatchQueue(label: "com.lucideustech.passwordReset", qos: .userInteractive, attributes: .concurrent, autoreleaseFrequency: .inherit, target: DispatchQueue.global())
        
        guard let url = URL(string: urlPathsEnum.passwordReset.path) else { return }
        let manager = Alamofire.SessionManager.default
        manager.session.configuration.timeoutIntervalForRequest = 300
        
        manager.request(url, method: .post, parameters: params, encoding: JSONEncoding.default).responseData(queue: queue) { (response) in
            switch response.result{
            case .success(let data):
                completionHandler(data,nil)
            case .failure(let error):
                print(error.localizedDescription)
                completionHandler(nil,error)
            }
        }
    }
    
    static func hitChangePassword(params: [String:String],completionHandler:@escaping (Data?,Error?) -> ()){
        let params:[String:Any] = JSONHelpers.changePasswordJSON(params: params)
        let queue = DispatchQueue(label: "com.lucideustech.changePassword", qos: .userInteractive, attributes: .concurrent, autoreleaseFrequency: .inherit, target: .global())
        
        guard let url = URL(string: urlPathsEnum.changePassword.path) else { return }
        let manager = Alamofire.SessionManager.default
        manager.session.configuration.timeoutIntervalForRequest = 300
        
        manager.request(url, method: .post, parameters: params, encoding: JSONEncoding.default).responseData(queue: queue) { (response) in
            switch response.result{
            case .success(let data):
                completionHandler(data,nil)
            case .failure(let error):
                print(error.localizedDescription)
                completionHandler(nil,error)
            }
        }
    }
    
    
     static func deleteBeneficiary(params: [String: String], completionHandler: @escaping (Data?,Error?) ->()) {
            let params: [String:Any] = JSONHelpers.prepareDeleteBeneficiaryJSON(params: params)
            let queue = DispatchQueue(label: "com.lucideustech.deleteBeneficiary", qos: .userInteractive, attributes: .concurrent, autoreleaseFrequency: .inherit, target: DispatchQueue.global())
            
            guard let url = URL(string: urlPathsEnum.deleteBeneficiary.path) else { return }
            let manager = Alamofire.SessionManager.default
            manager.session.configuration.timeoutIntervalForRequest = 300
            
            manager.request(url, method: .post, parameters: params, encoding: JSONEncoding.default).responseData(queue: queue) { (response) in
                switch response.result{
                case .success(let data):
                    completionHandler(data,nil)
                case .failure(let error):
                    print(error.localizedDescription)
                    completionHandler(nil,error)
                }
            }
            
            // used for debugging
            manager.request(url, method: .post, parameters: params, encoding: JSONEncoding.default).responseString { (response) in
                print(response)
            }
        }

}
