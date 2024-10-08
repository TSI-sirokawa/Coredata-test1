//
//  Setup.swift
//  Coredata-test1
//
//  Created by 城川一理 on 2024/09/08.
//

import Foundation

final class Setup {
    static func setUpUseCase() {
        AppContainer.register(LoginUseCase.self) {
            LoginUseCase(repository: AppContainer.resolve(APIRepository.self))
        }
        AppContainer.register(ProductListUseCase.self) {
            ProductListUseCase(repository: AppContainer.resolve(APIRepository.self))
        }
//TransactionListの為に追加
        AppContainer.register(TransactionListUseCase.self) {
            TransactionListUseCase(repository: AppContainer.resolve(APIRepository.self))
        }
    }

    static func setUpClasses() {
        AppContainer.register(APIRepository.self) {
            let driver = APIDriver.shared
            let repository = APIRepository()
            repository.driver = driver
            return repository
        }
    }
}
