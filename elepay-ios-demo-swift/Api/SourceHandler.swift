//
//  SourceHandler.swift
//  elepay-ios-demo-swift
//
//  Created by Hailv on 2024/06/14.
//

import Foundation
import ElepaySDK
import UIKit

// MARK: Customer

extension PayHandler {
  func queryCustomer(_ completion: @escaping ([[String: Any]]) -> Void) {
    net.session.requestJSON(url: Configs.customers, method: .GET) { res in
      switch res {
      case let .success(result):
        completion(result["customers"] as? [[String: Any]] ?? [])
      case let .failure(error):
        _ = error
        completion([])
      }
    }
  }

  func createCustomer(_ completion: @escaping (_ customerId: String?) -> Void) {
    let params = [
      "name": Infos.default.name,
      "email": Infos.default.email,
      "phone": Infos.default.phone,
    ]
    net.session.requestJSON(url: Configs.customers, params: params) { res in
      switch res {
      case let .success(result):
        completion(result["id"] as? String)
      case .failure:
        completion(nil)
      }
    }
  }

  func updateCustomer(customerId: String, completion: @escaping (_ customerId: String?) -> Void) {
    let params = [
      "name": Infos.default.name,
      "email": Infos.default.email,
      "phone": Infos.default.phone,
    ]
    net.session.requestJSON(url: Configs.customers + "/" + customerId, params: params) { res in
      switch res {
      case let .success(result):
        completion(result["id"] as? String)
      case .failure:
        completion(nil)
      }
    }
  }
}

// MARK: Source

extension PayHandler {
  func querySource(customerId: String, completion: @escaping ([[String: Any]]) -> Void) {
    net.session.requestJSON(url: String(format: Configs.source, customerId), method: .GET) { res in
      switch res {
      case let .success(result):
        completion(result["sources"] as? [[String: Any]] ?? [])
      case let .failure(error):
        completion([])
        switch error {
        case let .code(_, msg):
          Alert(title: "ERROR", msg: msg).send()
        default:
          Alert(title: "ERROR", msg: "unknown").send()
        }
      }
    }
  }

  func createSource(customerId: String,
                    payment: Payments,
                    view: UIViewController,
                    completion: @escaping (_ sourceId: String?) -> Void) {
    let params = ["paymentMethod": payment.rawValue, "resource": "ios"]
    net.session.requestJSON(url: String(format: Configs.source, customerId), params: params) { res in
      switch res {
      case let .success(result):

        guard let sourceId = result["id"] as? String else {
          completion(nil)
          Alert(title: "ERROR", msg: "unknown").send()
          return
        }

        let cardParams = Card.default.generalElepayCardParams()

        let success = Elepay.handleSource(source: result, cardParams: cardParams, viewController: view) { result in
          switch result {
          case .succeeded:
            completion(sourceId)
            Alert(title: "SUCCESS", msg: "Source Succeed.").send()
          case .cancelled:
            completion(nil)
            Alert(title: "WARNING", msg: "Source Canceled.").send()
          case let .failed(_, error):
            completion(nil)
            Alert(title: "ERROR", msg: "Source Failed  \(String(describing: error.errorDescription)).").send()
          @unknown default:
            completion(nil)
            Alert(title: "ERROR", msg: "unknown").send()
          }
        }
        print("handleSource:\(success)")
      case let .failure(error):
        completion(nil)
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
