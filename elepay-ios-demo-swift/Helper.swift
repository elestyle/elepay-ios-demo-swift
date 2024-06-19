//
//  Helper.swift
//  elepay-ios-demo-swift
//
//  Created by Hailv on 2024/06/13.
//

import UIKit
import SwiftUI

extension String {
  static func generateRandomChar(length: Int = 20) -> String {
    let chars = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
    return String((0..<length).map { _ in chars.randomElement()! })
  }
}

struct ElepayUIPresenter: UIViewControllerRepresentable {
  @Binding
  var wrapped: UIViewController?

  func makeUIViewController(context: Context) -> UIViewController {
    let viewController = UIViewController()
    wrapped = viewController
    return viewController
  }

  func updateUIViewController(_ uiViewController: UIViewController, context: Context) {
  }
}
