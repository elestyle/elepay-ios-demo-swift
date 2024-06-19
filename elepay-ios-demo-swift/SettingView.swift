//
//  SettingView.swift
//  elepay-ios-demo-swift
//
//  Created by Hailv on 2024/06/12.
//

import SwiftUI
import Combine

struct SettingView: View {
  var body: some View {
    Form {
      KeyView()
      TradeParamsView()
      CardView()
      InfosOverView()
    }
  }
}

#Preview(body: {
  TabView {
    NavigationStack {
      SettingView().navigationTitle("Setting")
    }
    .tabItem {
      Label("Setting", systemImage: "gear.circle")
    }
  }
})
