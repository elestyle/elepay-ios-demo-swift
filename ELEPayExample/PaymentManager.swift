//
//  PaymentManager.swift
//  ELEPayExample
//
//  Created by xuzhe on 2018/05/05.
//  Copyright © 2018 ELESTYLE, Inc. All rights reserved.
//

import ElePay
import UIKit
import PassKit

public enum PaymentChannel: String {
    case wechat = "wx"
    case alipay = "alipay"
    case creditcard = "creditcard"
    case unionpay = "unionpay"
    case applepay = "applepay"
    case applepaycn = "applepay_cn"
    case paypal = "paypal"
}

public class PaymentManager: NSObject {
    static func makeCharge(amount: String, channel: PaymentChannel, viewController: PaymentViewController) {
        /* NOTE:
         If you have a server, we recommand you to create charge on your server.
         If you don't have a server, and if you are using 3rd party Network Framework,
         it's also a good reason to use them instead of these codes below

         That's why we do not include these code below in our SDK.
         */

        guard let chargeURL = SettingsBundleHelper.getChargeURLSetting() else {
            fatalError("Charge URL not set")
        }
        var postRequest = URLRequest(url: URL(string: chargeURL)!)   // It's your response to make sure your URL string is safe to convert to URL
        let body: [String: Any] = ["paymentMethod": channel.rawValue, "amount": amount]
        let bodyData = try? JSONSerialization.data(withJSONObject: body, options: [])
        #if DEBUG
        if let charge = String(data: bodyData!, encoding: .utf8) {
            print("charge: " + charge)
        }
        #endif
        postRequest.httpBody = bodyData
        postRequest.httpMethod = "POST"
        postRequest.setValue("application/json; charset=utf-8", forHTTPHeaderField: "Content-Type")
        if SettingsBundleHelper.getTestModeSetting() {
            postRequest.setValue("false", forHTTPHeaderField: "live-mode")
        }

        let task = URLSession.shared.dataTask(with: postRequest) { (result, response, error) in
            DispatchQueue.main.async {
                guard let httpResponse = response as? HTTPURLResponse else {
                    viewController.hideLoadingIndicator()
                    return
                }

                if error != nil || httpResponse.statusCode != 200 || result == nil {
                    viewController.hideLoadingIndicator()

                    let alert = UIAlertController(title: "Error", message: "Make Payment Failed: \(error?.localizedDescription ?? String(httpResponse.statusCode))", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
                    viewController.present(alert, animated: true, completion: nil)
                    return;
                }

                #if DEBUG
                if let charge = String(data: result!, encoding: .utf8) {
                    print(charge)
                }
                #endif

                let success = ElePay.handlePayment(chargeData: result!, viewController: viewController) { paymentResult in
                    viewController.hideLoadingIndicator()

                    var alert: UIAlertController? = nil
                    switch (paymentResult) {
                    case .succeeded(_):
                        alert = UIAlertController(title: "Succeed", message: "Make Payment Succeed", preferredStyle: .alert)
                    case let .canceled(paymentId):
                        alert = UIAlertController(title: "Warning", message: "Payment Canceled \(paymentId)", preferredStyle: .alert)
                    case let .failed(_, error):
                        alert = UIAlertController(title: "Error", message: "Make Payment Failed \(String(describing: error.errorDescription))", preferredStyle: .alert)
                    }
                    alert!.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
                    viewController.present(alert!, animated: true, completion: nil)
                }
                print(success)
            }
        }
        task.resume()
    }
}
