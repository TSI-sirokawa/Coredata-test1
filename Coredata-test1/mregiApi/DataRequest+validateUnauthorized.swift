//
//  DataRequest+validateUnauthorized.swift
//  Coredata-test1
//
//  Created by 城川一理 on 2024/09/06.
//

import Alamofire

extension DataRequest {
    func validateUnauthorized() -> Self {
        validate { _, response, _ -> Request.ValidationResult in
            if response.statusCode == 401 {
                let reason: AFError.ResponseValidationFailureReason = .unacceptableStatusCode(code: response.statusCode)
                return .failure(AFError.responseValidationFailed(reason: reason))
            } else {
                return .success(())
            }
        }
    }
}
