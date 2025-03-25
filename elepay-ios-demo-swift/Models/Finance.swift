//
//  Finance.swift
//  elepay-ios-demo-swift
//
//  Created by Hailv on 2024/06/13.
//

import Foundation

enum FinanceType {
  case USD(name: String, symbol: String, rate: Float)
  case AUD(name: String, symbol: String, rate: Float)
  case BRL(name: String, symbol: String, rate: Float)
  case GBP(name: String, symbol: String, rate: Float)
  case CAD(name: String, symbol: String, rate: Float)
  case CNY(name: String, symbol: String, rate: Float)
  case EUR(name: String, symbol: String, rate: Float)
  case HKD(name: String, symbol: String, rate: Float)
  case INR(name: String, symbol: String, rate: Float)
  case JPY(name: String, symbol: String, rate: Float)
  case KRW(name: String, symbol: String, rate: Float)
  case PLN(name: String, symbol: String, rate: Float)
  case SEK(name: String, symbol: String, rate: Float)
  case CHF(name: String, symbol: String, rate: Float)

  static func general(_ name: String) -> FinanceType? {
    allCases.first { m in
      m.name == name
    }
  }

  static func generalDefault(_ name: String) -> FinanceType {
    let ret = general(name)
    if let ret {
      return ret
    } else {
      return allCases.first { m in
        m.name == "USD"
      }!
    }
  }
}

extension FinanceType: CaseIterable {
  static var allCases: [FinanceType] {
    [
      .USD(name: "USD", symbol: "$", rate: 1.0000),
      .AUD(name: "AUD", symbol: "A$", rate: 0.6902),
      .BRL(name: "BRL", symbol: "R$", rate: 0.2050),
      .GBP(name: "GBP", symbol: "£", rate: 1.2296),
      .CAD(name: "CAD", symbol: "C$", rate: 0.7374),
      .CNY(name: "CNY", symbol: "¥", rate: 0.1408),
      .EUR(name: "EUR", symbol: "€", rate: 1.0557),
      .HKD(name: "HKD", symbol: "HK$", rate: 0.1279),
      .INR(name: "INR", symbol: "₹", rate: 0.0122),
      .JPY(name: "JPY", symbol: "¥", rate: 0.0073),
      .KRW(name: "KRW", symbol: "₩", rate: 0.00077),
      .PLN(name: "PLI", symbol: "zł", rate: 0.2417),
      .SEK(name: "SEK", symbol: "kr", rate: 0.0953),
      .CHF(name: "CHF", symbol: "CHF", rate: 1.0697),
    ]
  }
}

extension FinanceType: Identifiable {
  var id: String {
    name
  }

  private var tuples: (name: String, symbol: String, rate: Float) {
    switch self {
    case let .USD(name, symbol, rate),
         let .AUD(name, symbol, rate),
         let .BRL(name, symbol, rate),
         let .GBP(name, symbol, rate),
         let .CAD(name, symbol, rate),
         let .CNY(name, symbol, rate),
         let .EUR(name, symbol, rate),
         let .HKD(name, symbol, rate),
         let .INR(name, symbol, rate),
         let .JPY(name, symbol, rate),
         let .KRW(name, symbol, rate),
         let .PLN(name, symbol, rate),
         let .SEK(name, symbol, rate),
         let .CHF(name, symbol, rate):
      return (name, symbol, rate)
    }
  }

  var name: String {
    tuples.name
  }

  var symbol: String {
    tuples.symbol
  }

  var rate: Float {
    tuples.rate
  }
}

extension FinanceType: Hashable {
  func hash(into hasher: inout Hasher) {
    hasher.combine(name)
  }
}

/// Convenient operations
extension FinanceType {
  /// return String as  `USD $30.13`
  func display(_ prices: [Float]) -> String {
    let allPrice = prices.reduce(0) { sum, price in
      sum + price / rate
    }
    return "\(name) \(symbol)\(Int(allPrice))"
  }

  /// return Int as  `30`
  func amount(_ prices: [Float]) -> Int {
    let allPrice = prices.reduce(0) { sum, price in
      sum + price / rate
    }

    return Int(allPrice)
  }
}
