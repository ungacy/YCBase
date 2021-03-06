#
# Be sure to run `pod lib lint YCBase.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'YCBase'
  s.version          = '0.1.14'
  s.summary          = 'easy to imp'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC
-YCItem
-YCViewController
-YCTableViewController
-YCNavigationController
                       DESC

  s.homepage         = 'https://github.com/ungacy/YCBase'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'ungacy' => 'ungacy@126.com' }
  s.source           = { :git => 'https://github.com/ungacy/YCBase.git', :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/ungacy'

  s.ios.deployment_target = '9.0'

  s.source_files = 'YCBase/Classes/**/*'
  
  # s.resource_bundles = {
  #   'YCBase' => ['YCBase/Assets/*.png']
  # }

  s.public_header_files = 'YCBase/Classes/**/*.h'
  s.frameworks = 'UIKit'
  s.dependency 'Masonry'
end
