//
//  FactoryModel.swift
//  It_Stock_Iphone
//
//  Created by Nguyen Duy Khanh on 18/8/25.
//
struct FactoryModel: Codable {
    let success: Bool
    let status: Int
    let message: String?
    let error: String?
    let data: [String]?
}
struct FactoryData: Codable{
    let chR_FACT_CODE: String
    let chR_STOCK_NAME: String
    let chR_TYPE: String
    let nvchR_NOTE: String
    let chR_SEC_CONTROL: String
}

// Model list factory
struct ListFactoryModel: Codable {
    let success: Bool
    let status: Int
    let message: String?
    let error: String?
    let data: [FactoryData]?
}
