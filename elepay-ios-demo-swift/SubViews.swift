//
//  SubViews.swift
//  elepay-ios-demo-swift
//
//  Created by Hailv on 2024/06/17.
//

import SwiftUI
import Combine

struct KeyView: View {
  @StateObject
  private var configs: Configs = .default

  var body: some View {
    Section(header: Text("Keys *")) {
      Section(header: Text("Public Key")) {
        TextField("pk_live_xxx", text: $configs.pubKey).bold()
      }
      Section(header: Text("Secret Key")) {
        TextField("sk_live_xxx", text: $configs.secKey).bold()
      }
      HStack {
        Spacer()
        Button("Reboot to apply") {
          exit(0)
        }.foregroundColor(Color(UIColor.systemBlue))
        Spacer()
      }
    }.foregroundStyle(Color.pink)
  }
}

struct TradeParamsView: View {
  @StateObject
  private var configs: Configs = .default

  var body: some View {
    Section(header: Text("Currency")) {
      Picker("Currency Selected", selection: $configs.finance, content: {
        ForEach(FinanceType.allCases, id: \.self) { item in
          Text(item.name)
        }
      })
    }

    Section(header: Text("Params")) {
      Picker("Trading Type", selection: $configs.trading, content: {
        ForEach(TradingType.allCases) { item in
          Text(item.rawValue)
        }
      })

      Picker("Payment Selected", selection: $configs.payment, content: {
        ForEach(Payments.allCases) { item in
          Text(item.rawValue)
        }
      })
    }
  }
}

struct CardView: View {
  @State
  private var useDefault = false

  @StateObject
  private var card: Card = .default

  @FocusState
  private var focusedField: Field?

  private enum Field {
    case number, mm, yy, cvc
  }

  var body: some View {
    Section(header: Text("Card")) {
      HStack {
        Image("card").resizable().scaledToFit().frame(height: 100)

        Spacer()

        Toggle("Use Default", isOn: $useDefault)
          .onChange(of: useDefault) { flag in
            card.number = flag ? "4242 4242 4242 4242" : ""
            card.expYear = flag ? "29" : ""
            card.expMonth = flag ? "09" : ""
            card.cvc = flag ? "123" : ""
          }
      }
      Section(header: Text("Card Number")) {
        TextField("4242 4242 4242 4242", text: $card.number)
          .bold()
          .keyboardType(.numberPad)
          .onChange(of: card.number) { newValue in
            let filtered = newValue.filter { $0.isNumber }
            if filtered.count <= 16 {
              card.number = filtered.enumerated().map { index, char -> String in
                return index % 4 == 0 && index > 0 ? " \(char)" : String(char)
              }.joined()
            }

            if filtered.count >= 16 {
              focusedField = .mm
            }
          }
      }

      Section(header: Text("Expiry Date")) {
        HStack {
          HStack {
            TextField("MM", text: $card.expMonth)
              .bold()
              .frame(width: 30)
              .focused($focusedField, equals: .mm)
              .keyboardType(.numberPad)
              .onChange(of: card.expMonth) { newValue in
                let filtered = newValue.filter { $0.isNumber }
                if filtered.count <= 2 {
                  card.expMonth = String(filtered)
                }
                if filtered.count >= 2 {
                  focusedField = .yy
                }
              }
            Text("/")
            TextField("YY", text: $card.expYear)
              .bold()
              .frame(width: 30)
              .focused($focusedField, equals: .yy)
              .keyboardType(.numberPad)
              .onChange(of: card.expYear) { newValue in
                let filtered = newValue.filter { $0.isNumber }
                if filtered.count <= 2 {
                  card.expYear = String(filtered)
                }
                if filtered.count >= 2 {
                  focusedField = .cvc
                }
              }
          }
          Spacer()
          TextField("CVC", text: $card.cvc)
            .bold()
            .focused($focusedField, equals: .cvc)
            .keyboardType(.numberPad)
            .onChange(of: card.cvc) { newValue in
              let filtered = newValue.filter { $0.isNumber }
              if filtered.count <= 3 {
                card.cvc = String(filtered)
              }
              if filtered.count >= 3 {
                focusedField = nil
              }
            }
          Spacer()
        }
      }
    }
    .onTapGesture {
      UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
  }
}

struct InfosOverView: View {
  private enum Destination: Hashable {
    case infosView
  }

  @StateObject
  private var infos: Infos = .default

  @State
  private var navigationPath = NavigationPath()

  var body: some View {
    Section(header: Text("Infos")) {
      VStack(alignment: .leading) {
        HStack {
          Text("name: ")
          Text(infos.name.isEmpty ? "unknown" : infos.name).bold()
        }
        Divider()
        HStack {
          Text("email: ")
          Text(infos.email.isEmpty ? "unknown" : infos.email).bold()
        }
        Divider()
        HStack {
          Text("phone: ")
          Text(infos.phone.isEmpty ? "unknown" : infos.phone).bold()
        }
        Divider()
        HStack {
          Text("customerId: ")
          Text(infos.customerId.isEmpty ? "unknown" : infos.customerId).bold().foregroundStyle(Color.pink)
        }
        Divider()
        HStack {
          Text("sourceId: ")
          Text(infos.sourceId.isEmpty ? "unknown" : infos.sourceId).bold().foregroundStyle(Color.pink)
        }
        Divider()
        HStack {
          Spacer()
          EmptyView()
          Spacer()
          NavigationStack(path: $navigationPath) {
            Button(infos.noSource() ? "Add" : "Update") {
              guard !Configs.default.pubKey.isEmpty, !Configs.default.secKey.isEmpty else {
                Alert(title: "ERROR", msg: "Go to setting to set keys.").send()
                return
              }
              navigationPath.append(Destination.infosView)
            }
            .navigationDestination(for: Destination.self, destination: { destination in
              switch destination {
              case .infosView:
                InfosView().toolbar(.hidden, for: .tabBar)
              }
            })
          }
          Spacer()
        }
      }.padding()
    }
  }
}
