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
//    {
//      "id": 0,
//      "iD_GOODS": 0,
//      "nvchR_ITEM_NAME": "string",
//      "chR_NUM_REQUEST": "string",
//      "chR_NUM_PO": "string",
//      "chR_KHO": "string",
//      "chR_KIND_IN_OUT": "string",
//      "chR_TYPE_GOODS": "string",
//      "inT_QTY_IN_OUT": 0,
//      "inT_QTY_IN_STOCK": 0,
//      "dtM_DATE_IN_OUT": "2025-08-16T10:12:11.666Z",
//      "chR_PER_IT": "string",
//      "chR_SECT": "string",
//      "chR_PER_SECT": "string",
//      "chR_CODE_PER_SECT": "string",
//      "nvchR_EQUIP_NAME": "string",
//      "nvchR_REASON_IN_OUT": "string",
//      "chR_USER_UPDATE": "string",
//      "dtM_DATE_UPDATE": "2025-08-16T10:12:11.666Z",
//      "iD_COST_RECEIVED": 0,
//      "nvchR_REASON_RESET": "string",
//      "inT_RESET": 0,
//      "inT_QTY_PO": 0,
//      "nvchR_DONVI_PO": "string",
//      "nvchR_DONVI_STOCK": "string",
//      "inT_QTY_CONVERT": 0
//    }
    var exportBorrowReturn: String {
        return baseUrl + "DataInOut/export-borrow-return";
    }
//    {
//      "iD_GOODS": 0,
//      "nvchR_ITEM_NAME": "string",
//      "chR_KHO": "string",
//      "chR_KIND_IN_OUT": "string",
//      "chR_TYPE_GOODS": "string",
//      "inT_QTY_IN_OUT": 0,
//      "inT_QTY_IN_STOCK": 0,
//      "dtM_DATE_IN_OUT": "2025-08-16T10:14:06.089Z",
//      "chR_PER_IT": "string",
//      "chR_SECT": "string",
//      "chR_PER_SECT": "string",
//      "chR_CODE_PER_SECT": "string",
//      "nvchR_EQUIP_NAME": "string",
//      "nvchR_REASON_IN_OUT": "string",
//      "chR_USER_UPDATE": "string",
//      "chR_KHO_NHAN": "string",
//      "vchR_BORROWER_PHONE_NUMBER": "string",
//      "dtM_EXPECTED_RETURN_DATE": "2025-08-16T10:14:06.089Z",
//      "id": 0,
//      "nvchR_RETURNER": "string",
//      "vchR_CODE_RETURNER": "string",
//      "vchR_RETURNER_PHONE_NUMBER": "string",
//      "inT_QUANTITY_RETURN": 0,
//      "dtM_RETURN_DATE": "2025-08-16T10:14:06.089Z",
//      "vchR_BORROW_CODE": "string"
//    }
    //Factory
    //get by section
    var getBySection: String{
        return baseUrl + "Factory/get-by-section-control"
        //http://172.26.248.62:8502/api/Factory/get-by-section-control?sectionControl=3510
    }
//    {
//      "success": true,
//      "status": 200,
//      "message": null,
//      "error": null,
//      "data": [
//        "BIVN-F1",
//        "TTF-F1"
//      ]
//    }
    // get stock by section
    var getStockBySection: String{
        return baseUrl + "Factory/get-stock-by-section-control"
    }
//    {
//      "success": true,
//      "status": 200,
//      "message": null,
//      "error": null,
//      "data": [
//        {
//          "chR_FACT_CODE": "BIVN",
//          "chR_STOCK_NAME": "BIVN-F1",
//          "chR_TYPE": "I_O_T_L",
//          "nvchR_NOTE": "Nhập, xuất, chuyển kho, cho mượn",
//          "chR_SEC_CONTROL": "3510    "
//        },
//        {
//          "chR_FACT_CODE": "BIVN",
//          "chR_STOCK_NAME": "BIVN-F5",
//          "chR_TYPE": "I_O_L",
//          "nvchR_NOTE": "Nhập, xuất, cho mượn",
//          "chR_SEC_CONTROL": "3510    "
//        },
//        {
//          "chR_FACT_CODE": "TTF",
//          "chR_STOCK_NAME": "TTF-F1",
//          "chR_TYPE": "I_O_T_L",
//          "nvchR_NOTE": "Nhập, xuất, chuyển kho, cho mượn",
//          "chR_SEC_CONTROL": "3510    "
//        },
//        {
//          "chR_FACT_CODE": "TTF",
//          "chR_STOCK_NAME": "TTF-F2",
//          "chR_TYPE": "I_O_L",
//          "nvchR_NOTE": "Nhập, xuất, cho mượn",
//          "chR_SEC_CONTROL": "3510    "
//        }
//      ]
//    }
    //MasterGood
    var MasterGoodBySection: String{
        return baseUrl + "MasterGood/get-by-section-control"
    }
