//
//  OAuthAuthenticator.swift
//  Coredata-test1
//
//  Created by 城川一理 on 2024/09/06.
//

import Alamofire
import Foundation

class OAuthAuthenticator: Authenticator {
    lazy var repository: APIRepository = AppContainer.resolve(APIRepository.self)

    func apply(_ credential: OAuthCredential, to urlRequest: inout URLRequest) {
        urlRequest.headers.add(.authorization(bearerToken: credential.accessToken))
    }

    func refresh(
        _ credential: OAuthCredential,
        for _: Session,
        completion: @escaping (Result<OAuthCredential, Error>) -> Void
    ) {
        repository.updateToken(form: RefreshForm(accessToken: credential.accessToken, refreshToken: credential.refreshToken)) { result in
            switch result {
            case let .success(newCredential):
                completion(.success(newCredential))
            case let .failure(error):
                completion(.failure(error))
            }
        }
    }

    func didRequest(
        _: URLRequest,
        with response: HTTPURLResponse,
        failDueToAuthenticationError _: Error
    ) -> Bool {
        #if DEBUG
            print("response.statusCode : \(response.statusCode)")
        #endif
        return response.statusCode == 401
    }

    func isRequest(_ urlRequest: URLRequest, authenticatedWith credential: OAuthCredential) -> Bool {
        let bearerToken = HTTPHeader.authorization(bearerToken: credential.accessToken).value
        return urlRequest.headers["Authorization"] == bearerToken
    }
}

struct OAuthCredential: OAuthCredentialProtocol {
    var accessToken: String
    var refreshToken: String
    var expiration: Date
}

protocol OAuthCredentialProtocol: AuthenticationCredential, Codable, Hashable {
    var accessToken: String { get set }
    var refreshToken: String { get set }
    var expiration: Date { get set }
}

extension OAuthCredentialProtocol {
    var requiresRefresh: Bool {
        print("now : \(Date()), expiration : \(expiration), requiresRefresh = \(Date() > expiration)")
        return Date() > expiration
    }

    var isRefreshTokenExpired: Bool {
        print("now : \(Date()), expiration : \(expiration), isRefreshTokenExpired = \(Date() > expiration)")
        return Date() > expiration
    }
}
