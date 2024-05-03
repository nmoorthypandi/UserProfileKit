Pod::Spec.new do |spec|
  spec.name         = 'UserProfileKit'
  spec.version      = '0.0.1'
  spec.summary      = 'A framework to create user profile.'
  spec.homepage     = 'https://github.com/nmoorthypandi/UserProfileKit'
  spec.license      = { :type => 'MIT' }
  spec.author       = { 'Narayanamoorthy Pandi' => 'mrty2212@gmail.com' }
  spec.source       = { :git => 'https://github.com/nmoorthypandi/UserProfileKit.git', :tag => '0.0.1'  }
  spec.source_files = 'UserProfileKit/**/*.swift'
  spec.swift_versions = '4.0'
  spec.ios.deployment_target  = '14.0'
end
