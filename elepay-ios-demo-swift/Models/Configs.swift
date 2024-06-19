//
//  Configs.swift
//  elepay-ios-demo-swift
//
//  Created by Hailv on 2024/06/13.
//

import Foundation

class Configs: ObservableObject {
  static let `default` = Configs()
  private init() {
  }

  // MARK: const

  static let hostUrl = "https://api.elepay.io"
  static let chargeUrl = hostUrl + "/charges"
  static let customers = hostUrl + "/customers"
  static let source = customers + "/%@" + "/sources"
  static let checkout = hostUrl + "/codes"

  // MARK: published

  @Published
  var pubKey: String = KVMap.get(KV_KEY_pubKey) ?? "" {
    didSet {
      KVMap.set(pubKey, forKey: KV_KEY_pubKey)
    }
  }

  @Published
  var secKey: String = KVMap.get(KV_KEY_secKey) ?? "" {
    didSet {
      KVMap.set(secKey, forKey: KV_KEY_secKey)
    }
  }

  @Published
  var finance: FinanceType = .generalDefault(KVMap.get(KV_KEY_finance) ?? (Locale.current.currency?.identifier ?? "")) {
    didSet {
      KVMap.set(finance.name, forKey: KV_KEY_finance)
    }
  }

  @Published
  var payment: Payments = .init(rawValue: KVMap.get(KV_KEY_payment) ?? "") ?? .creditcard {
    didSet {
      KVMap.set(payment.rawValue, forKey: KV_KEY_payment)
    }
  }

  @Published
  var trading: TradingType = .init(rawValue: KVMap.get(KV_KEY_trading) ?? "") ?? .Charge {
    didSet {
      KVMap.set(trading.rawValue, forKey: KV_KEY_trading)
    }
  }
}
