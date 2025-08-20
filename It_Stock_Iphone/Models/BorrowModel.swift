//
//  BorrowModel.swift
//  It_Stock_Iphone
//
//  Created by BIVNITMAC on 20/8/25.
//

struct BorrowModel: Codable{
    let success: Bool
    let status: Int
    let message: String?
    let error: String?
    let data: [BorrowData]?
}
struct BorrowData: Codable {
    let iD_GOODS: Int?
    let nvchR_ITEM_NAME: String?
    let chR_KHO: String?
    let chR_KIND_IN_OUT: String?
    let chR_TYPE_GOODS: String?
    let inT_QTY_IN_OUT: Int?
    let inT_QTY_IN_STOCK: Int?
    let dtM_DATE_IN_OUT: String?
    let chR_PER_IT: String?
    let chR_SECT: String?
    let chR_PER_SECT: String?
    let chR_CODE_PER_SECT: String?
    let nvchR_EQUIP_NAME: String?
    let nvchR_REASON_IN_OUT: String?
    let chR_USER_UPDATE: String?
    let chR_KHO_NHAN: String?
    let vchR_BORROWER_PHONE_NUMBER: String?
    let dtM_EXPECTED_RETURN_DATE: String?
    let id: Int?
    let nvchR_RETURNER: String?
    let vchR_CODE_RETURNER: String?
    let vchR_RETURNER_PHONE_NUMBER: String?
    let inT_QUANTITY_RETURN: Int?
    let dtM_RETURN_DATE: String?
    let vchR_BORROW_CODE: String?
}

