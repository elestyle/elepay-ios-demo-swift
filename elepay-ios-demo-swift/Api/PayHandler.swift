//
//  PayHandler.swift
//  elepay-ios-demo-swift
//
//  Created by Hailv on 2024/06/13.
//

class PayHandler {
  static let `default` = PayHandler()

  private init() {
    setup()
  }

  let net: (session: Network, interceptor: HeaderInterceptor) = {
    let interceptor = HeaderInterceptor()
    return (Network(interceptor: interceptor), interceptor)
  }()
}

/// Config net work
extension PayHandler {
  private func setup() {
    net.interceptor.token = Configs.default.secKey
  }
}
