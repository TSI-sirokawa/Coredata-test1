//
//  AppDelegate.swift
//  Coredata-test1
//
//  Created by 城川一理 on 2024/09/08.
//

import UIKit

class AppDelegate: UIResponder, UIApplicationDelegate {
    func application(_: UIApplication, didFinishLaunchingWithOptions _: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        Setup.setUpUseCase()
        Setup.setUpClasses()
        return true
    }
}
