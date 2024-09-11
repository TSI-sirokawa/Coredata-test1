//
//  ProductListForm.swift
//  mReji
//
//  Created by 鈴木仁 on 2024/03/06.
//

import Foundation

struct ProductListForm: Encodable {
    var currentPage: Int
    var perPage: Int
    var categoryId: Int?
    var keyword: String?
}
