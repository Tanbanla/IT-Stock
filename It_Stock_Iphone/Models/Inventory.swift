//
//  Inventory.swift
//  It_Stock_Iphone
//
//  Created by BIVNITMAC on 22/8/25.
//

struct InventoryRespone: Codable{
    let success: Bool
    let status: Int
    let message: String?
    let error: String?
    let data: Int?
}
struct InventoryBody: Codable {
    let id: Int?
    let dtM_DATE_INVENT: String?
    let iD_GOODS: Int?
    let nvchR_ITEM_NAME: String?
    let chR_KHO: String?
    let inT_QTY_STOCK_SUM: Int?
    let inT_QTY_GOODS_NEW: Int?
    let inT_QTY_GOOD_NEW_INVENT: Int?
    let inT_QTY_DIFF_NEW: Int?
    let nvchR_REASON_DIFF_NEW: String?
    let inT_QTY_GOODS_REUSE: Int?
    let inT_QTY_GOOD_REUSE_INVENT: Int?
    let inT_QTY_DIFF_REUSE: Int?
    let nvchR_REASON_DIFF_REUSE: String?
    let dtM_DATE_UPDATE: String?
    let chR_USER_UPDATE: String?
    let chR_USER_START_INVENT: String?
    let chR_USER_SCLOSE_INVENT: String?
    let dtM_END_INVENT: String?
    let inT_STATUS_INVENT: Int?
}
//    {
//      "id": 0,
//      "dtM_DATE_INVENT": "2025-08-22T07:43:52.450Z",
//      "iD_GOODS": 0,
//      "nvchR_ITEM_NAME": "string",
//      "chR_KHO": "string",
//      "inT_QTY_STOCK_SUM": 0,
//      "inT_QTY_GOODS_NEW": 0,
//      "inT_QTY_GOOD_NEW_INVENT": 0,
//      "inT_QTY_DIFF_NEW": 0,
//      "nvchR_REASON_DIFF_NEW": "string",
    
    
//      "inT_QTY_GOODS_REUSE": 0,
//      "inT_QTY_GOOD_REUSE_INVENT": 0,
//      "inT_QTY_DIFF_REUSE": 0,
//      "nvchR_REASON_DIFF_REUSE": "string",
//      "dtM_DATE_UPDATE": "2025-08-22T07:43:52.450Z",
//      "chR_USER_UPDATE": "string",
//      "chR_USER_START_INVENT": "string",
//      "chR_USER_SCLOSE_INVENT": "string",
//      "dtM_END_INVENT": "2025-08-22T07:43:52.450Z",
//      "inT_STATUS_INVENT": 0
//    }
