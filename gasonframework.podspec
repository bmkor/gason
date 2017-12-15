Pod::Spec.new do |s|

  s.name         = "gasonframework"
  s.version      = "0.0.1"
  s.summary      = "A light and fast JSON praser built on gason."
  s.description  = <<-DESC
  A light and fast JSON parser built on gason. More information on gason can be found in https://github.com/vivkin/gason.
                   DESC

  s.homepage     = "https://github.com/bmkor/gason"
  s.license      = { :type => "MIT", :file => "LICENSE"}
  s.author       = { "Benjamin" => "orbenappdev@gmail.com" }

  s.platform     = :ios
  s.ios.deployment_target = "9.0"

  s.source       = { :git => "https://github.com/bmkor/gason.git", :tag => "#{s.version}" }

  s.source_files  = 'gasonframework/*.{h,swift}', 'gasonframework/ProjectModule/*.{h,cpp,mm}'
  s.public_header_files = 'gasonframework/*.h', 'gasonframework/ProjectModule/NSObject+gason.h'

  s.module_map = 'gasonframework/ProjectModule/gason.modulemap'
  s.preserve_paths = "gasonframework/ProjectModule/gason.modulemap"
  s.requires_arc = true

end
