//
//  ImportModel.swift
//  It_Stock_Iphone
//
//  Created by BIVNITMAC on 18/8/25.
//

import Foundation

struct ImportModel: Codable{
    let success: Bool
    let status: Int
    let message: String?
    let error: String?
    let data: Int?
}
struct ImportUsedGoodsRequest: Codable {
    let id: Int
    let iD_GOODS: Int
    let nvchR_ITEM_NAME: String
    let chR_NUM_REQUEST: String?
    let chR_NUM_PO: String?
    let chR_KHO: String
    let chR_KIND_IN_OUT: String
    let chR_TYPE_GOODS: String
    let inT_QTY_IN_OUT: Int
    let inT_QTY_IN_STOCK: Int?
    let dtM_DATE_IN_OUT: String
    let chR_PER_IT: String
    let chR_SECT: String?
    let chR_PER_SECT: String?
    let chR_CODE_PER_SECT: String?
    let nvchR_EQUIP_NAME: String?
    let nvchR_REASON_IN_OUT: String
    let chR_USER_UPDATE: String
    let dtM_DATE_UPDATE: String?
    let iD_COST_RECEIVED: Int?
    let nvchR_REASON_RESET: String?
    let inT_RESET: Int?
    let inT_QTY_PO: Int?
    let nvchR_DONVI_PO: String?
    let nvchR_DONVI_STOCK: String?
    let inT_QTY_CONVERT: Int?
    
    init(
        itemId: Int = 0,
        itemName: String,
        warehouse: String,
        quantity: Int,
        date: Date,
        userId: String,
        reason: String
    ) {
        self.id = 0
        self.iD_GOODS = itemId
        self.nvchR_ITEM_NAME = itemName
        self.chR_KHO = warehouse
        self.chR_KIND_IN_OUT = "I"
        self.chR_TYPE_GOODS = "R"
        self.inT_QTY_IN_OUT = quantity
        self.dtM_DATE_IN_OUT = ISO8601DateFormatter().string(from: date)
        self.chR_PER_IT = userId
        self.nvchR_REASON_IN_OUT = reason
        self.chR_USER_UPDATE = userId
        
        // Các trường optional khởi tạo nil
        self.chR_NUM_REQUEST = nil
        self.chR_NUM_PO = nil
        self.inT_QTY_IN_STOCK = nil
        self.chR_SECT = nil
        self.chR_PER_SECT = nil
        self.chR_CODE_PER_SECT = nil
        self.nvchR_EQUIP_NAME = nil
        self.dtM_DATE_UPDATE = nil
        self.iD_COST_RECEIVED = nil
        self.nvchR_REASON_RESET = nil
        self.inT_RESET = nil
        self.inT_QTY_PO = nil
        self.nvchR_DONVI_PO = nil
        self.nvchR_DONVI_STOCK = nil
        self.inT_QTY_CONVERT = nil
    }
}
