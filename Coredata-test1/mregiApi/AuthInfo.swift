//
//  AuthInfo.swift
//  Coredata-test1
//
//  Created by 城川一理 on 2024/09/05.
//

import Foundation

struct AuthInfo: Codable {
    let accessToken: String
    let refreshToken: String
    let expiration: Date
}
