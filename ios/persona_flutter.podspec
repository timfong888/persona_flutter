#
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html.
# Run `pod lib lint persona_flutter.podspec' to validate before publishing.
#
Pod::Spec.new do |s|
  s.name             = 'persona_flutter'
  s.version          = '0.0.1'
  s.summary          = 'Persona Inquiry SDK for Flutter'
  s.description      = <<-DESC
Integrate the Persona Inquiry flow directly into your app with native SDK.
                       DESC
  s.homepage         = 'http://github.com/jorgefspereira'
  s.license          = { :file => '../LICENSE' }
  s.author           = { 'Jorge Pereira' => 'jorgefspereira@icloud.com' }
  s.source           = { :path => '.' }
  s.source_files = 'Classes/**/*'
  s.public_header_files = 'Classes/**/*.h'
  s.dependency 'Flutter'
<<<<<<< HEAD
  s.dependency 'PersonaInquirySDK', '1.1.25'
=======
  s.dependency 'PersonaInquirySDK2', '2.2.6'
>>>>>>> 9f48fbd924ecdfa76d945677fb1a5f5d359c9b57
  s.static_framework = true
  s.platform = :ios, '11.0'
  # Flutter.framework does not contain a i386 slice. Only x86_64 simulators are supported.
  s.pod_target_xcconfig = { 'DEFINES_MODULE' => 'YES', 'VALID_ARCHS[sdk=iphonesimulator*]' => 'x86_64' }
  s.swift_version = '5.0'
end
