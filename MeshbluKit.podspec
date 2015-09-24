#
# Be sure to run `pod lib lint MeshbluKit.podspec' to ensure this is a
# valid spec and remove all comments before submitting the spec.
#
# Any lines starting with a # are optional, but encouraged
#
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = "MeshbluKit"
  s.version          = "1.4.1"
  s.summary          = "Objective-C / Swift Meshblu Client Library"
  s.description      = <<-DESC
		       Objective-C / Swift Meshblu Client Library to easily connect Meshblu to iOS
                       DESC
  s.homepage         = "https://github.com/octoblu/MeshbluKit"
  # s.screenshots     = "www.example.com/screenshots_1", "www.example.com/screenshots_2"
  s.license          = 'MIT'
  s.author           = { "Sqrt of Octoblu" => "sqrt@octoblu.com" }
  s.source           = { :git => "https://github.com/octoblu/MeshbluKit.git", :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

  s.platform     = :ios, '8.0'
  s.requires_arc = true

  s.source_files = 'Pod/Classes/**/*'
  s.resource_bundles = {
    'MeshbluKit' => ['Pod/Assets/*.png']
  }

  # s.public_header_files = 'Pod/Classes/**/*.h'
  # s.frameworks = 'UIKit', 'MapKit'
  s.dependency 'Alamofire', '~> 2.0.2'
  s.dependency 'SwiftyJSON', '~> 2.3.0'
end
