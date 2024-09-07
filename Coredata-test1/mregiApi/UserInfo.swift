//
//  UserInfo.swift
//  Coredata-test1
//
//  Created by 城川一理 on 2024/09/05.
//

import Foundation

struct UserInfo: Codable {
    let id: Int?  // staffIdと同一
    let staffId: Int?  // idと同一
    let contractId: Int
    let storeId: Int
    let staffNumber: String
    let staffName: String
    let staffNameKana: String
    let displayFlag: Int
    let displaySequence: Int
    let loginStaffFlag: Int
    let email: String
}
