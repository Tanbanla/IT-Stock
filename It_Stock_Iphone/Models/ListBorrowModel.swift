//
//  ListBorrowModel.swift
//  It_Stock_Iphone
//
//  Created by BIVNITMAC on 21/8/25.
//
struct ListBorrowModel: Codable{
    let success: Bool
    let status: Int
    let message: String?
    let error: String?
    let data: [ListBorrowData]?
}
struct ListBorrowData: Codable, Identifiable{
    let id: Int
    let iD_GOODS: String?
    let dtM_DATE_IN_OUT: String?
    let nvchR_ITEM_NAME: String?
    let chR_TYPE_GOODS: String?
    let inT_QTY_OUT: Int
    let inT_QUANTITY_REMAINING: Int
    let inT_QTY_IN_OUT: Int
    let inT_QTY_IN_STOCK: Int
    let nvchR_EQUIP_NAME: String?
    let chR_PER_IT: String?
    let chR_PER_SECT: String?
    let chR_CODE_PER_SECT: String?
    let chR_SECT: String?
    let nvchR_REASON_IN_OUT: String?
    let chR_KHO: String?
    let chR_KIND_IN_OUT: String?
    let dtM_EXPECTED_RETURN_DATE: String?
    let dtM_RETURN_DATE: String?
    let vchR_BORROWER_PHONE_NUMBER: String?
    let vchR_RETURNER_PHONE_NUMBER: String?
    let vchR_CODE_RETURNER: String?
    let nvchR_RETURNER: String?
    let vchR_BORROW_CODE: String?
    let inT_QUANTITY_RETURN: Int
}
struct BorrowListRequest: Codable {
    let chR_KHO: String
    let chR_SEC_CONTROL: String
    let iS_SEARCH: Bool
    let date_From: String
    let date_To: String
    
    // Có thể thêm custom initializer nếu cần
    init(chR_KHO: String = "ALL",
         chR_SEC_CONTROL: String,
         iS_SEARCH: Bool = false,
         date_From: String = "1753-01-01",
         date_To: String = "9998-12-31") {
        self.chR_KHO = chR_KHO
        self.chR_SEC_CONTROL = chR_SEC_CONTROL
        self.iS_SEARCH = iS_SEARCH
        self.date_From = date_From
        self.date_To = date_To
    }
}
