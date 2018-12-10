//
//  SettingsBundleHelper.swift
//  ELEPayExample
//
//  Created by xuzhe on 2018/07/29.
//  Copyright © 2018 ELESTYLE, Inc. All rights reserved.
//

import UIKit

class SettingsBundleHelper: NSObject {
    fileprivate struct SettingKeys {
        static let APIURL = "api_server_url_preference"
        static let testMode = "api_server_test_mode"
        static let chargeURL = "user_server_order_api"
        static let testModeKey = "test_mode_key"
        static let liveModeKey = "live_mode_key"
        static let urlScheme = "url_scheme"
    }
    
    fileprivate static func getDefaultSettingAny(key: String) -> Any? {
        #if IN_HOUSE
        let fileName = "PrivateSAASSettings_InHouse"
        #else
        let fileName = "PrivateSAASSettings"
        #endif
        guard let settingFilePath = Bundle.main.path(forResource: fileName, ofType: "plist", inDirectory:"SettingFiles"),
            let settings = NSDictionary(contentsOfFile: settingFilePath) as? [String: Any] else {
                return nil
        }
        return settings[key]
    }
    
    fileprivate static func getDefaultSettingString(key: String) -> String? {
        return self.getDefaultSettingAny(key: key) as? String
    }
    
    fileprivate static func getDefaultSettingBool(key: String) -> Bool {
        return self.getDefaultSettingAny(key: key) as? Bool ?? false
    }
    
    fileprivate static func getSettingAndSetDefaultString(key: String) -> String? {
        guard let setting = UserDefaults.standard.string(forKey: key),
            !setting.isEmpty else {
                let defaultSetting = getDefaultSettingString(key: key)
//                UserDefaults.standard.set(defaultSetting, forKey: key)
                return defaultSetting
        }
        return setting
    }
    
    static func getAPIURLSetting() -> String? {
        return getSettingAndSetDefaultString(key: SettingKeys.APIURL)
    }
    
    static func getChargeURLSetting() -> String? {
        return getSettingAndSetDefaultString(key: SettingKeys.chargeURL)
    }
    
    static func getTestModeKey() -> String? {
        return getSettingAndSetDefaultString(key: SettingKeys.testModeKey)
    }
    
    static func getLiveModeKey() -> String? {
        return getSettingAndSetDefaultString(key: SettingKeys.liveModeKey)
    }
    
    static func getTestModeSetting() -> Bool {
        return UserDefaults.standard.bool(forKey: SettingKeys.testMode)
    }
    
    static func getAppURLScheme() -> String? {
        return getDefaultSettingString(key: SettingKeys.urlScheme)
    }
}
