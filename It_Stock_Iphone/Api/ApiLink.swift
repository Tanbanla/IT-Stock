//
//  ApiLink.swift
//  It_Stock_Iphone
//
//  Created by BIVNITMAC on 16/8/25.
//
class ApiLink{
    static let shared =  ApiLink()
    private init() {}
    let baseUrl = "http://172.26.248.62:8502/api/";
    
    
    var login: String {
        return baseUrl + "Account/login";
    }
}
