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
    
    //DataInOut
    var importUsedgood: String{
        return baseUrl + "DataInOut/import-used-goods";
    }
    var exportBorrowReturn: String {
        return baseUrl + "DataInOut/export-borrow-return";
    }
    var listBorrowNotReturn: String{
        return baseUrl + "DataInOut/get-list-borrowed-data";
    }
    //Factory
    //get by section
    var getBySection: String{
        return baseUrl + "Factory/get-by-section-control"
    }
    // get stock by section
    var getStockBySection: String{
        return baseUrl + "Factory/get-stock-by-section-control"
    }
    //MasterGood
    var MasterGoodBySection: String{
        return baseUrl + "MasterGood/get-by-section-control"
    }
    var MasterByCode: String{
        return baseUrl + "MasterGood/get-by-code"
    }
    // Inventory
    var Inventory: String{
        return baseUrl + "Inventory/update-inventory"
    }
    //user
    var UserBySystem: String{
        return baseUrl + "User/get-by-adid"
    }
    var UserAdidOrID: String{
        return baseUrl + "User/get-employee-from-agentdb-by-adid-or-employee-id"
    }
}
