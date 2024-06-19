//
//  CheckoutHandler.swift
//  elepay-ios-demo-swift
//
//  Created by Hailv on 2024/06/17.
//

import Foundation
import ElepaySDK
import UIKit

extension PayHandler {
  func handleCheckout(amount: Int, produts: [Product], view: UIViewController) {
    let items = produts.map {
      [
        "name": $0.name,
        "image": $0.img,
        "price": Configs.default.finance.amount([$0.price]),
        "count": 1,
      ]
    }

    let params: [String: Any] = [
      "currency": Configs.default.finance.name,
      "amount": amount,
      "orderNo": String.generateRandomChar(),
      "description": "example",
      "items": items,
    ]

    net.session.requestJSON(url: Configs.checkout, params: params) { res in
      switch res {
      case let .success(result):
        Elepay.checkout(checkoutJSON: result, from: view) { result in
          switch result {
          case .succeeded:
            Alert(title: "SUCCESS", msg: "Checkout Succeed.").send()
          case .cancelled:
            Alert(title: "WARNING", msg: "Checkout Canceled.").send()
          case let .failed(_, error):
            Alert(title: "ERROR", msg: "Checkout Failed  \(String(describing: error.errorDescription)).").send()
          @unknown default:
            Alert(title: "ERROR", msg: "unknown").send()
          }
        }
      case let .failure(error):
        switch error {
        case let .code(_, msg):
          Alert(title: "ERROR", msg: msg).send()
        default:
          Alert(title: "ERROR", msg: "unknown").send()
        }
      }
    }
  }
}
