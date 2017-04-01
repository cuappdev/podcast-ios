# Uncomment this line to define a global platform for your project
 platform :ios, '9.0'

target 'Podcast' do
  # Comment this line if you're not using Swift and don't want to use dynamic frameworks
  use_frameworks!
  
  pod 'Alamofire'
  pod 'SwiftyJSON'
  pod 'TPKeyboardAvoiding'
  pod 'Google/SignIn'
<<<<<<< HEAD
  pod 'UIScrollView-InfiniteScroll'
  pod 'Haneke'
  
=======
  pod 'UIScrollView-InfiniteScroll', '~> 1.0.0'
  pod 'NVActivityIndicatorView'  
>>>>>>> 05954df... completing series detail and subscriptions
end
  # Pods for Podcast

post_install do |installer|
    installer.pods_project.targets.each do |target|
        target.build_configurations.each do |config|
            config.build_settings['SWIFT_VERSION'] = '3.0'
        end
    end
end

