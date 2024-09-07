//
//  PermanentDataManager.swift
//  Coredata-test1
//
//  Created by 城川一理 on 2024/09/06.
//

import Foundation

/// UserDefaults使用まとめ
final class PermanentDataManager {
    enum SaveType {
        case string
        case int
        case bool
        case object
    }
    enum DataType: String {
        case myStaffId
        case password
        case authInfo
        case colorTheme
        case isMainPaymentButtonVisibility  // 入金
        case isMainClaimButtonVisibility  // 請求
        case isMainWithdrawalButtonVisibility  // 出金
        case isMainCustodyButtonVisibility  // 預かり
        case isMainRefundButtonVisibility  // 返金
        case isMainDrawerButtonVisibility  // ドロア

        func saveType() -> SaveType {
            switch self {
            case .myStaffId: return .int
            case .password: return .string
            case .authInfo: return .object
            case .colorTheme: return .string
            case .isMainPaymentButtonVisibility: return .bool
            case .isMainClaimButtonVisibility: return .bool
            case .isMainWithdrawalButtonVisibility: return .bool
            case .isMainCustodyButtonVisibility: return .bool
            case .isMainRefundButtonVisibility: return .bool
            case .isMainDrawerButtonVisibility: return .bool
            }
        }
    }

    static func save(type: DataType, data: Any) {
        let key = String(type.rawValue)
        switch type.saveType() {
        case .string:
            if let strData = data as? String {
                UserDefaults.standard.set(strData, forKey: key)
            }
        case .int:
            if let intData = data as? Int {
                UserDefaults.standard.set(intData, forKey: key)
            }
        case .bool:
            if let boolData = data as? Bool {
                UserDefaults.standard.set(boolData, forKey: key)
            }
        case .object:
            UserDefaults.standard.set(data, forKey: key)
        }

    }

    static func load(type: DataType) -> Any? {
        let key = String(type.rawValue)
        return switch type.saveType() {
        case .string:
            UserDefaults.standard.string(forKey: key)
        case .int:
            UserDefaults.standard.integer(forKey: key)
        case .bool:
            if UserDefaults.standard.object(forKey: key) != nil {
                UserDefaults.standard.bool(forKey: key)
            } else {
                nil
            }
        case .object:
            UserDefaults.standard.object(forKey: key)
        }
    }

    static func remove(type: DataType) {
        let key = String(type.rawValue)
        UserDefaults.standard.removeObject(forKey: key)
    }

    // MARK: -

    static func saveObject<T>(type: DataType, data: T) where T: Encodable {
        guard let encoded = try? JSONEncoder().encode(data) else { return }
        save(type: .authInfo, data: encoded)
    }

    static func loadObject<T>(type: DataType, objectType: T.Type) -> T? where T: Decodable {
        guard let data = load(type: .authInfo) as? Data,
            let result = try? JSONDecoder().decode(objectType, from: data)
        else { return nil }
        return result
    }
}
