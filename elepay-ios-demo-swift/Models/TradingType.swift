//
//  TradingType.swift
//  elepay-ios-demo-swift
//
//  Created by Hailv on 2024/06/13.
//

import Foundation

enum TradingType: String, CaseIterable, Identifiable {
  var id: Self { self }

  case Charge
  case Source
  case Checkout
}
