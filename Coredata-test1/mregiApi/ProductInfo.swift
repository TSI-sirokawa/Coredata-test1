//
//  ProductInfo.swift
//  mReji
//
//  Created by 鈴木仁 on 2024/03/11.
//

import Foundation

struct ProductInfo: Codable {
    var contractId: Int
    var storeId: Int
    var id: Int
    var categoryId: Int
    var categoryName: String
    var productNumber: String
    var productName: String
    var productKana: String
    var taxDivision: TaxDivision
    var price: Int
    var patientPrice: Int?
    var cost: Double?
    var displaySequence: Int?
    var productDivision: Int?
    var pointNotApplicable: PointNotApplicable
    var calcDiscount: CalcDiscount
    var useCategoryReduceTax: UseCategoryReduceTax
    //var reduceTaxPrice: CategoryInfo.ReduceTaxId
    var printReceiptDivision: PrintReceiptDivision
    var printReceiptProductName: String?
    var productImage: String?
    var displayFlag: DisplayFlag?

    enum UseCategoryReduceTax: Int, Codable {
        case off = 0
        case on = 1
    }

    enum PrintReceiptDivision: Int, Codable {
        case off = 0
        case on = 1
    }

    enum DisplayFlag: Int, Codable {
        case off = 0
        case on = 1
    }

    enum PointNotApplicable: Int, Codable {
        case on = 0
        case off = 1

        func toLabel() -> String {
            switch self {
            case .on: return "ポイント対象"
            case .off: return "ポイント対象外"
            }
        }
    }

    enum CalcDiscount: Int, Codable {
        case off = 0
        case on = 1
    }

    enum TaxDivision: Int, Codable {
        case taxIncluded = 0
        case taxExcluded = 1
        case taxExempt = 2

        func toLabel() -> String {
            switch self {
            case .taxIncluded: return "税込"
            case .taxExcluded: return "税抜"
            case .taxExempt: return "非課税"
            }
        }

        func toProductLabel() -> String {
            switch self {
            case .taxIncluded: return "内税"
            case .taxExcluded: return "外税"
            case .taxExempt: return "非課税"
            }
        }
    }

    enum ReduceTaxId: Int, Codable {
        case standardTaxRate = 10_000_002
        case reducedTaxRate = 10_000_001

        func toLabel() -> String {
            switch self {
            case .standardTaxRate: return "標準税率"
            case .reducedTaxRate: return "軽減税率"
            }
        }
    }

    /// 割引後の値段を取得
    /// - Returns: 値段
    func getDiscountedPrice() -> Int {
        return price - (patientPrice ?? price)
    }

    /// 割引率のパーセントを取得
    /// - Returns: パーセントの値
    func getDiscountPercent() -> Int {
        return if price != 0 {
            getDiscountedPrice() * 100 / price
        } else {
            0
        }
    }
}
