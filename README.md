# elepay-ios-sdk
**elepay iOS SDK** は elepay を iOS アプリに導入するための SDK です。  
具体的な導入ガイドは以下の URLでご確認ください。  
[→ elepay iOS SDK 導入ガイド](https://docs.elepay.io/docs/ios-sdk)

# Example について
### 対応バージョン
* 開発環境：Xcode 10 以降
* CocoaPods 1.5.0 以降

### テストについて
1. `./Resources/SettingFiles/PrivateSAASSettings.plist` にある `test_mode_key`、`live_mode_key` を、必ず elepay 管理画面から作成したものをご利用ください。  
  Live Key は `pk_live_` から始まるキーですが、Test Key は `pk_test_`から始まる物です。
2. `user_server_order_api` をあなた自身の API に変更してください。デフォルトの URL は `https://demo.icart.jp/api/orders` です。
3. `PrivateSAASSettings.plist` ファイルを使わなくでも、直接 SDK の初期化関数に前述の key を渡しても出来ます。

# elepay-ios-sdk
**elepay iOS SDK** is made for your iOS Apps to easily import elepay multi-payment platform. For more details, please access the link below.  
[→ Import Guide for elepay iOS SDK](https://docs.elepay.io/docs/ios-sdk)

## About elepay Example
### Version Informations
* Xcode 10 and below
* CocoaPods 1.5.0　and below

### How to test
1. Make sure your replace `test_mode_key` and `live_mode_key` in `./Resources/SettingFiles/PrivateSAASSettings.plist` with the key from elepay console.
  Live Key is the key start with `pk_live_`, the Test Key is the key start with `pk_test_`.
2. Please also change the `user_server_order_api` to your own server. The default URL is `https://demo.icart.jp/api/orders`.
3. If you do not want to use the `PrivateSAASSettings.plist`, you can pass the keys directly to SDK initialization function.
