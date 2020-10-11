Pod::Spec.new do |s|
  s.name                    = 'CriteoEventsSDK'
  s.version                 = '1.1.4'
  s.summary                 = 'Power your Criteo targeted campaigns by using the Criteo events sdk.'
  s.homepage                = 'https://github.com/criteo/ios-events-sdk'
  s.license                 = { :type => 'Apache 2.0', :file => 'LICENSE' }
  s.author                  = { 'Criteo' => 'opensource@criteo.com' }
  s.source                  = { :git => 'https://github.com/criteo/ios-events-sdk.git', :tag => s.version.to_s }
  s.ios.deployment_target   = '8.0'
  s.source_files            = 'Sources/**/*.{h,m}'
  s.requires_arc            = true
end
