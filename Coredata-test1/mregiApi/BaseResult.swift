//
//  BaseResult.swift
//  Coredata-test1
//
//  Created by 城川一理 on 2024/09/05.
//

import Foundation

protocol BaseResult {
    var resultCode: Int { get }
    var message: String { get }
    var error: [String: [String]]? { get }
}
