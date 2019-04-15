Pod::Spec.new do |s|
  s.name             = 'MSCircularProgressView'
  s.version          = '1.2.0'
  s.summary          = 'A spinning loading indicator with completion feedback'

  s.description      = <<-DESC
A spinning loading indicator with completion feedback.  Allows for determinate and indeterminate progress feedback
                       DESC

  s.homepage         = 'https://www.mascomputech.com/msprogressview/'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'Michael Schloss' => 'mschloss11@gmail.com' }
  s.source           = { :git => 'https://github.com/schlossm/MSProgressView.git', :tag => s.version }

  s.ios.deployment_target = '10.0'
  s.swift_version = '5.0'

  s.source_files = 'MSProgressView/MSProgressView.swift', 'MSProgressView/MSProgressViewCompletion.swift'

  s.frameworks = 'UIKit'
end
