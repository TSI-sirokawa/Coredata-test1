//
//  LoginUseCase.swift
//  Coredata-test1
//
//  Created by 城川一理 on 2024/09/05.
//

import Foundation

protocol LoginUseCaseProtocol: Containable {
    func login(form: LoginForm) async -> LoginResult?
}

final class LoginUseCase: LoginUseCaseProtocol {
    
    let repository: APIRepository

    required init() {
        fatalError()
    }

    init(repository: APIRepository) {
        self.repository = repository
    }

    func login(form: LoginForm) async -> LoginResult? {
        if let result = try? await repository.request(endpoint: .login, encodable: form),
            let loginResult = try? JSONDecoder.default.decode(LoginResult.self, from: result.responseData)
        {
            if let authData = loginResult.auth {
                AuthManager.shared.saveToken(
                    OAuthCredential(
                        accessToken: authData.accessToken,
                        refreshToken: authData.refreshToken,
                        expiration: authData.expiration
                    )
                )
            }
            if let staffId = loginResult.user?.staffId ?? loginResult.user?.id {
                PermanentDataManager.save(type: .myStaffId, data: staffId)
            }
            return loginResult
        } else {
            return nil
        }
    }
}
