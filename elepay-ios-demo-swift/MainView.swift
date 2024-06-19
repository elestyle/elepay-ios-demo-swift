//
//  MainView.swift
//  elepay-ios-demo-swift
//
//  Created by Hailv on 2024/06/11.
//

import SwiftUI
import Combine

struct Main: View {
  @State
  private var selectedTab = 0

  @State
  private var showAlert = false
  @State
  var alert: Alert?

  var body: some View {
    TabView(selection: $selectedTab) {
      NavigationStack {
        ProductsView().navigationTitle("Products")
      }
      .tabItem {
        Label("Products", systemImage: "dollarsign.circle")
      }
      .tag(0)

      NavigationStack {
        SettingView().navigationTitle("Setting")
      }
      .tabItem {
        Label("Setting", systemImage: "gear.circle")
      }
      .tag(1)
    }
    .alert("Notification", isPresented: $showAlert, presenting: alert, actions: { _ in
      Button("OK") {
      }
    }, message: { alert in
      Text(alert.title + "\n" + alert.msg)
    })
    .onReceive(AlertPublisher) { msg in
      guard let msg else { // hide alert
        showAlert = false
        return
      }
      alert = msg
      showAlert = true
    }
  }
}

// MARK: Alert, Global Notification

class Alert {
  var title: String
  var msg: String

  init(title: String, msg: String) {
    self.title = title
    self.msg = msg
  }

  static func hide() {
    alerts.append(nil)
    Alert.cycle(immediately: true)
  }

  func send() {
    alerts.append(self)
    Alert.cycle(immediately: true)
  }

  static var isCycling: Bool = false
  static func cycle(immediately: Bool) {
    if alerts.isEmpty || Alert.isCycling {
      return
    }

    Alert.isCycling = true

    // current only one item, will alert immediately
    let second = immediately && alerts.count == 1 ? 0 : 1.0
    DispatchQueue.main.asyncAfter(deadline: .now() + second) {
      AlertPublisher.send(alerts.removeFirst())
      Alert.isCycling = false
      self.cycle(immediately: false)
    }
  }
}

private var AlertPublisher = PassthroughSubject<Alert?, Never>()
private var alerts: [Alert?] = []

#Preview {
  Main()
}
