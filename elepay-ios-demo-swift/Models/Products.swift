//
//  Products.swift
//  elepay-ios-demo-swift
//
//  Created by Hailv on 2024/06/12.
//

import Combine
import Foundation

struct Product: Hashable {
  let emoji: String
  let name: String
  let price: Float
  let img: String

  init(emoji: String, name: String, price: Float) {
    self.emoji = emoji
    self.name = name
    self.price = price
    img = "https://dummyimage.com/300x200/336ff0/fff.jpg&text=" + name.uppercased()
  }
}

class Products {
  static let lists: [Product] = [
    .init(emoji: "🧿", name: "ModaVest", price: 5),
    .init(emoji: "🧢", name: "LuxStyle", price: 10),
    .init(emoji: "🧤", name: "CapThread", price: 1),
    .init(emoji: "🩱", name: "VivaWear", price: 0.01),
    .init(emoji: "🩲", name: "SilkRoad", price: 6),
    .init(emoji: "🪡", name: "EchoFit", price: 3),
    .init(emoji: "🪢", name: "GlamCap", price: 20),
    .init(emoji: "🩴", name: "UrbTrend", price: 25),
    .init(emoji: "🧺", name: "NovaGear", price: 80),
    .init(emoji: "🎽", name: "ZenWard", price: 30),
    .init(emoji: "🧥", name: "CoolStride", price: 20),
    .init(emoji: "🧣", name: "SkyWoven", price: 5),
    .init(emoji: "🧦", name: "EliteWear", price: 55),
    .init(emoji: "🥼", name: "FlowCove", price: 60),
    .init(emoji: "🥽", name: "PureHabit", price: 20),
    .init(emoji: "🎒", name: "CrestVogue", price: 25),
  ]
}

class ProductsSelected: ObservableObject {
  @Published
  var products: [Product] = []
}

/// Convenient operations
extension ProductsSelected {
  func contains(_ product: Product) -> Bool {
    products.contains(product)
  }

  func append(_ product: Product) {
    products.append(product)
  }

  func remove(_ product: Product) {
    products.removeAll(where: { $0 == product })
  }

  func isEmpty() -> Bool {
    products.isEmpty
  }
}
