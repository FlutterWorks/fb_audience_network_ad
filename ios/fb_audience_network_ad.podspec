#
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#
Pod::Spec.new do |s|
  s.name             = 'fb_audience_network_ad'
  s.version          = '0.0.1'
  s.summary          = 'facebook audience network.'
  s.description      = <<-DESC
facebook audience network.
                       DESC
  s.homepage         = 'http://example.com'
  s.license          = { :file => '../LICENSE' }
  s.author           = { 'Your Company' => 'email@example.com' }
  s.source           = { :path => '.' }
  s.source_files = 'Classes/**/*'
  s.public_header_files = 'Classes/**/*.h'
  s.dependency 'Flutter'

  s.dependency 'FBSDKCoreKit'
  s.dependency 'FacebookSDK'
  s.dependency 'FBAudienceNetwork'

  s.static_framework = true
  s.ios.deployment_target = '9.0'
end

