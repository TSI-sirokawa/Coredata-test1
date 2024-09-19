//
//  TransactionListResult.swift
//  Coredata-test1
//
//  Created by 城川一理 on 2024/09/18.
//

import Foundation

struct TransactionListResult: BaseResult, Codable {
    let resultCode: Int
    let message: String
    var error: [String: [String]]?
    let data: TransactionListData?

    struct TransactionListData: Codable {
        let lists: [TransactionInfo]
        let paginate: Paginate
    }

    struct Paginate: Codable {
        let currentPage: Int
        let totalCount: Int
    }
}
