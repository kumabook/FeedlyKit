import PackageDescription

let package = Package(
  name: "FeedlyKit",
  dependencies: [
    .Package(url: "https://github.com/Alamofire/Alamofire.git", majorVersion: 4),
    .Package(url: "https://github.com/SwiftyJSON/SwiftyJSON.git", versions: Version(1,0,0)..<Version(3, .max, .max)),
  ]
)
