#
# Be sure to run `pod lib lint EasyAdMobBanner.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'EasyAdMobBanner'
  s.version          = '1.0.2'
  s.swift_versions   = '5.4'
  s.summary          = 'A SwiftUI wrapper for Google Ad Banner'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = 'EasyAdMobBanner is a SwiftUI wrapper for Google AdMob banner. It simply make the banner adjust its frame by adSize automatically.'

  s.homepage         = 'https://github.com/chenhaiteng/EasyAdMobBanner'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = 'Chen-Hai Teng'
  s.source           = { :git => 'https://github.com/chenhaiteng/EasyAdMobBanner.git', :tag => s.version.to_s }

  s.ios.deployment_target = '13.0'

  s.source_files = 'Sources/EasyAdMobBanner/**/*'
  
  # s.resource_bundles = {
  #   'EasyAdMobBanner' => ['EasyAdMobBanner/Assets/*.png']
  # }

  # s.public_header_files = 'Pod/Classes/**/*.h'
  # s.frameworks = 'UIKit', 'MapKit'
  s.static_framework = true
  s.dependency 'Google-Mobile-Ads-SDK', '~> 11.2.0'
end
