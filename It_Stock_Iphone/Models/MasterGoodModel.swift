//
//  MasterGoodModel.swift
//  It_Stock_Iphone
//
//  Created by BIVNITMAC on 18/8/25.
//

struct MasterGoodModel: Codable{
    let success: Bool
    let status: Int
    let message: String?
    let error: String?
    let data: [MasterGoodData]?
}
struct MasterGoodAloneModel: Codable{
    let success: Bool
    let status: Int
    let message: String?
    let error: String?
    let data: MasterGoodDataSL?
}
struct MasterGoodData: Codable {
    let id: Int
    let nvchR_ITEM_NAME: String
    let nvchR_PATH_IMAGE: String?
    let nvchR_PURPOSE: String
    let inT_MIN: Int
    let inT_MAX: Int
    let chR_USER_CREATE: String
    let dtM_DATE_CREATE: String
    let chR_USER_UPDATE: String
    let dtM_DATE_UPDATE: String
    let inT_FLAG_DELETE: Int
    let nvchR_DONVI_TINH: String
    let chR_SEC_CONTROL: String
    let chR_CODE_GOODS: String?
}

struct MasterGoodDataSL: Codable{
    let id: Int
    let nvchR_ITEM_NAME: String
    let nvchR_PATH_IMAGE: String?
    let nvchR_PURPOSE: String
    let inT_MIN: Int
    let inT_MAX: Int
    let inT_QTY_NEW: Int
    let inT_QTY_OLD: Int
    let chR_USER_CREATE: String
    let dtM_DATE_CREATE: String
    let chR_USER_UPDATE: String
    let dtM_DATE_UPDATE: String
    let inT_FLAG_DELETE: Int
    let nvchR_DONVI_TINH: String
    let chR_SEC_CONTROL: String
    let chR_CODE_GOODS: String?
}
