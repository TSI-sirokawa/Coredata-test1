//
//  AuthManager.swift
//  Coredata-test1
//
//  Created by 城川一理 on 2024/09/06.
//

import Foundation

/// ログイン状態管理
final class AuthManager: Authorizable {
    static var shared: AuthManager = .init()

    let tokenKey = "auth"

    func saveToken(_ credential: any OAuthCredentialProtocol) {
        PermanentDataManager.saveObject(type: .authInfo, data: credential)
    }

    func loadToken() -> OAuthCredential? {
        return PermanentDataManager.loadObject(type: .authInfo, objectType: OAuthCredential.self)
    }

    func deleteToken() {
        PermanentDataManager.remove(type: .authInfo)
    }

    func isLoggedIn() -> Bool {
        return loadToken() != nil
    }

    func logout() {
        deleteToken()
        PermanentDataManager.remove(type: .myStaffId)
        PermanentDataManager.remove(type: .password)
        NotificationCenter.default.post(name: .noToken, object: self, userInfo: nil)
    }
}

protocol Authorizable: Containable {
    func saveToken(_ credential: any OAuthCredentialProtocol)
    func loadToken() -> OAuthCredential?
    func deleteToken()
}
