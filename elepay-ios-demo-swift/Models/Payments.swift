//
//  Payments.swift
//  elepay-ios-demo-swift
//
//  Created by Hailv on 2024/06/13.
//

import Foundation

enum Payments: String, CaseIterable, Identifiable {
  var id: Self { self }

  case aeonpay // AEON Pay
  case alipay // アリペイ
  case alipayhk // アリペイHK
  case alipayplus // Alipay+
  case amazonpay // Amazon Pay
  case applepay // Apple Pay
  case applepay_cn // Apple Pay(中国)
  case atone // atone(コンビニで翌月払い)
  case aupay // au Pay
  case bpi // BPI
  case boost // Boost
  case creditcard // クレジットカード
  case dana // DANA
  case docomopay // d払い
  case ezlink // EZ-Link
  case felica // 電子マネー
  case felica_id // iD
  case felica_quickpay // QUICPay
  case felica_transport_ic // 交通系ICカード
  case gcash // GCash
  case ginkopay // 銀行Pay
  case googlepay // Google Pay
  case hellomoney // HelloMoney by AUB
  case jcoinpay // J-Coin Pay
  case jkopay // JKOPAY
  case kakaopay // Kakao Pay
  case linepay // LINE Pay
  case merpay // メルペイ
  case naverpay // Naver Pay
  case origamipay // Origami Pay
  case paidy // Paidy 翌月払い
  case paypal // PayPal
  case paypay // PayPay
  case rabbitlinepay // Rabbit LINE Pay
  case rakutenpay // 楽天ペイ
  case tng // Touch 'n Go eWallet
  case tosspay // Toss Pay
  case truemoney // TrueWorld
  case unionpay // 雲閃付
  case wechatpay // Wechat Pay
}
