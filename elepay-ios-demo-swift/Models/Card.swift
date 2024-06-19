//
//  Card.swift
//  elepay-ios-demo-swift
//
//  Created by Hailv on 2024/06/13.
//

import Combine
import SwiftUI
import ElepaySDK

class Card: ObservableObject {
  static let `default` = Card.load()
  private init() {
  }

  @Published
  var number: String = "" {
    didSet {
      KVMap.set(number, forKey: KV_KEY_cardNumber)
    }
  }

  @Published
  var expYear: String = "" {
    didSet {
      KVMap.set(expYear, forKey: KV_KEY_cardExpYear)
    }
  }

  @Published
  var expMonth: String = "" {
    didSet {
      KVMap.set(expMonth, forKey: KV_KEY_cardExpMonth)
    }
  }

  @Published
  var cvc: String = "" {
    didSet {
      KVMap.set(cvc, forKey: KV_KEY_cardCVC)
    }
  }
}

extension Card {
  private static func load() -> Card {
    let card = Card()
    card.number = KVMap.get(KV_KEY_cardNumber) ?? ""
    card.expYear = KVMap.get(KV_KEY_cardExpYear) ?? ""
    card.expMonth = KVMap.get(KV_KEY_cardExpMonth) ?? ""
    card.cvc = KVMap.get(KV_KEY_cardCVC) ?? ""
    return card
  }
}

/// Convenient operations
extension Card {
  func isEmpty() -> Bool {
    number.isEmpty || expYear.isEmpty || expMonth.isEmpty || cvc.isEmpty
  }

  func generalElepayCardParams() -> ElepayCardParams? {
    guard !isEmpty(),
          let expYear = UInt(Card.default.expYear),
          let expMonth = UInt(Card.default.expMonth) else {
      return nil
    }

    let card = ElepayCardParams()
    card.number = Card.default.number.replacingOccurrences(of: " ", with: "")
    card.expYear = expYear
    card.expMonth = expMonth
    card.cvc = Card.default.cvc

    return card
  }
}
