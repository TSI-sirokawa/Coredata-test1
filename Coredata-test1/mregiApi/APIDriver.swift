//
//  APIDriver.swift
//  Coredata-test1
//
//  Created by 城川一理 on 2024/09/06.
//


import Alamofire
import Foundation

struct APIDriverResult {
    var responseData: Data
    var responseSting: String
    var responseObj: Any
    var responseHeader: Any?
    var statusCode: Int

    func responseJson() -> [String: Any] {
        responseObj as? [String: Any] ?? [:]
    }

    func responseJsonArray() -> [Any] {
        responseObj as? [Any] ?? []
    }
}

enum APIDriverError: Error {
    case logic(String)
    case api(String, APIDriverResult)
    case network
    case invalidRefreshToken
    case notFound
    case unknown
}

extension APIDriverError: LocalizedError {
    var errorDescription: String? {
        switch self {
        case let .logic(message): return message
        case .unknown: return "不明なエラーです"
        case .network: return "ネットワークエラーが発生しました"
        default: return "エラーが発生しました"
        }
    }
}

class APIDriver {
    enum Endpoint {
        case login
        case refreshToken

        // 部門関連
        case getCategoryList
        case addCategory

        // 商品関連
        case getProductList
        case addProduct
        case editProductPrice

        // スタッフ関連
        case getStaffList
        case addStaff
        case getStaffInfo(id: Int)

        // ストア関連
        case getStoreList
        case addStore

        // 商品関連
        case getProductDivisionList
        case addProductDivision

        // 患者関連
        case getPatientList
        case addPatient

        // 患者分類関連
        case getPatientClassList
        case addPatientClass

        // 入金区分関連
        case getPaymentDivision
        case addPaymentDivision

        // 清算印刷設定関連
        case getSettlementPrintSettingList
        case addSettlementPrintSetting

        // 取引タグ関連
        case getTransactionTag
        case addTransactionTag

        // 出金区分関連
        case getWithdrawalDivisionList
        case addWithdrawalDivision

        func toPath() -> String {
            switch self {
            // ログイン関係
            case .login: return "/api/v1/Login"
            case .refreshToken: return "/api/v1/Token/refresh"

            // 部門関連
            case .getCategoryList: return "/api/v1/Category"
            case .addCategory: return "/api/v1/Category"

            // 商品関連
            case .getProductList: return "/api/v1/Product"
            case .addProduct: return "/api/v1/Product"
            case .editProductPrice: return "/api/v1/Product/price"

            // スタッフ関連
            case .getStaffList: return "/api/v1/Staff"
            case .addStaff: return "/api/v1/Staff"
            case let .getStaffInfo(id): return "/api/v1/Staff/\(id)"

            case .getStoreList: return "/api/v1/Store"
            case .addStore: return "/api/v1/Store"

            case .getProductDivisionList: return "/api/v1/ProductDivision"
            case .addProductDivision: return "/api/v1/ProductDivision"

            case .getPatientList: return "/api/v1/Patient"
            case .addPatient: return "/api/v1/Patient"

            case .getPatientClassList: return "/api/v1/PatientClass"
            case .addPatientClass: return "/api/v1/PatientClass"

            case .getPaymentDivision: return "/api/v1/PaymentDivision"
            case .addPaymentDivision: return "/api/v1/PaymentDivision"

            case .getSettlementPrintSettingList: return "/api/v1/SettlementPrintSetting"
            case .addSettlementPrintSetting: return "/api/v1/SettlementPrintSetting"

            case .getTransactionTag: return "/api/v1/TransactionTag"
            case .addTransactionTag: return "/api/v1/TransactionTag"

            case .getWithdrawalDivisionList: return "/api/v1/WithdrawalDivision"
            case .addWithdrawalDivision: return "/api/v1/WithdrawalDivision"
            }
        }

        func toMethod() -> HTTPMethod {
            switch self {
            case .login: return .post
            case .refreshToken: return .post
            case .getCategoryList: return .get
            case .getProductList: return .get
            case .addProduct: return .post
            case .editProductPrice: return .put
            case .addCategory: return .post
            case .getStaffInfo: return .get
            case .getStoreList: return .get
            case .addStore: return .post
            case .getPatientClassList: return .get
            case .addPatientClass: return .post
            case .getProductDivisionList: return .get
            case .addProductDivision: return .post
            case .getStaffList: return .get
            case .addStaff: return .post
            case .getPatientList: return .get
            case .addPatient: return .post
            case .getPaymentDivision: return .get
            case .addPaymentDivision: return .post
            case .getSettlementPrintSettingList: return .get
            case .addSettlementPrintSetting: return .post
            case .getTransactionTag: return .get
            case .addTransactionTag: return .post
            case .getWithdrawalDivisionList: return .get
            case .addWithdrawalDivision: return .post
            }
        }

