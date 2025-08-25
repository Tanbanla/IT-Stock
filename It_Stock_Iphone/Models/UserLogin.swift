//
//  UserLogin.swift
//  It_Stock_Iphone
//
//  Created by BIVNITMAC on 16/8/25.
//
struct LoginResponse: Codable {
    let success: Bool
    let status: Int
    let message: String
    let error: String?
    let data: UserData?
}
struct UserData: Codable {
    let id: Int
    let chR_USERID: String
    let chR_EMLPLOYEEID: String
    let chR_ADID: String
    let nvchR_NAME: String
    let chR_PASS: String?
    let chR_SEC_CODE: String?
    let chR_EMAIL: String?
    let chR_TELL: String?
    let chR_COST_CENTER: String?
}
//Dữ liệu truyền vào post
struct LoginRequest: Codable {
    let userADID: String
    let password: String
}
