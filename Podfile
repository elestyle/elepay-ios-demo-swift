# Uncomment the next line to define a global platform for your project
platform :ios, '10.0'
project 'ELEPayExample.xcodeproj'

target 'ELEPayExample' do
  # アプリのサイズを最適化するため、elepayはdynamic frameworks形式のみ対応しています
  use_frameworks!

  # Pods for ELEPayExample
  pod 'ElepaySDK'
  pod 'Elepay_ChinesePayments_Plugin'
  pod 'Stripe', :git => 'https://github.com/stripe/stripe-ios.git', :tag => 'v19.4.1'
  pod 'Braintree'

  target 'ELEPayExampleTests' do
    inherit! :search_paths
    # Pods for testing
  end

  target 'ELEPayExampleUITests' do
    # Pods for testing
  end

end
