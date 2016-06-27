platform :ios, '7.0'
use_frameworks!

target 'hacfun' do
pod 'SDWebImage'
pod 'AFNetworking'
pod 'ReactiveCocoa'
pod 'MBProgressHUD'
pod 'TOWebViewController'
pod 'FMDB'
pod 'CocoaAsyncSocket'
pod 'SSKeychain'
pod 'FLAnimatedImage'
pod 'DTCoreText'
pod 'TTTAttributedLabel'
end


post_install do |installer|
  installer.pods_project.targets.each do |target|
    target.build_configurations.each do |config|
      config.build_settings['ENABLE_BITCODE'] = 'NO'
    end
  end
end