//    {
//      "success": true,
//      "status": 200,
//      "message": null,
//      "error": null,
//      "data": [http://172.26.248.62:8502/api/MasterGood/get-by-section-control?sectionControl=3510
//        {
//          "id": 358,
//          "nvchR_ITEM_NAME": "1",
//          "nvchR_PATH_IMAGE": null,
//          "nvchR_PURPOSE": "1",
//          "inT_MIN": 1,
//          "inT_MAX": 2,
//          "chR_USER_CREATE": "sonth",
//          "dtM_DATE_CREATE": "2024-09-17T14:17:37.743",
//          "chR_USER_UPDATE": "sonth",
//          "dtM_DATE_UPDATE": "2024-09-17T14:29:12.153",
//          "inT_FLAG_DELETE": 0,
//          "nvchR_DONVI_TINH": "1",
//          "chR_SEC_CONTROL": "3510    ",
//          "chR_CODE_GOODS": "1"
//        },
    var MasterByCode: String{
        return baseUrl + "MasterGood/get-by-section-control"
    }//code/kho
    //userhttp://172.26.248.62:8502/api/User/get-employee-from-agentdb-by-adid?adid=khanhmf
    var UserAdid: String{
        return baseUrl + "User/get-employee-from-agentdb-by-adid"
    }
//    {
//      "success": true,
//      "status": null,
//      "message": null,
//      "error": null,
//      "data": {
//        "id": 0,
//        "chR_EMPLOYEE_ID": "M0114622",
//        "chR_EMPLOYEE_NAME": "Nguyễn Duy Khánh",
//        "chR_EMPLOYEE_ADID": null,
//        "chR_EMPLOYEE_MAIL": null,
//        "chR_POSITION": null,
//        "chR_POSITION_GROUP": null,
//        "chR_COMPANY": null,
//        "chR_DEPT_GROUP": null,
//        "chR_DEPT": null,
//        "chR_SECTION": "3500 ",
//        "chR_COST_CENTER": null,
//        "chR_GROUP": null,
//        "dtM_JOIN_DATE": null,
//        "dtM_LEAVE_DATE": null,
//        "dtM_BIRTH_DATE": null,
//        "chR_ID_NUMBER": null,
//        "dtM_ISSUE_ID_DATE": null,
//        "chR_ISSUE_ID_PLACE": null,
//        "chR_GENDER": null,
//        "chR_WORK_TYPE": null,
//        "chR_TEMP_ADDRESS": null,
//        "chR_PHONE_NO": "0848032688",
//        "chR_PERMANENT_TEL_NO": null,
//        "chR_PERMANENT_ADDRESS": null,
//        "chR_PROVINCE": null,
//        "chR_CHANEL_CV": null,
//        "chR_STUDY_LEVEL": null,
//        "chR_SCHOOL_NAME": null,
//        "chR_STUDY_YEAR": null,
//        "chR_MAJOR": null,
//        "chR_WORKING_STATUS": null,
//        "chR_ETHINIC": null,
//        "chR_POSITION_CODE": null,
//        "chR_POSITION_NAME": null,
//        "chR_DEPT_CODE": null,
//        "chR_DEPT_NAME": null,
//        "chR_SEC_CODE": null,
//        "chR_SEC_NAME": null,
//        "chR_COST_CENTER_CODE": null,
//        "chR_COST_CENTER_NAME": null,
//        "biT_OFICIAL_SEC": null,
//        "chR_ANNUAL_LEAVE_DAY": null,
//        "chR_TAKED_DAY": null,
//        "chR_CAN_USE_DAY": null,
//        "chR_CODE_GRADE": null,
//        "chR_NOTE": null
//      }
//    }
}
