//
//  ProductsView.swift
//  elepay-ios-demo-swift
//
//  Created by Hailv on 2024/06/12.
//

import SwiftUI

struct ProductsView: View {
  private enum Destination: Hashable {
    case payment
  }

  @State
  private var navigationPath = NavigationPath()

  @StateObject
  private var configs: Configs = .default

  @StateObject
  private var selected: ProductsSelected = .init()

  private func productAction(_ product: Product) -> (icon: String, foreColor: UIColor, bgColor: UIColor) {
    let isSelected = selected.contains(product)
    let icon = isSelected ? "minus.circle" : "plus.circle"
    let foreColor = isSelected ? UIColor.systemPink : UIColor.systemBlue
    let bgColor = isSelected ? UIColor.systemBlue : UIColor.quaternarySystemFill
    return (icon, foreColor, bgColor)
  }

  var body: some View {
    ScrollView {
      LazyVGrid(columns: [GridItem(.adaptive(minimum: 150))], spacing: 20) {
        ForEach(Products.lists, id: \.self) { product in
          GeometryReader { proxy in
            VStack(spacing: 0) {
              ZStack {
                Text(product.emoji)
                  .font(.system(size: 100))
                  .frame(width: proxy.size.width, height: proxy.size.width)
                  .background(Color(UIColor.secondarySystemBackground))
                  .cornerRadius(20)
                VStack {
                  Spacer()
                  Text(product.name).bold().padding(10)
                }
              }

              HStack {
                Spacer()

                Text(configs.finance.display([product.price]))

                Spacer()

                Button {
                  selected.contains(product) ? selected.remove(product) : selected.append(product)
                } label: {
                  Image(systemName: productAction(product).icon)
                    .resizable()
                    .frame(width: 25, height: 25)
                    .foregroundColor(Color(productAction(product).foreColor))
                }
                Spacer()
              }
              .frame(width: proxy.size.width, height: 0.2 * proxy.size.width)
              .background(Color(productAction(product).bgColor))
              .cornerRadius(10)
            }
          }
          .aspectRatio(1 / 1.2, contentMode: .fill)
        }
      }
      .padding(.all)
    }
    .toolbar {
      ToolbarItem(placement: .topBarTrailing) {
        NavigationStack(path: $navigationPath) {
          Button("Buy") {
            guard !Configs.default.pubKey.isEmpty, !Configs.default.secKey.isEmpty else {
              Alert(title: "ERROR", msg: "Go to setting to set keys.").send()
              return
            }
            guard !selected.isEmpty() else {
              Alert(title: "ERROR", msg: "Select the product first.").send()
              return
            }
            navigationPath.append(Destination.payment)
          }
          .navigationDestination(for: Destination.self, destination: { destination in
            switch destination {
            case .payment:
              PaymentView(selected: selected).toolbar(.hidden, for: .tabBar)
            }
          })
        }
      }
    }
  }
}

#Preview {
  TabView {
    NavigationStack {
      ProductsView().navigationTitle("Products")
    }
    .tabItem {
      Label("Products", systemImage: "dollarsign.circle")
    }
  }
}
