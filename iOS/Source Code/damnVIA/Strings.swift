//
//  Strings.swift
//  damnVIA
//
//  Created by Sahil on 15/09/18.
//  Copyright © 2018 lucideus. All rights reserved.
//

import Foundation

struct statusMessages {
    static let failed = "Failed"
    static let success = "Success"
}

struct segues {
    static let dashboardSegue = "dashboardSegue"
    static let addBeneficiary = "addBeneficiarySegue"
    static let viewBeneficiary = "viewBeneficiarySegue"
    static let viewSelectedBeneficiary = "viewSelectedSegue"
    static let gridSegue = "gridSegue"
    static let signUpSegue = "signUpSegue"
    static let verifyOTP = "verifyOTP"
    static let bankTransferVC2 = "btVC2Segue"
    static let bankTransferVC3 = "btVC3Segue"
    static let paymentProcess = "paymentProcess"
    static let confirmSegue = "confirmSegue"
    static let doneSegue = "doneSegue"
    static let confirmOtpSegue = "ConfirmOtpSegue"
    static let confirmPasswordSegue = "ConfirmPasswordSegue"
    static let statementSegue = "statementSegue"
    static let deleteBeneficaryOTP = "DeleteBeneficaryOTPSegue"
}

struct keychainService {
    static let service = "com.iChallengeYou.token"
}

struct AlertMessages {
    static let jailbreakMessage = "This device is jailbroken"
    static let parsingErrorMessage = "JSON decoder failed to parse"
    static let fieldEmptyMessage = "The fields cannot be empty"
    static let noInternetConnection = "No internet connection available"
}

struct AlertTitles {
    static let jailbreakTitle = "Warning"
    static let parsingErrorTitle = "Parsing Error"
    static let fieldEmptyTitle = "Blank Fields"
    static let error = "Error"
}

struct OtpType {
    static let addBeneficiary = "1"
    static let deleteBeneficiary = "2"
    static let fundTransfer = "3"
    static let forgotPassword = "4"
}

var globalIP: String = ""
var isBalanceChanged:Bool = false

enum urlPathsEnum:String{
    case login = "login"
    case showBeneficiaries = "available_beneficiary"
    case accountDetails = "account/details"
    case deleteBeneficiary = "beneficiary/delete"
    case listBeneficiaries = "beneficiary/list"
    case addBeneficiary = "beneficiary/add"
    case fetchBeneficiaryDetails = "beneficiary/fetch"
    case getOTP = "otp/get"
    case verifyOTP = "otp/verify"
    case accountStatement = "account/statement"
    case signUp = "signup"
    case checkAvailability = "signup/checkAvailability"
    case getBeneficiaryForBankTransfer = "beneficiary/get"
    case payBeneficiary = "beneficiary/pay"
    case passwordRecovery = "password/forgot"
    case verifyUser = "password/verifyuser"
    case passwordReset = "password/reset"
    case logout = "logout"
    case filteredStatement = "statement/filtered"
    case aboutus = "show?file=about.html"
    case changePassword = "password/change"
    case connectionCheck = ""
    
    var path:String{
        return "http://\(globalIP)/api/" + self.rawValue
    }
}
