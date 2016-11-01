# coding: utf-8
Pod::Spec.new do |s|
  url                     = "https://github.com/kumabook/FeedlyKit"
  source_url              = "#{url}.git"
  s.name                  = "FeedlyKit"
  s.version               = "1.0.0"
  s.summary               = "Feedly Cloud API client library in Swift"
  s.homepage              = url
  s.license               = { :type => "MIT", :file => "LICENSE" }
  s.author                = { "Hiroki Kumamoto" => "kumabook@live.jp" }
  s.social_media_url      = "http://twitter.com/kumabook"
  s.ios.deployment_target = "9.0"
  s.osx.deployment_target = "11.0"
  s.source                = { git: source_url, tag: s.version }
  s.framework             = 'Foundation'
  s.source_files          = "Source/*.swift"
  s.exclude_files         = "Spec/*"

  s.dependency "SwiftyJSON", "~> 3.0"
  s.dependency "Alamofire",  "~> 4.0"

end
