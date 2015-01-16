//
//  FeedlyAPIClient.swift
//  MusicFav
//
//  Created by Hiroki Kumamoto on 12/21/14.
//  Copyright (c) 2014 Hiroki Kumamoto. All rights reserved.
//

import SwiftyJSON
import Alamofire

class CloudAPIClient {
    class var sharedInstance : CloudAPIClient {
        struct Static {
            static let instance: CloudAPIClient = CloudAPIClient()
        }
        return Static.instance
    }
    struct Config {
        static let baseUrl      = "https://sandbox.feedly.com"
        static let authPath     = "/v3/auth/auth"
        static let tokenPath    = "/v3/auth/token"
        static let accountType  = "Feedly"
        static let clientId     = "sandbox"
        static let clientSecret = "9ZUHFZ9N2ZQ0XM5ERU1Z"
        static let redirectUrl  = "http://localhost"
        static let scopeUrl     = "https://cloud.feedly.com/subscriptions"
        static let authUrl      = String(format: "%@/%@", baseUrl, authPath)
        static let tokenUrl     = String(format: "%@/%@", baseUrl, tokenPath)
        static let perPage      = 15
    }
    
    enum Router: URLRequestConvertible {
        static let baseURLString = "https://sandbox.feedly.com"
        static var OAuthToken: String?
        
        case FetchProfile
        case FetchSubscriptions
        case FetchEntries
        case FetchAllEntries(String)
        case FetchFeedsByTopic
        
        var method: Alamofire.Method {
            switch self {
            case .FetchProfile:
                return .GET
            case .FetchSubscriptions:
                return .GET
            case .FetchAllEntries:
                return .GET
            case .FetchEntries:
                return .GET
            case .FetchFeedsByTopic:
                return .POST
            
            }
        }
        
        var path: String {
            switch self {
            case .FetchProfile:
                return "/v3/profile"
            case .FetchSubscriptions:
                return "/v3/subscriptions"
            case .FetchAllEntries(let userId):
                return "/v3/user/\(userId)/category/global.all"
            case .FetchEntries(let streamId):
                return "/v3/streams/\(streamId)/contents"
            case .FetchFeedsByTopic:
                return "/v3/search/feeds"
            }
        }
        
        // MARK: URLRequestConvertible
        
        var URLRequest: NSURLRequest {
            let URL = NSURL(string: Router.baseURLString)!
            let mutableURLRequest = NSMutableURLRequest(URL: URL.URLByAppendingPathComponent(path))
            mutableURLRequest.HTTPMethod = method.rawValue
            
            if let token = Router.OAuthToken {
                mutableURLRequest.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
            }
            
            switch self {
            default:
                return mutableURLRequest
            }
        }
    }

    private var accessToken: String?
    private let userDefaults = NSUserDefaults.standardUserDefaults()
    var isLoggedIn: Bool {
        return accessToken != nil
    }
}
