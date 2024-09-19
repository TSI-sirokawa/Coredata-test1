//
//  Transactioninfo.swift
//  Coredata-test1
//
//  Created by 城川一理 on 2024/09/18.
//

import Foundation

struct TransactionInfo: Codable{
    var contractId :  Int
    var storeId :  Int
    var storeName: String
    var transactionId :  Int
    var transactionDateTime: String?
    var transactionHeadDivision: Int
    var unitNonDiscountsubtotal :  Int
    var unitDiscountsubtotal :  Int
    var unitStaffDiscountsubtotal :  Int
    var subtotal :  Int
    var subtotalDiscountPrice :  Int
    var subtotalDiscountRate :  Int
    var subtotalDiscountDivision: String?
    var total :  Int
    var taxInclude :  Int
    var taxExclude: Int
}
