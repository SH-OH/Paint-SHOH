source 'https://github.com/CocoaPods/Specs.git'

platform :ios, '13.0'
use_frameworks!

def default_pods
  pod 'ReactorKit', '~> 3.0'
  pod 'Then'
  rx_pods
end

def rx_pods
  pod 'RxSwift', '~> 6.1.0'
  pod 'RxCocoa', '~> 6.1.0'
end

def ui_pods
  pod 'SnapKit'
end

target 'Paint-SHOH' do
    default_pods
    ui_pods
end

target 'Paint-SHOHTests' do
    inherit! :search_paths
    default_pods
end

target 'Paint-SHOHUITests' do

end

post_install do |installer|
  installer.pods_project.targets.each do |target|
    target.build_configurations.each do |config|
      config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'] = '13.0'
    end
  end
end