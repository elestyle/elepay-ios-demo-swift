//
//  PaymentView.swift
//  elepay-ios-demo-swift
//
//  Created by Hailv on 2024/06/12.
//

import SwiftUI

struct PaymentView: View {
  @ObservedObject
  var selected: ProductsSelected

  var body: some View {
    Form {
      ShowSelectedProducts(selected: selected)
      GoToPay(selected: selected)
      TradeParamsView()
    }
    .navigationTitle("Buy")
  }
}

struct ShowSelectedProducts: View {
  @ObservedObject
  var selected: ProductsSelected

  @StateObject
  private var configs: Configs = .default

  var body: some View {
    VStack {
      ForEach(selected.products, id: \.self) { product in
        HStack {
          HStack {
            Text(product.emoji).font(.system(size: 50))
            Text(product.name)
          }
          Spacer()
          Text(configs.finance.display([product.price])).bold().opacity(0.3)
        }
        .frame(height: 30)
        .padding()

        Divider()
      }
      HStack {
        Spacer()
        Text("Total").bold()
        Spacer()

        Text(configs.finance.display(selected.products.map { $0.price })).bold().opacity(0.8)
      }
      .padding()
    }
  }
}

struct GoToPay: View {
  @ObservedObject
  var selected: ProductsSelected

  @StateObject
  private var configs: Configs = .default

  @State
  private var wrapped: UIViewController? = nil

  var body: some View {
    HStack {
      Spacer()
      Button {
        switch configs.trading {
        case .Charge:
          PayHandler.default.handleCharge(amount: configs.finance.amount(selected.products.map { $0.price }), view: wrapped!)
        case .Source:
          PayHandler.default.handleCharge(amount: configs.finance.amount(selected.products.map { $0.price }), view: wrapped!, source: true)
        case .Checkout:
          PayHandler.default.handleCheckout(
            amount: configs.finance.amount(selected.products.map { $0.price }),
            produts: selected.products,
            view: wrapped!
          )
        }
      } label: {
        Label("Go to Pay", systemImage: "arrow.forward")
      }
      ElepayUIPresenter(wrapped: $wrapped).frame(width: 0, height: 0)
    }
  }
}

#Preview(body: {
  var selected: ProductsSelected = .init()
  selected.append(.init(emoji: "🧿", name: "ModaVest", price: 5))
  selected.append(.init(emoji: "🧢", name: "LuxStyle", price: 10))
  selected.append(.init(emoji: "🧤", name: "CapThread", price: 1))

  return PaymentView(selected: selected)
})
