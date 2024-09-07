//
//  AppContainer.swift
//  Coredata-test1
//
//  Created by 城川一理 on 2024/09/06.
//

import Foundation

protocol Containable {
    init()
}

class AppContainer {
    static var shared: AppContainer = .init()

    var factories: [String: Any] = [:]

    private init() {}

    static func register<T>(_ type: T.Type, _ factory: @escaping () -> T) where T: Containable {
        let key = String(reflecting: type)
        shared.factories[key] = factory as Any
    }

    static func resolve<T>(_ type: T.Type) -> T where T: Containable {
        let key = String(reflecting: type)
        guard let factory = shared.factories[key] as? () -> T else {
            return T()
        }
        return factory()
    }
}
