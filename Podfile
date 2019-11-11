# Uncomment the next line to define a global platform for your project
platform :ios, '9.1'
project 'ELEPayExample.xcodeproj'

target 'ELEPayExample' do
  # アプリのサイズを最適化するため、elepayはdynamic frameworks形式のみ対応しています
  use_frameworks!

  # Pods for ELEPayExample
  pod 'ElePay'
  pod 'ElePay-ChinesePayments-Plugin'

  target 'ELEPayExampleTests' do
    inherit! :search_paths
    # Pods for testing
  end

  target 'ELEPayExampleUITests' do
    # Pods for testing
  end

end
