//
//  elepay_ios_demo_swiftApp.swift
//  elepay-ios-demo-swift
//
//  Created by Hailv on 2024/06/11.
//

import SwiftUI
import ElepaySDK

@main
struct elepay_ios_demo_swiftApp: App {
  init() {
    Elepay.initApp(key: Configs.default.pubKey)
  }

  var body: some Scene {
    WindowGroup {
      Main()
        .onOpenURL { url in
          _ = Elepay.handleOpenURL(url, options: [:])
        }
    }
  }
}
