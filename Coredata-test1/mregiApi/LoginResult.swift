//
//  LoginResult.swift
//  Coredata-test1
//
//  Created by 城川一理 on 2024/09/05.
//

import Foundation

struct LoginResult: BaseResult, Codable {
    let resultCode: Int
    let message: String
    let error: [String: [String]]?
    let user: UserInfo?
    let auth: AuthInfo?
}
