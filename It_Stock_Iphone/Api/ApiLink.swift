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
    // insert in data into in out data table + update stock qty data into stock table

//    TM_DATA_IN_OUTInfo inf = new TM_DATA_IN_OUTInfo();
//
//    inf.ID_GOODS =Convert.ToInt32( cboInputStockCategory.SelectedValue); // ID hàng
//
//    inf.NVCHR_ITEM_NAME = cboInputStockCategory.Text; // tên hàng (phân loại)
//
//    inf.CHR_NUM_REQUEST = null; // số Request
//
//    inf.CHR_NUM_PO = null; // số PO
//
//    //inf.CHR_KHO = "F1"; // vị trí kho
//
//    inf.CHR_KHO = cbo_Input_Stock.Text; // vị trí kho
//
//    inf.CHR_KIND_IN_OUT = "I"; // Nhập kho
//
//    inf.CHR_TYPE_GOODS = "R"; // Hàng tái sử dụng
//
//    inf.INT_QTY_IN_OUT = Convert.ToInt32(txtInputStockQty.Text); // số lượng nhập xuất
//
//    inf.INT_QTY_IN_STOCK = null;  // Không tính toán ở đây. Lấy dữ liệu từ kho xử lý trong StoreProcedure.
//
//    inf.DTM_DATE_IN_OUT = dtInputStockReUse.Value; // ngày nhập xuất
//
//    inf.CHR_PER_IT = Common.tmpUser.CHR_ADID; // người nhập xuất
//
//    inf.CHR_SECT = null; // phòng ban xuất
//
//    inf.CHR_PER_SECT = null; // Người phòng ban nhận
//
//    inf.CHR_CODE_PER_SECT = null; // mã nhân viên người phòng ban nhận
//
//    inf.NVCHR_EQUIP_NAME = null; // tên thiết bị
//
//    inf.NVCHR_REASON_IN_OUT = txtInputStockReson.Text; // lý do nhập xuất
//
//    inf.CHR_USER_UPDATE = Common.tmpUser.CHR_ADID;
//
//    inf.DTM_DATE_UPDATE = null; // Xử lý lấy Datetime trên server trong StoreProcedure
//
//    BUS_TM_DATA_IN_OUT.Instance().TM_DATA_IN_OUT_Insert_InsOrUpdTM_IT_KHO(inf);
    
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
    }
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
    //http://172.26.248.62:8502/api/User/get-employee-from-agentdb-by-adid-or-employee-id?adidOrEmployeeId=M0114622
//    {
//      "success": true,
//      "status": null,
//      "message": null,
//      "error": null,
//      "data": {
//        "id": 0,
//        "chR_EMPLOYEE_ID": "M0114622",
//        "chR_EMPLOYEE_NAME": "Nguyễn Duy Khánh",
//        "chR_EMPLOYEE_ADID": "khanhmf",
//        "chR_EMPLOYEE_MAIL": "nguyenduy.khanh@brother-bivn.com.vn",
//        "chR_POSITION": null,
//        "chR_POSITION_GROUP": null,
//        "chR_COMPANY": null,
//        "chR_DEPT_GROUP": null,
//        "chR_DEPT": null,
//        "chR_SECTION": "3500 : R&D-IT",
//        "chR_COST_CENTER": "3510 : R&D-IT",
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
