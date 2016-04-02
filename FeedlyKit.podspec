# coding: utf-8
Pod::Spec.new do |s|
  url                     = "https://github.com/kumabook/FeedlyKit"
  source_url              = "#{url}.git"
  s.name                  = "FeedlyKit"
  s.version               = "0.5.3"
  s.summary               = "Feedly Cloud API client library with Swift"
  s.homepage              = url
  s.license               = { :type => "MIT", :file => "LICENSE" }
  s.author                = { "Hiroki Kumamoto" => "kumabook@live.jp" }
  s.social_media_url      = "http://twitter.com/kumabook"
  s.ios.deployment_target = "8.0"
  s.osx.deployment_target = "10.9"
  s.source                = { git: source_url, tag: s.version }
  s.framework             = 'Foundation'
  s.source_files          = "Source/*.swift"
  s.exclude_files         = "Spec/*"

  s.dependency "SwiftyJSON", "~> 2.3"
  s.dependency "Alamofire",  "~> 3.2.1"

end
