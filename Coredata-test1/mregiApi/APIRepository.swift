//
//  APIRepository.swift
//  Coredata-test1
//
//  Created by 城川一理 on 2024/09/06.
//

import Foundation

class APIRepository: Containable {
    var driver: APIDriver?

    required init() {}

    func request<T: Encodable>(endpoint: APIDriver.Endpoint, encodable: T) async throws -> APIDriverResult {
        guard let input = try? JSONEncoder().encode(encodable),
            let data = try? JSONSerialization.jsonObject(with: input) as? [String: Any]
        else {
            throw APIDriverError.unknown
        }

        return try await request(endpoint: endpoint, data: data)
    }

    func request(endpoint: APIDriver.Endpoint, data: [String: Any] = [:]) async throws -> APIDriverResult {
        try await withCheckedThrowingContinuation { continuation in
            self.driver?
                .request(
                    endpoint: endpoint,
                    data: data,
                    callback: { result, error in
                        if let error = error {
                            continuation.resume(throwing: error)
                        } else if let result = result {
                            continuation.resume(returning: result)
                        }
                    }
                )
        }
    }

    func updateToken(form: RefreshForm, callback: @escaping (Result<OAuthCredential, Error>) -> Void) {
        driver?
            .request(endpoint: .refreshToken, data: ["accessToken": form.accessToken, "refreshToken": form.refreshToken]) { result, error in
                if let error {
                    if case .notFound = error as? APIDriverError {
                        callback(.failure(APIDriverError.invalidRefreshToken))
                    } else {
                        callback(.failure(error))
                    }
                } else if let result,
                    let refreshResult = try? JSONDecoder.token.decode(RefreshResult.self, from: result.responseData),
                    let authData = refreshResult.auth
                {
                    let oAuthCredential = OAuthCredential(
                        accessToken: authData.accessToken,
                        refreshToken: authData.refreshToken,
                        expiration: authData.expiration
                    )
                    AuthManager.shared.saveToken(oAuthCredential)
                    callback(.success(oAuthCredential))
                } else {
                    callback(.failure(APIDriverError.logic("アクセストークンの更新に失敗しました")))
                    AuthManager.shared.logout()
                }
            }
    }
}
