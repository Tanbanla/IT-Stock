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
