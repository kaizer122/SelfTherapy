platform :ios, "12.1"
use_frameworks!
inhibit_all_warnings!

target 'SelfTherapy' do
  # Comment the next line if you're not using Swift and don't want to use dynamic frameworks
  use_frameworks!

  # Pods for SelfTherapy

pod 'Alamofire', '~> 4.3'
pod 'SwiftyJSON', '~> 4.2.0'
pod 'FBSDKCoreKit'
pod 'FBSDKLoginKit'
pod 'FBSDKShareKit'
pod 'GoogleSignIn'
pod 'UICircularProgressRing','~> 6.0.0'
pod 'lottie-ios','~> 2.5.2'
pod 'Charts','~> 3.2.2'
pod 'Firebase/Core'
pod 'Firebase/Auth'
pod 'Firebase/Firestore'
pod 'MessageKit'
pod 'Kingfisher'

     post_install do |installer|
        installer.pods_project.targets.each do |target|
            if target.name == 'FBSDKCoreKit' || target.name == 'FBSDKLoginKit'  || target.name == 'FBSDKShareKit'
                target.build_configurations.each do |config|
                    config.build_settings['CLANG_ALLOW_NON_MODULAR_INCLUDES_IN_FRAMEWORK_MODULES'] = 'NO'

                end
              inhibit_all_warnings!
            end
        end
end
end