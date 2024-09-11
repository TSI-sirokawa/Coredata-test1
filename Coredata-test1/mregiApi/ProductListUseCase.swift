//
//  ProductListUseCase.swift
//  mReji
//
//  Created by 鈴木仁 on 2024/03/06.
//

import Foundation

protocol ProductListUseCaseProtocol: Containable {
    func fetch(form: ProductListForm) async -> ProductListResult?
}

final class ProductListUseCase: ProductListUseCaseProtocol {

    let repository: APIRepository

    required init() {
        fatalError(String())
    }

    init(repository: APIRepository) {
        self.repository = repository
    }

    func fetch(form: ProductListForm) async -> ProductListResult? {
        if let result = try? await repository.request(endpoint: .getProductList, encodable: form),
            let productListResult = try? JSONDecoder.default.decode(ProductListResult.self, from: result.responseData)
        {
            return productListResult
        } else {
            return nil
        }
    }
}
