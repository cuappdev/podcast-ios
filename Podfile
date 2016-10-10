# Uncomment this line to define a global platform for your project
 platform :ios, '9.0'

target 'Podcast' do
  # Comment this line if you're not using Swift and don't want to use dynamic frameworks
  use_frameworks!
  
  pod 'Alamofire'
  pod 'SwiftyJSON', git: 'https://github.com/BaiduHiDeviOS/SwiftyJSON.git', branch: 'swift3'
  pod 'TPKeyboardAvoiding'

end
  # Pods for Podcast


  target 'PodcastTests' do
    inherit! :search_paths
    # Pods for testing
  end

  target 'PodcastUITests' do
    inherit! :search_paths
    # Pods for testing
  end

post_install do |installer|
    installer.pods_project.targets.each do |target|
        target.build_configurations.each do |config|
            config.build_settings['SWIFT_VERSION'] = '3.0'
        end
    end
end

