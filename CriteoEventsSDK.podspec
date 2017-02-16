Pod::Spec.new do |s|
  s.name                    = 'CriteoEventsSDK'
  s.version                 = '1.1.2'
  s.summary                 = 'Power your Criteo targeted campaigns by using the Criteo events sdk.'
  s.homepage                = 'https://github.com/criteo/ios-events-sdk'
  s.license                 = { :type => 'Apache 2.0', :file => 'LICENSE' }
  s.author                  = { 'Paul Davis' => 'p.davis@criteo.com' }
  s.source                  = { :git => 'https://github.com/criteo/ios-events-sdk.git', :tag => s.version.to_s }
  s.ios.deployment_target   = '6.0'
  s.source_files            = 'events-sdk/**/*.{h,m}'
  s.requires_arc            = true
end
