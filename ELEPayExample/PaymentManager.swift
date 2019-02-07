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
    case wechat = "wechat"
    case alipay = "alipay"
    case creditcard = "creditcard"
    case unionpay = "unionpay"
    case applepay = "applepay"
    case applepaycn = "applepay_cn"
    case paypal = "paypal"
    case linepay = "linepay"
}

public class PaymentManager: NSObject {
    static func makeCharge(amount: String, channel: PaymentChannel, viewController: PaymentViewController) {
        /* NOTE:
         If you have a server, we recommand you to create charge on your server.
         If you don't have a server, and if you are using 3rd party Network Framework,
         it's also a good reason to use them instead of these codes below

         That's why we do not include these code below in our SDK.
         */

        // The Local Server Mode is only for testing your enviroment of iOS SDK.
        // NEVER use it in your production enviroment!
        // ↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓
        let useLocalServer = SettingsBundleHelper.getLocalServerSetting()
        // ↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑
        var apiServerURLStr = SettingsBundleHelper.getAPIURLSetting() ?? ""
        if apiServerURLStr.isEmpty {
            apiServerURLStr = "https://api.elepay.io"
        }
        var chargeURL = apiServerURLStr + "/charges"
        let isTestMode = SettingsBundleHelper.getTestModeSetting()
        if !useLocalServer {
            guard let userServerURL = SettingsBundleHelper.getChargeURLSetting() else {
                fatalError("Charge URL not set")
            }
            chargeURL = userServerURL
        }
        var postRequest = URLRequest(url: URL(string: chargeURL)!)   // It's your response to make sure your URL string is safe to convert to URL
        var body: [String: Any] = ["paymentMethod": channel.rawValue, "amount": amount]
        if useLocalServer {
            // Directly create charge from your App.
            // WARNING! Do NOT use this way in production environment. Because secret key is required which you should NEVER keep in your App.
            body["orderNo"] = UUID.init().uuidString
            body["description"] = "Demo App directly charge"
        }
        let bodyData = try? JSONSerialization.data(withJSONObject: body, options: [])
        #if DEBUG
        if let charge = String(data: bodyData!, encoding: .utf8) {
            print("charge: " + charge)
        }
        #endif
        postRequest.httpBody = bodyData
        postRequest.httpMethod = "POST"
        postRequest.setValue("application/json; charset=utf-8", forHTTPHeaderField: "Content-Type")
        if useLocalServer {
            // WARNING AGAIN! Do NOT use this way in production environment.
            // Because secret key is required which you should NEVER keep in your App.
            let userPasswordData = "\(isTestMode ? SettingsBundleHelper.getTestSecretKey()! : SettingsBundleHelper.getLiveSecretKey()!):".data(using: .utf8)
            let base64EncodedCredential = userPasswordData?.base64EncodedString()
            let authString = "Basic \(base64EncodedCredential ?? "")"
            postRequest.setValue(authString, forHTTPHeaderField: "Authorization")
        } else {
            if isTestMode {
                // Tell your server to use Test Key for making charge. You can use your own way to do so.
                postRequest.setValue("false", forHTTPHeaderField: "live-mode")
            }
        }

        let task = URLSession.shared.dataTask(with: postRequest) { (result, response, error) in
            DispatchQueue.main.async {
                defer {
                    viewController.hideLoadingIndicator()
                }
                
                guard let httpResponse = response as? HTTPURLResponse else { return }

                if error != nil || httpResponse.statusCode != 200 || result == nil {
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