        func isRequireAccessToken() -> Bool {
            switch self {
            case .login, .refreshToken:
                return false
            default:
                return true
            }
        }

        func isResetAuthenticationInterceptor() -> Bool {
            switch self {
            case .login, .refreshToken:
                return true
            default:
                return false
            }
        }
    }

    #if DEBUG
        var host: String = "http://49.212.197.177:8090"
    #else
        var host: String = ""
    #endif

    var authenticationInterceptor: AuthenticationInterceptor<OAuthAuthenticator>?
    var lastEndPoint: Endpoint?

    static var shared = APIDriver()

    private init() {
        resetAuthenticationInterceptor()
    }

    func request(endpoint: Endpoint, data: [String: Any], callback: @escaping (APIDriverResult?, Error?) -> Void) {
        guard let url = URL(string: host + endpoint.toPath()) else {
            callback(nil, APIDriverError.logic("不正なURLです"))
            return
        }

        if lastEndPoint?.isResetAuthenticationInterceptor() == true {
            resetAuthenticationInterceptor()
        }
        lastEndPoint = endpoint

        let httpMethod = endpoint.toMethod()
        let interceptor = endpoint.isRequireAccessToken() ? authenticationInterceptor : nil
        var headers = HTTPHeaders()
        debugPrint("🌸http request : \(httpMethod) -> \(url)")
        switch httpMethod {
        case .post, .put:
            headers.add(.contentType("application/json"))
            AF.request(url, method: httpMethod, parameters: data, encoding: JSONEncoding.default, headers: headers, interceptor: interceptor).validateUnauthorized()
                .responseString { response in
                    self.output(response: response, onCompleted: callback)
                }
        case .delete:
            headers.add(.contentType("application/x-www-form-urlencoded"))
            AF.request(url, method: httpMethod, parameters: data, headers: headers, interceptor: interceptor).validateUnauthorized()
                .responseString { response in
                    self.output(response: response, onCompleted: callback)
                }
        case .get:
            let params = data
            AF.request(url, method: .get, parameters: params, interceptor: interceptor).validateUnauthorized()
                .responseString { response in
                    self.output(response: response, onCompleted: callback)
                }
        default:
            break
        }
    }

    private func output(response: AFDataResponse<String>, onCompleted: @escaping (APIDriverResult?, Error?) -> Void) {
        debugPrint("response : \(response)")
        debugPrint("statusCode : \(String(describing: response.response?.statusCode))")
        debugPrint("headers : : \(String(describing: response.response?.headers))")

        guard let jsonString = response.value,
            let jsonData = response.data,
            let statusCode = response.response?.statusCode
        else {
            switch response.result {
            case let .failure(.requestAdaptationFailed(error)):
                if case .invalidRefreshToken = error as? APIDriverError {
                    NotificationCenter.default.post(name: .noToken, object: self, userInfo: nil)
                } else {
                    onCompleted(nil, error)
                }
            default:
                onCompleted(nil, APIDriverError.network)
            }
            return
        }

        // Response Header
        var headers: [String: String] = [:]
        if let responseHeaders = response.response?.headers {
            for header in responseHeaders {
                headers[header.name] = header.value
            }
        }

        // String to JSON
        do {
            let json = try JSONSerialization.jsonObject(with: jsonData, options: .allowFragments)
            let result = APIDriverResult(responseData: jsonData, responseSting: jsonString, responseObj: json, responseHeader: headers, statusCode: statusCode)

            if json is [String: Any] || json is [Any] {
                if statusCode == 404 {
                    onCompleted(nil, APIDriverError.notFound)
                } else {
                    onCompleted(result, nil)
                }
            } else {
                onCompleted(result, APIDriverError.unknown)
            }
        } catch {
            onCompleted(nil, error)
        }
    }

    func resetAuthenticationInterceptor() {
        guard let credential = AuthManager.shared.loadToken() else {
            return
        }

        authenticationInterceptor = AuthenticationInterceptor(
            authenticator: OAuthAuthenticator(),
            credential: credential
        )
    }

    func cancelAllRequests() {
        Alamofire.Session.default.cancelAllRequests()
    }
}
