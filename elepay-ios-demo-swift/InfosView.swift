//
//  InfosView.swift
//  elepay-ios-demo-swift
//
//  Created by Hailv on 2024/06/14.
//

import SwiftUI

struct InfosView: View {
  @StateObject
  private var infos: Infos = .default

  @State
  private var payment: Payments = Configs.default.payment

  @State
  private var sources: [[String: Any]] = []

  @State
  private var wrapped: UIViewController? = nil

  var body: some View {
    Form {
      Section("Infos") {
        Section("Name:") {
          TextField("Juice", text: $infos.name)
        }
        Section("Email:") {
          TextField("someone@mail", text: $infos.email)
        }
        Section("Phone:") {
          TextField("7010102020", text: $infos.phone)
        }
      }

      Section("Customer") {
        Text("customerId: \(infos.customerId.isEmpty ? "< need sync >" : infos.customerId)")
        Button("Sync") {
          guard !infos.name.isEmpty, !infos.email.isEmpty, !infos.phone.isEmpty else {
            Alert(title: "ERROR", msg: "Infos cannot be empty.").send()
            return
          }
          syncCustomer { customerId in
            if let customerId {
              infos.customerId = customerId
            }
          }
        }
      }

      Section("Source") {
        Text("sourceId: \(infos.sourceId.isEmpty ? "< need add or sync to selected >" : infos.sourceId)")

        List {
          ForEach(0..<sources.count, id: \.self) { index in
            VStack {
              generateSignalSourceView(for: sources[index])
            }
          }
        }

        HStack {
          Button("Sync") {
            guard !infos.customerId.isEmpty else {
              return
            }
            PayHandler.default.querySource(customerId: infos.customerId) { result in
              sources = result
              if result.isEmpty {
                Alert(title: "Tips", msg: "No source, please add one.").send()
              }
            }
          }
          .buttonStyle(.borderless)

          Spacer()

          Button("Add") {
            guard !infos.customerId.isEmpty else {
              return
            }
            PayHandler.default.createSource(customerId: infos.customerId, payment: payment, view: wrapped!) { sourceId in
              if let sourceId {
                infos.sourceId = sourceId
              }
            }
          }
          .buttonStyle(.bordered)

          Picker("", selection: $payment, content: {
            ForEach(Payments.allCases) { item in
              Text(item.rawValue)
            }
          }).pickerStyle(WheelPickerStyle()).frame(width: 150, height: 80)
          ElepayUIPresenter(wrapped: $wrapped).frame(width: 0, height: 0)
        }
      }
    }
    .navigationTitle("Infos")
  }

  @ViewBuilder
  private func generateSignalSourceView(for item: [String: Any]) -> some View {
    VStack(alignment: .leading) {
      Text("sourceid: \(item["id"] ?? "error")")
      Text("payment: \(item["paymentMethod"] ?? "error")")
      Text("status: \(item["status"] ?? "error")")
      Text("resource: \(item["resource"] ?? "error")")
    }
    .onTapGesture {
      if let sourceId = item["id"] as? String {
        Infos.default.sourceId = sourceId
      }
    }
  }
}

extension InfosView {
  func syncCustomer(_ completion: @escaping (_ customerId: String?) -> Void) {
    PayHandler.default.queryCustomer { customers in
      let customer = customers.first { $0["email"] as? String == Infos.default.email }
      if let customer, let customerId = customer["id"] as? String {
        PayHandler.default.updateCustomer(customerId: customerId) { _customerId in
          completion(_customerId)
          Alert(title: "Tips", msg: _customerId != nil ? "Sync Success." : "Sync Failed.").send()
        }
      } else {
        PayHandler.default.createCustomer { _customerId in
          completion(_customerId)
          Alert(title: "Tips", msg: _customerId != nil ? "Sync Success." : "Sync Failed.").send()
        }
      }
    }
  }
}

#Preview {
  InfosView()
}
