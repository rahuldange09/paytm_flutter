#
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html.
# Run `pod lib lint paytm_flutter.podspec' to validate before publishing.
#
Pod::Spec.new do |s|
  s.name             = 'paytm_flutter'
  s.version          = '0.0.1'
  s.summary          = 'A Flutter plugin for Paytm All-In-One SDK.'
  s.description      = <<-DESC
A new flutter plugin project.
                       DESC
  s.homepage         = 'https://github.com/rahuldange09'
  s.license          = { :file => '../LICENSE' }
  s.author           = { 'Rahul' => 'rahuldange09@gmail.com' }
  s.source           = { :path => '.' }
  s.source_files = 'Classes/**/*'
  s.dependency 'Flutter'
  s.platform = :ios, '9.0'

  s.preserve_paths = 'AppInvokeSDK.framework'
  s.xcconfig = { 'OTHER_LDFLAGS' => '-framework AppInvokeSDK' }
  s.vendored_frameworks = 'AppInvokeSDK.framework'
  
  s.static_framework = true

  # Flutter.framework does not contain a i386 slice. Only x86_64 simulators are supported.
  s.pod_target_xcconfig = { 'DEFINES_MODULE' => 'YES', 'VALID_ARCHS[sdk=iphonesimulator*]' => 'x86_64' }
  s.swift_version = '5.0'
end
