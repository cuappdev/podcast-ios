platform :ios, '9.0'
inhibit_all_warnings!

target 'Podcast' do
  use_frameworks!
  
  pod 'Alamofire'
  pod 'SwiftyJSON'
  pod 'GoogleSignIn'
  pod 'FacebookCore'
  pod 'FacebookLogin'
  pod 'FacebookShare'
  pod 'UIScrollView-InfiniteScroll'
  pod 'Kingfisher'
  pod 'NVActivityIndicatorView' 
  pod 'SwiftLint'
  pod 'SnapKit'
  pod 'MarqueeLabel/Swift'
  pod 'Fabric'
  pod 'Crashlytics'
  pod 'AcknowList'
  pod 'StepSlider'
end

post_install do |installer|
    installer.pods_project.targets.each do |target|
        target.build_configurations.each do |config|
            config.build_settings['SWIFT_VERSION'] = '4.0'
        end
    end
    require 'fileutils' # for acknowledgements
    FileUtils.cp_r('Pods/Target Support Files/Pods-Podcast/Pods-Podcast-acknowledgements.plist', 'Pods-acknowledgements.plist', :remove_destination => true)
end

