//
//  AppDelegate.swift
//  elepay-ios-demo-swift
//
//  Created by Hailv on 2025/08/22.
//

import UIKit
import SwiftUI
import ElepaySDK

class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        // 初始化 Elepay SDK
        Elepay.openDebugMode()
        Elepay.initApp(key: Configs.default.pubKey, apiURLString: Configs.hostUrl)
        
        Task {
            // Check if RPay is installed
            let m = Elepay.shared.paymentConfiguration.isRPayInstalled()
            print("Elepay rpay installed: \(m ? "Yes" : "No")")
        }

        print("Elepay SDK Version: \(Elepay.sdkVersion)")
        print("Elepay SDK Build Version: \(Elepay.sdkBuild)")
        
        // 创建窗口和根视图控制器
        window = UIWindow(frame: UIScreen.main.bounds)
        let contentView = Main()
        let hostingController = UIHostingController(rootView: contentView)
        window?.rootViewController = hostingController
        window?.makeKeyAndVisible()
        
        return true
    }
    
    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
        return Elepay.handleOpenURL(url, options: options)
    }
}
