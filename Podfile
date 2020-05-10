use_frameworks!
inhibit_all_warnings!

target 'Anilibria' do
    #Network
    pod 'Kingfisher', '5.13.0'
    pod 'Alamofire', '4.8.2'

    #Utils
    pod 'DITranquillity', '3.9.3'
    pod 'RxSwift', '5.0.1'
    pod 'RxCocoa', :git => 'https://github.com/ReactiveX/RxSwift.git', :commit => '01f927a'
    pod 'Localize-Swift', '2.0.0'
    pod 'lottie-ios', '3.1.1'
    pod 'YandexMobileMetrica'
    pod 'FirebaseCore'
    pod 'Firebase/Messaging'
    pod 'Firebase/Crashlytics'

    #UI
    pod 'MXParallaxHeader'
    pod 'IGListKit', :git => 'https://github.com/Instagram/IGListKit.git', :commit => 'f50f3c7'
    
    post_install do |installer|
        installer.pods_project.targets.each do |target|
            target.build_configurations.each do |config|
                config.build_settings['SWIFT_VERSION'] = '5'
            end
        end
    end
end
