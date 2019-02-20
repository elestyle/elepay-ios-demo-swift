//
//  ElePayObjCBridge.swift
//  ElePayObjCBridge
//
//  Created by xuzhe on 2019/01/15.
//  Copyright © 2018 elestyle.jp. All rights reserved.
//

import ElePay

@objc
final public class ElePayObjCBridge: NSObject {
    @objc
    public static func initElePay(publicKey: String) {
        ElePay.initApp(key: publicKey)
    }

    @objc
    public static func handleOpenURL(_ url: URL) -> Bool {
        return ElePay.handleOpenURL(url)
    }

    @objc
    @discardableResult
    public static func handlePaymentEvent(payload: String, senderViewController sender: UIViewController) -> Bool {
        return ElePay.handlePayment(chargeJSON: payload, viewController: sender) { (paymentResult) in
            switch (paymentResult) {
            case .succeeded(_):
                print("Payment Succeed")
            case .canceled(_):
                print("Canceled by user")
            case let .failed(_, error):
                switch (error) {
                case .alreadyMakingPayment(let paymentId):
                    print("Already making payment: \(paymentId)")
                default:
                    print("Make Payment Failed \(String(describing: error.errorDescription))")
                }
            }
        }
    }
}
