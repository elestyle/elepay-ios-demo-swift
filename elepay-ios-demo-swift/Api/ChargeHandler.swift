//
//  ChargeHandler.swift
//  elepay-ios-demo-swift
//
//  Created by Hailv on 2024/06/13.
//

import Foundation
import ElepaySDK
import UIKit

extension PayHandler {
  func handleCharge(amount: Int, view: UIViewController, source: Bool = false) {
    if source == true, Infos.default.noSource() {
      Alert(title: "ERROR", msg: "Go to setting to prepare Infos.").send()
      return
    }

    var params: [String: Any] = [
      "capture": true,
      "currency": Configs.default.finance.name,
      "paymentMethod": Configs.default.payment.rawValue,
      "amount": amount,
      "resource": "ios",
      "orderNo": String.generateRandomChar(),
      "description": "example",
    ]

    if source {
      params["customerId"] = Infos.default.customerId
      params["sourceId"] = Infos.default.sourceId
    }

    net.session.requestJSON(url: Configs.chargeUrl, params: params) { res in
      switch res {
      case let .success(result):
        let cardParams = Card.default.generalElepayCardParams()
        let success = Elepay.handlePayment(charge: result, cardParams: cardParams, viewController: view) { result in
          switch result {
          case .succeeded:
            Alert(title: "SUCCESS", msg: "Charge Succeed.").send()
          case .cancelled:
            Alert(title: "WARNING", msg: "Charge Canceled.").send()
          case let .failed(_, error):
            Alert(title: "ERROR", msg: "Charge Failed  \(String(describing: error.errorDescription)).").send()
          @unknown default:
            Alert(title: "ERROR", msg: "unknown").send()
          }
        }
        print("Charge result:\(success)")
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
