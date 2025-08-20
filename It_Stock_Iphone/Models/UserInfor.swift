//
//  UserInfor.swift
//  It_Stock_Iphone
//
//  Created by BIVNITMAC on 20/8/25.
//NSCameraUsageDescription
struct UserResponse: Codable {
    let success: Bool
    let status: Int?
    let message: String?
    let error: String?
    let data: UserInforData?
}
struct UserInforData: Codable {
    let id: Int
    let chR_EMPLOYEE_ID: String?
    let chR_EMPLOYEE_NAME: String?
    let chR_EMPLOYEE_ADID: String?
    let chR_EMPLOYEE_MAIL: String?
    let chR_POSITION: String?
    let chR_POSITION_GROUP: String?
    let chR_COMPANY: String?
    let chR_DEPT_GROUP: String?
    let chR_DEPT: String?
    let chR_SECTION: String?
    let chR_COST_CENTER: String?
    let chR_GROUP: String?
    let dtM_JOIN_DATE: String?
    let dtM_LEAVE_DATE: String?
    let dtM_BIRTH_DATE: String?
    let chR_ID_NUMBER: String?
    let dtM_ISSUE_ID_DATE: String?
    let chR_ISSUE_ID_PLACE: String?
    let chR_GENDER: String?
    let chR_WORK_TYPE: String?
    let chR_TEMP_ADDRESS: String?
    let chR_PHONE_NO: String?
    let chR_PERMANENT_TEL_NO: String?
    let chR_PERMANENT_ADDRESS: String?
    let chR_PROVINCE: String?
    let chR_CHANEL_CV: String?
    let chR_STUDY_LEVEL: String?
    let chR_SCHOOL_NAME: String?
    let chR_STUDY_YEAR: String?
    let chR_MAJOR: String?
    let chR_WORKING_STATUS: String?
    let chR_ETHINIC: String?
    let chR_POSITION_CODE: String?
    let chR_POSITION_NAME: String?
    let chR_DEPT_CODE: String?
    let chR_DEPT_NAME: String?
    let chR_SEC_CODE: String?
    let chR_SEC_NAME: String?
    let chR_COST_CENTER_CODE: String?
    let chR_COST_CENTER_NAME: String?
    let biT_OFICIAL_SEC: Bool?
    let chR_ANNUAL_LEAVE_DAY: String?
    let chR_TAKED_DAY: String?
    let chR_CAN_USE_DAY: String?
    let chR_CODE_GRADE: String?
    let chR_NOTE: String?
}
