Pod::Spec.new do |s|
  s.name             = 'CSModuleManager'
  s.version          = '0.0.1'
  s.summary          = 'CSModuleManager.'
  s.description      = <<-DESC
                       a module management library used in Swift .
                       DESC

  s.homepage         = 'https://github.com/Coder-Star/CSModuleManager'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'CoderStar' => '1340529758@qq.com' }
  s.source           = { :git => 'https://github.com/Coder-Star/CSModuleManager.git', :tag => s.version.to_s }
  s.swift_version = '5.0'
  s.ios.deployment_target = '9.0'

  s.source_files = 'CSModuleManager/Classes/**/*'

end
