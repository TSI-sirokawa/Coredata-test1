//
//  TransactionListUseCase.swift
//  Coredata-test1
//
//  Created by 城川一理 on 2024/09/18.
//

import Foundation

protocol TransactionListUseCaseProtocol: Containable {
    func fetch(form: TransactionListForm) async -> TransactionListResult?
}

final class TransactionListUseCase: TransactionListUseCaseProtocol {

    let repository: APIRepository

    required init() {
        fatalError(String())
    }

    init(repository: APIRepository) {
        self.repository = repository
    }

    func fetch(form: TransactionListForm) async -> TransactionListResult? {
        if let result = try? await repository.request(endpoint: .getTransactionList, encodable: form),
            let transactionListResult = try? JSONDecoder.default.decode(TransactionListResult.self, from: result.responseData)
        {
            return transactionListResult
        } else {
            return nil
        }
    }
}
