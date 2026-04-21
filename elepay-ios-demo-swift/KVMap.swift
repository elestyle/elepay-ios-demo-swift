//
//  KVMap.swift
//  elepay-ios-demo-swift
//
//  Created by Hailv on 2024/06/14.
//

import Foundation

let KV_KEY_pubKey = "pubKey"
let KV_KEY_secKey = "secKey"

let KV_KEY_cardNumber = "cardNumber"
let KV_KEY_cardExpYear = "cardExpYear"
let KV_KEY_cardExpMonth = "cardExpMonth"
let KV_KEY_cardCVC = "cardCVC"

let KV_KEY_trading = "trading"
let KV_KEY_payment = "payment"
let KV_KEY_finance = "finance"

let KV_KEY_infosName = "infosName"
let KV_KEY_infosEmail = "infosEmail"
let KV_KEY_infosPhone = "infosPhone"
let KV_KEY_infosCustomerId = "infosCustomerId"
let KV_KEY_infosSourceId = "infosSourceId"

class KVMap {
  static func set(_ value: String, forKey key: String) {
    UserDefaults.standard.set(value, forKey: key)
  }

  static func get(_ key: String) -> String? {
    let m = UserDefaults.standard.string(forKey: key)
    return m
  }

  static func setInteger(_ value: Int, forKey key: String) {
    UserDefaults.standard.set(value, forKey: key)
  }

  static func getInteger(_ key: String) -> Int {
    UserDefaults.standard.integer(forKey: key)
  }

  static func setBool(_ value: Bool, forKey key: String) {
    UserDefaults.standard.set(value, forKey: key)
  }

  static func getBool(_ key: String) -> Bool {
    UserDefaults.standard.bool(forKey: key)
  }
}

extension KVMap {
  static func remove(_ key: String) {
    UserDefaults.standard.removeObject(forKey: key)
  }
}
