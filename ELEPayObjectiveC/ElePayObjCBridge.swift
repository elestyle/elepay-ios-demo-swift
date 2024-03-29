//
//  ElePayObjCBridge.swift
//  ElePayObjCBridge
//
//  Created by xuzhe on 2019/01/15.
//  Copyright © 2018 elestyle.jp. All rights reserved.
//

import ElepaySDK

@objc
final public class ElePayObjCBridge: NSObject {
    @objc
    public static func initElePay(publicKey: String) {
        Elepay.initApp(key: publicKey)
    }

    @objc
    public static func handleOpenURL(_ url: URL) -> Bool {
        return Elepay.handleOpenURL(url)
    }

    @objc
    @discardableResult
    public static func handlePaymentEvent(payload: String, senderViewController sender: UIViewController) -> Bool {
        return Elepay.handlePayment(chargeJSON: payload, viewController: sender) { (paymentResult) in
            switch (paymentResult) {
            case let .succeeded(paymentId):
                print("Payment ID: \(paymentId), Payment Succeed")
            case let .cancelled(paymentId):
                print("Payment ID: \(paymentId), Canceled by user")
            case let .failed(paymentId, error):
                switch (error) {
                case let .alreadyMakingPayment(paymentId):
                    print("Already making payment: \(paymentId)")
                default:
                    print("Payment ID: \(paymentId ?? ""), Make Payment Failed \(String(describing: error.errorDescription))")
                }
            @unknown default:
                // handle newly added case here
                fatalError()
            }
        }
    }
}
