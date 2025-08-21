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
    //user
    var UserBySystem: String{
        return baseUrl + "User/get-by-adid"
    }
    //http://172.26.248.62:8502/api/User/get-by-adid?adid=khanhmf
//    {
//      "id": 56,
//      "chR_USERID": "khanhmf",
//      "chR_EMLPLOYEEID": "M0114622",
//      "chR_ADID": "khanhmf",
//      "nvchR_NAME": "Nguyễn Duy Khánh",
//      "chR_PASS": "123456",
//      "inT_USERID_COMMON": 0,
//      "chR_SEC_CODE": "3500",
//      "chR_EMAIL": "khanhmf@brothergroud.net",
//      "dtM_LAST_LOGIN": null,
//      "inT_LOCK": null,
//      "chR_USER_CREATE": null,
//      "dtM_DATE_CREATE": null,
//      "chR_USER_UPDATE": null,
//      "dtM_DATE_UPDATE": null,
//      "chR_TELL": "2075",
//      "inT_LOCK_DAY": 30,
//      "chR_COST_CENTER": "3510"
//    }
    var UserAdidOrID: String{
        return baseUrl + "User/get-employee-from-agentdb-by-adid-or-employee-id"
    }
}
