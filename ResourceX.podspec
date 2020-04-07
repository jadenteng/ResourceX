#
#  Be sure to run `pod spec lint ResourceX.podspec' to ensure this is a
#  valid spec and to remove all comments including this before submitting the spec.
#
#  To learn more about Podspec attributes see https://docs.cocoapods.org/specification.html
#  To see working Podspecs in the CocoaPods repo see https://github.com/CocoaPods/Specs/
#

Pod::Spec.new do |spec|

  spec.name         = "ResourceX"
  spec.version      = "1.1"
  spec.summary      = "ResourceX 通过AFNetworking YYModel 网络封装请求"
  spec.homepage     = "https://github.com/JadenTeng/ResourceX.git"
  spec.license      = "MIT"
  spec.license      = { :type => "MIT", :file => "LICENSE" }
  spec.author             = { "JadenTeng" => "781232284@qq.com" }
  spec.platform     = :ios, "9.0"
  spec.source       = { :git => "https://github.com/JadenTeng/ResourceX.git", :tag => "#{spec.version}" }
  s.requires_arc = true

end
