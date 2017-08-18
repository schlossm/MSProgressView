#
# Be sure to run `pod lib lint MSProgressView.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'MSProgressView'
  s.version          = '1.0'
  s.summary          = 'A spinning loading indicator with completion feedback'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC
A spinning loading indicator with completion feedback.  Allows for determinate and indeterminate progress feedback
                       DESC

  s.homepage         = 'https://www.mascomputech.com/msprogressview/index.html'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'Michael Schloss' => 'mschloss11@gmail.com' }
  s.source           = { :git => 'https://github.com/schlossm/MSProgressView.git', :tag => 'master' }
  # s.social_media_url = 'https://twitter.com/officialschloss'

  s.ios.deployment_target = '9.0'

  s.source_files = 'MSProgressView/*'

  s.frameworks = 'UIKit'
end
