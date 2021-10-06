# ElepaySDK Demo App

## elepay-ios-sdk （日本語）

**elepay iOS SDK** は elepay を iOS アプリに導入するための SDK です。
具体的な導入ガイドは以下の URLでご確認ください。  
[→ elepay iOS SDK 導入ガイド](https://developer.elepay.io/docs/ios-sdk)

## Demo について

### 対応バージョン

* 開発環境：Xcode 11 以降
* CocoaPods 1.10.0 以降

### テストについて

1. `./Resources/SettingFiles/PrivateSAASSettings.plist` にある `test_mode_key`、`live_mode_key` は、必ず[「elepay 管理画面」](https://dashboard.elepay.io)→「開発設定」→「API」→「公開鍵」をご利用ください。
  **Live Key** は `pk_live_` から始まるキーです。**Test Key** は `pk_test_`から始まるキーです。
1. 上記の設定ファイルを編集しなくでも、iOS の「設定」にある「iCart Example」というアプリの設定項目に、「Live Key」、「Test Key」 を手入力することが出来ます。
1. `user_server_order_api` をお客様自身のサーバーの API Endpoint に変更してください。例えば：`https://demo.icart.jp/api/orders`。「iCart Example」の設定に、「Charge API」を入力しても同じ効果です。
1. お客様自身のサーバーが用意していない場合は、「Local Only Mode」を `ON` にして、[「elepay 管理画面」](https://dashboard.elepay.io)にある「秘密鍵」を「Live Secret Key」及び「Test Secret Key」に設定すれば、ローカルモードで SDK のテストが出来ます。

 > **ご注意：** 「ローカルモード」はサーバー不要で SDK を検証するための設定です。本番環境は必ずサーバーを経由して決済結果を認証してください。  
 また、本番環境の「秘密鍵」は必ずサーバーで保存してください。App に保存すると、セキュリティーリスクになるため、絶対しないでください。

## elepay-ios-sdk (English)

**elepay iOS SDK** is made for your iOS Apps to easily import elepay multi-payment platform. For more details, please access the link below.  
[→ Import Guide for elepay iOS SDK](https://developer.elepay.io/docs/ios-sdk)

## About ElepaySDK Demo App

### Version Informations

* Xcode 11 and above
* CocoaPods 1.10.0 and above

### How to test

1. Make sure your replace `test_mode_key` and `live_mode_key` in `./Resources/SettingFiles/PrivateSAASSettings.plist` with the key from ["elepay console"](https://dashboard.elepay.io) -> "Develop Settings" -> "API Key" -> "Public Key".
  **Live Key** is the key start with `pk_live_`, the **Test Key** is the key start with `pk_test_`.
1. If you do not want to use the `PrivateSAASSettings.plist`, you can also add "Live Key" and "Test Key" into iOS System's "Settings" -> "iCart Example".
1. Please also change the `user_server_order_api` to your own server. For example:`https://demo.icart.jp/api/orders`. Or you can edit "Charge API" in "iCart Example" settings, to get the same result.
1. If your own server is not ready for testing yet, you can turn `ON` "Local Only Mode" in "iCart Example" settings. Make sure you also input the "Live Secret Key" and "Test Secret Key" which you can get from ["elepay console"](https://dashboard.elepay.io).

> **WARNING:** "Local Only Mode" is **ONLY** for testing the SDK. You should always verify payment result on your server, and you should **NEVER** save "Secret Key" in your App for security reason.
