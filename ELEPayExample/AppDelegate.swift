//
//  AppDelegate.swift
//  ELEPayExample
//
//  Created by xuzhe on 2018/05/05.
//  Copyright © 2018 ELESTYLE, Inc. All rights reserved.
//

import ElePay
import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        let APIURLSetting = SettingsBundleHelper.getAPIURLSetting()
        let testMode = SettingsBundleHelper.getTestModeSetting()
        let urlScheme = SettingsBundleHelper.getAppURLScheme()  // NOTE: You should also edit the info.plist file to add an URL Type for this scheme
        guard let key = testMode ? SettingsBundleHelper.getTestModeKey() : SettingsBundleHelper.getLiveModeKey(),
            !key.isEmpty else {
                fatalError("Test Mode Key not set")
        }
        ElePay.initApp(key: key, scheme: urlScheme!, apiURLString: APIURLSetting)
        
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }

    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
        // Let elepay Handle Result Callback from 3rd party payment Apps first.
        if (ElePay.handleOpenURL(url, options: options)) {
            // When ELEPay has already handled the URL, make sure your code returns here.
            return true;
        }

        // for no payment URL, handle it in your own code below.
        return false;
    }
}
