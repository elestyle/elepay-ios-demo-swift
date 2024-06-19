//
//  Information.swift
//  elepay-ios-demo-swift
//
//  Created by Hailv on 2024/06/14.
//

import Combine
import SwiftUI

class Infos: ObservableObject {
  static let `default` = Infos.load()
  private init() {
  }

  @Published
  var name: String = "" {
    didSet {
      KVMap.set(name, forKey: KV_KEY_infosName)
    }
  }

  @Published
  var email: String = "" {
    didSet {
      KVMap.set(email, forKey: KV_KEY_infosEmail)
    }
  }

  @Published
  var phone: String = "" {
    didSet {
      KVMap.set(phone, forKey: KV_KEY_infosPhone)
    }
  }

  @Published
  var customerId: String = "" {
    didSet {
      KVMap.set(customerId, forKey: KV_KEY_infosCustomerId)
    }
  }

  @Published
  var sourceId: String = "" {
    didSet {
      KVMap.set(sourceId, forKey: KV_KEY_infosSourceId)
    }
  }
}

extension Infos {
  private static func load() -> Infos {
    let infos = Infos()
    infos.name = KVMap.get(KV_KEY_infosName) ?? ""
    infos.email = KVMap.get(KV_KEY_infosEmail) ?? ""
    infos.phone = KVMap.get(KV_KEY_infosPhone) ?? ""
    infos.customerId = KVMap.get(KV_KEY_infosCustomerId) ?? ""
    infos.sourceId = KVMap.get(KV_KEY_infosSourceId) ?? ""
    return infos
  }
}

/// Convenient operations
extension Infos {
  func noInfos() -> Bool {
    name.isEmpty || email.isEmpty || phone.isEmpty
  }

  func noSource() -> Bool {
    customerId.isEmpty || sourceId.isEmpty
  }
}
