//
//  ProductListResult.swift
//  mReji
//
//  Created by 鈴木仁 on 2024/03/06.
//

import Foundation

struct ProductListResult: BaseResult, Codable {
    let resultCode: Int
    let message: String
    var error: [String: [String]]?
    let data: ProductListData?

    struct ProductListData: Codable {
        let lists: [ProductInfo]
        let paginate: Paginate
    }

    struct Paginate: Codable {
        let currentPage: Int
        let totalCount: Int
    }
}
