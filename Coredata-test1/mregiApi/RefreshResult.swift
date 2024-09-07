//
//  RefreshResult.swift
//  Coredata-test1
//
//  Created by 城川一理 on 2024/09/06.
//

import Foundation

struct RefreshResult: BaseResult, Codable {
    let resultCode: Int
    let message: String
    let error: [String: [String]]?
    let auth: AuthInfo?
}
