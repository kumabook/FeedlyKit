# FeedlyKit

[![Build Status](https://travis-ci.org/kumabook/FeedlyKit.svg?branch=master)](https://travis-ci.org/kumabook/FeedlyKit)
[![Carthage compatible](https://img.shields.io/badge/Carthage-compatible-4BC51D.svg?style=flat)](https://github.com/Carthage/Carthage)

[Feedly Cloud API][] client library with Swift

## Requirements

- iOS 9.0+ / macOS 10.11+ / tvOS 9.0+ / watchOS 2.0+
- Xcode 8.0+
- Swift 3.0+

If you use swift 2.x, use 0.*

## Installation
### Carthage
You can use [Carthage][] to install FeedlyKit by adding it to your Cartfile:

```
github "kumabook/FeedlyKit"
```

And run `carthage update` and setup your xcode project.

### Cocoapods
You can also use [Cocoapods][] to install FeedlyKit by adding it to your Podfile:
```Podfile
pod 'FeedlyKit', '~> 0.6'
```

## Support API
Currently, FeedlyKit partially support feedly cloud apis.

- [x] Categories API
- [x] Entries API
- [ ] Evernote API
- [ ] Facebook API
- [x] Feeds API
- [x] Markers API
- [ ] Microsoft API
- [ ] Mixes API
- [ ] OPML API
- [x] Preferences API
- [x] Profile API
- [x] Search API
- [x] Streams API
- [x] Subscriptions API
- [x] Tags API
- [ ] Twitter API
- [ ] URL Shortener API

## Usage

1. Setup the config values in FeedlyAPIClientConfig

    ```
    FeedlyKit.Config.target = .Sandbox   // .Sandbox or .Production
    ```

2. Obtain an ouath access token. You can use [NXOAuth2Client][] or other library
3. Set the access token as CloudAPIClient.Config.accessToken.

    ```
    FeedlyKit.Config.accessToken = "..."
    ```

4. You can use FeedlyKit.CloudAPIClient like below:

    ```swift
    let streamId                  = "..."
    var paginationParams          = PaginationParams()
    paginationParams.unreadOnly   = true
    paginationParams.count        = 15
    paginationParams.continuation = "..."
    let client                    = CloudAPIClient()
    client.fetchContents(streamId,
                       paginationParams: paginationParams,
                      completionHandler: { (response) -> Void in
                ....
    })
    ```
    You can also refer to [a example project](./Example/).

## Dependencies
Here is the libraies that FeedlyKit uses. Thanks for the developers.
- [Alamofire][]
- [SwiftyJSON][]
- [Quick][] (for testing)


[Feedly Cloud API]: http://developer.feedly.com/
[Carthage]:         https://github.com/Carthage/Carthage
[CocoaPods]:        https://cocoapods.org/
[NXOAuth2Client]:   https://github.com/nxtbgthng/OAuth2Client
[Alamofire]:        https://github.com/Alamofire/Alamofire
[SwiftyJSON]:       https://github.com/SwiftyJSON/SwiftyJSON
[Quick]:            https://github.com/Quick/Quick
