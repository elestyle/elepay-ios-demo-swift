# Uncomment the next line to define a global platform for your project
platform :ios, '11.0'
project 'ELEPayExample.xcodeproj'

target 'ELEPayExample' do
  # アプリのサイズを最適化するため、elepayはdynamic frameworks形式のみ対応しています
  use_frameworks!

  # Pods for ELEPayExample
  pod 'ElepaySDK', '~> 3.1.0'
  pod 'Elepay_ChinesePayments_Plugin', '~> 2.0.1'
  pod 'Stripe'
  pod 'Braintree'

  target 'ELEPayExampleTests' do
    inherit! :search_paths
    # Pods for testing
  end

  target 'ELEPayExampleUITests' do
    # Pods for testing
  end

end
