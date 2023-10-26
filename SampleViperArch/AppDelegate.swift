//
//  AppDelegate.swift
//  SampleViperArch
//
//  Created by Shariq on 2023-10-25.
//

import UIKit
import IQKeyboardManagerSwift

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {

        IQKeyboardManager.shared.enable = true
        saveCreds()
        
        let notice = LoginRouter.createModule()
        let navigationController = UINavigationController()
        navigationController.viewControllers = [notice]

        window?.rootViewController = navigationController
        window?.makeKeyAndVisible()
        return true
    }

    func saveCreds() {
        let emailData = Data(from: "test@gmail.com")
        let passData = Data(from: "testtest")
        let emailStatus = KeyChain.save(key: "userEmail", data: emailData)
        let passStatus = KeyChain.save(key: "userPassword", data: passData)
        print("email: \(emailStatus), password: \(passStatus)")
    }

}

