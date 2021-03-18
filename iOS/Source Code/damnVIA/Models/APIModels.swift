//
//  ApiModels.swift
//  damnVIA
//
//  Created by Sahil on 14/09/18.
//  Copyright © 2018 lucideus. All rights reserved.
//

import Foundation

struct loginResponseModel: Decodable {
    let status: String
    let status_code: String
    let message: String
    let timestamp: Int64
    let data: loginData?
}

struct loginData: Encodable, Decodable {
    let userid: String?
    let fname: String?
    let lname: String?
    let gender: String?
    let address: String?
    let countryId: String?
    let currency: String?
    let dob: String?
    let mobileNo: String?
    let email: String?
    let aadharId: String?
    let panCardId: String?
    let walletId: String?
    let acctNo: String?
    let acctBalance: String?
    let incomeTaxNumber: String?
    let accountOpeningDate: String?
    let token: String?
}

struct fetchBnfcResponseModel: Decodable {
    let status: String
    let status_code: String
    let message: String
    let timestamp: Int64
    let data: fetchBnfcData?
}

struct fetchBnfcData: Decodable {
    let alias: String?
    let email: String?
    let accountNumber: String?
    let ifscCode: String?
    let creationDateTime: String?
}

//struct addBnfcResponseModel: Decodable {
//    let status: String
//    let status_code: String
//    let message: String
//    let timestamp: Int64
//    let data: avlBnfcData
//}
//
//struct addBnfcData: Decodable {
//    let fname: String
//    let accNo: String
//}

struct accDetailsResponseModel: Decodable {
    let status: String
    let status_code: String
    let message: String
    let timestamp: Int64
    let data: accDetailsData
}

struct accDetailsData: Decodable {
    let accNo: String
    let aadharNo: String
    let dob: String
    let mobileNo: String
}

//struct addBeneficiaryResponseModel: Decodable {
//    let status: String
//    let status_code: String
//    let message: String
//    let timestamp: Int64
//    let data: addBeneficiaryData?
//}
//
//struct addBeneficiaryData: Decodable {
//    let bnfc: [addBeneficiaryData1]?
////}
//
//struct addBeneficiaryData1: Decodable {
//    let acctNo: String?
//    let fname: String?
//}

struct listBenfcResponseModel: Decodable {
    let status: String
    let status_code: String
    let message: String
    let timestamp: Int64
    let data: listBenfcData?
}

struct listBenfcData: Decodable {
    let alias: [String]?
}

struct accountDetailsResponseModel: Decodable {
    let status: String
    let status_code: String
    let message: String
    let timestamp: Int64
    let data: accountDetailsData?
}

struct accountDetailsData: Decodable {
    let fname: String?
    let lname: String?
    let gender: String?
    let address: String?
    let countryId: String?
    let dob: String?
    let mobileNo: String?
    let email: String?
    let aadharId: String?
    let panCardId: String?
    let walletId: String?
    let accountNumber: String?
    let accountBalance: String?
    let incomeTaxNumber: String?
    let openDate: String?
}

struct getOtpResponseModel: Decodable {
    let status: String
    let status_code: String
    let message: String
    let timestamp: Int64
    let data: getOtpDetailsData?
}

struct getOtpDetailsData: Decodable {
    let response: String?
}

struct signUpResponseModel: Decodable {
    
    let status: String
    let status_code: String
    let message: String
    let timestamp: Int64
    let data: signUpDetailsData?
}

struct signUpDetailsData: Decodable {
    let userId: String?
    let refNo: String?
}

struct logoutResponseModel: Decodable {
    
    let status: String
    let status_code: String
    let message: String
    let timestamp: Int64
    let data: logoutDetailsData?
}

struct logoutDetailsData: Decodable {
    let result: Bool?
}

struct accountStatementResponseModel: Decodable {
    let status: String
    let status_code: String
    let message: String
    let timestamp: Int64
    let data: accountStatementDetailsData?
}

struct accountStatementDetailsData: Decodable {
    let statement: [accountStatementDetailsArray]?
}

struct filteredAccountStatementResponseModel:Decodable{
    let status: String
    let status_code: String
    let message: String
    let timestamp: Int64
    let data: [accountStatementDetailsArray]?
}

struct accountStatementDetailsArray: Codable {
    let tDate: String?
    let fromToAcc: String?
    let remarks: String?
    let amount: String?
    let referenceNo: String?
    let type: String?
    
    init(from decoder: Decoder) throws{
        let value = try decoder.container(keyedBy: CodingKeys.self)
        tDate = try? value.decode(String.self, forKey: .tDate)
        fromToAcc = try? value.decode(String.self, forKey: .fromToAcc)
        remarks = try? value.decode(String.self, forKey: .remarks)
        amount = try? value.decode(String.self, forKey: .amount)
        referenceNo = try? value.decode(String.self, forKey: .referenceNo)
        type = try? value.decode(String.self, forKey: .type)
    }
}

struct verifyOtpResponseModel: Decodable {
    let status: String
    let status_code: String
    let message: String
    let timestamp: Int64
    let data: verifyOtpDetailsData?
}

struct verifyOtpDetailsData : Decodable {
    let response: String?
}

struct addBnfcResponseModel: Decodable {
    let status: String
    let status_code: String
    let message: String
    let timestamp: Int64
    let data: addBnfcDetailsData?
}

struct addBnfcDetailsData: Decodable {
    let alias: String?
    let email: String?
    let accountNumber: String?
    let ifscCode: String?
    let creationDateTime: String?
}

struct checkAvailabilityResponseModel: Decodable {
    let status: String
    let status_code: String
    let message: String
    let timestamp: Int64
    let data: chkAvailDetailsData?
}

struct chkAvailDetailsData: Decodable {
    let result: String?
}

struct getBnfcForFundTransferResponseModel: Decodable {
    let status: String
    let status_code: String
    let message: String
    let timestamp: Int64
    let data: getBnfcForFundTransferData?
}

struct getBnfcForFundTransferData: Decodable{
    let result: [String]?
}

struct payBeneficiaryResponseModel: Codable {
    let status: String
    let status_code: String
    let message: String
    let timestamp: Int64
    let data: payBeneficiaryData?
    
    init(from decoder : Decoder) throws{
        let values = try decoder.container(keyedBy: CodingKeys.self)
        status = try values.decode(String.self, forKey: .status)
        status_code = try values.decode(String.self, forKey: .status_code)
        message = try values.decode(String.self, forKey: .message)
        timestamp = try values.decode(Int64.self, forKey: .timestamp)
        data = try? values.decode(payBeneficiaryData.self, forKey: .data)
    }
}

struct payBeneficiaryData: Codable {
    let transaction_reference: String
}

struct recoveryPasswordResponseModel: Decodable {
    let status: String
    let status_code: String
    let message: String
    let timestamp: Int64
    let data: recoveryPasswordData?
}

struct recoveryPasswordData: Decodable {
    let response: String?
}

struct resetPasswordResponseModel: Decodable {
    let status: String
    let status_code: String
    let message: String
    let timestamp: Int64
    let data: resetPasswordData?
}



struct resetPasswordData: Decodable {
    
}
