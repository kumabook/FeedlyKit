//
//  FeedlyAPIClient.swift
//  MusicFav
//
//  Created by Hiroki Kumamoto on 12/21/14.
//  Copyright (c) 2014 Hiroki Kumamoto. All rights reserved.
//

import SwiftyJSON
import Alamofire

@objc public protocol ResponseObjectSerializable {
    init?(response: NSHTTPURLResponse, representation: AnyObject)
}

@objc public protocol ResponseCollectionSerializable {
    class func collection(#response: NSHTTPURLResponse, representation: AnyObject) -> [Self]
}

public typealias AccessToken = String

extension Alamofire.Request {
    public func responseObject<T: ResponseObjectSerializable>(completionHandler: (NSURLRequest, NSHTTPURLResponse?, T?, NSError?) -> Void) -> Self {
        let serializer: Serializer = { (request, response, data) in
            let JSONSerializer = Request.JSONResponseSerializer(options: .AllowFragments)
            let (JSON: AnyObject?, serializationError) = JSONSerializer(request, response, data)
            if response != nil && JSON != nil {
                return (T(response: response!, representation: JSON!), nil)
            } else {
                return (nil, serializationError)
            }
        }
        
        return response(serializer: serializer, completionHandler: { (request, response, object, error) in
            completionHandler(request, response, object as? T, error)
        })
    }
    public func responseCollection<T: ResponseCollectionSerializable>(completionHandler: (NSURLRequest, NSHTTPURLResponse?, [T]?, NSError?) -> Void) -> Self {
        let serializer: Serializer = { (request, response, data) in
            let JSONSerializer = Request.JSONResponseSerializer(options: .AllowFragments)
            let (JSON: AnyObject?, serializationError) = JSONSerializer(request, response, data)
            if response != nil && JSON != nil {
                return (T.collection(response: response!, representation: JSON!), nil)
            } else {
                return (nil, serializationError)
            }
        }
        
        return response(serializer: serializer, completionHandler: { (request, response, object, error) in
            completionHandler(request, response, object as? [T], error)
        })
    }
    public func responseStringList(completionHandler: (NSURLRequest, NSHTTPURLResponse?, [String]?, NSError?) -> Void) -> Self {
        let serializer: Serializer = { (request, response, data) in
            let JSONSerializer = Request.JSONResponseSerializer(options: .AllowFragments)
            let (JSON: AnyObject?, serializationError) = JSONSerializer(request, response, data)
            if response != nil && JSON != nil {
                return (JSON!.array.map({$0.stringValue}), nil)
            } else {
                return (nil, serializationError)
            }
        }

        return response(serializer: serializer, completionHandler: { (request, response, object, error) in
            completionHandler(request, response, object as? [String], error)
        })
    }
    public func response(completionHandler: (NSURLRequest, NSHTTPURLResponse?, NSError?) -> Void) -> Self {
        return responseString({ (request, response, representation, error) -> Void in
            completionHandler(request, response, error)
        })
    }
}

@objc protocol ParameterEncodable {
    func toParameters() -> [String: AnyObject]
}

extension Alamofire.ParameterEncoding {
    func encode(URLRequest: URLRequestConvertible, parameters: ParameterEncodable?) -> (NSURLRequest, NSError?) {
        return encode(URLRequest, parameters: parameters?.toParameters())
    }
}

extension NSMutableURLRequest {
    func addParam(params: AnyObject) -> NSURLRequest {
        let data = NSJSONSerialization.dataWithJSONObject(params, options: NSJSONWritingOptions.PrettyPrinted, error: nil)
        self.HTTPBody = data
        self.setValue("application/json", forHTTPHeaderField: "Content-Type")
        return self
    }
}

public class CloudAPIClient {
    public enum Target {
        static let sandboxBaseUrl    = "https://sandbox.feedly.com"
        static let productionBaseUrl = "http://cloud.feedly.com"

        case Sandbox
        case Production
        public var baseUrl: String {
            get {
                switch self {
                case .Sandbox:    return Target.sandboxBaseUrl
                case .Production: return Target.productionBaseUrl
                }
            }
        }
    }

    public var manager: Alamofire.Manager!
    public var target: Target

    public init(target: Target) {
        self.target = target
        manager     = Alamofire.Manager(configuration: NSURLSessionConfiguration.ephemeralSessionConfiguration())
    }

    public func setAccessToken(accessToken: AccessToken?) {
        let configuration = manager.session.configuration
        var headers = configuration.HTTPAdditionalHeaders ?? [:]
        if let token = accessToken {
            headers["Authorization"] = "Bearer \(token)"
        } else {
            headers.removeValueForKey("Authorization")
        }
        configuration.HTTPAdditionalHeaders = headers
        manager = Alamofire.Manager(configuration: configuration)
    }

    public enum Router: URLRequestConvertible {
        var comma: String { return "," }
        func urlEncode(string: String) -> String {
            return string.stringByAddingPercentEncodingWithAllowedCharacters(
                                NSCharacterSet.URLHostAllowedCharacterSet())!
        }
        // Categories API
        case FetchCategories(Target)
        case UpdateCategory(Target, String, String)
        case DeleteCategory(Target, String)
        // Entries API
        case FetchEntry(Target, String)
        case FetchEntries(Target, [String])
        case CreateEntry(Target, Entry)
        // Feeds API
        case FetchFeed(Target, String)
        case FetchFeeds(Target, [String])
        // Markers API
        case FetchUnreadCounts(Target, UnreadCountsParams)
        case MarkAs(Target, MarkerParam)
        case FetchLatestReadOperations(Target, Int64?)
        case FetchLatestTaggedEntryIds(Target, Int64?)
        // Profile API
        case FetchProfile(Target)
        case UpdateProfile(Target, [String:String])
        // Search API
        case SearchFeeds(Target, SearchQueryOfFeed)
        case SearchContentOfStream(Target, String, String, SearchQueryOfContent)
        // Streams API
        case FetchEntryIds(Target, String, PaginationParams)
        case FetchContents(Target, String, PaginationParams)
        // Subscriptions API
        case FetchSubscriptions(Target)
        case SubscribeTo(Target, Subscription)
        case UpdateSubscription(Target, Subscription)
        case UnsubscribeTo(Target, String)
        // Tags API
        case FetchTags(Target)
        case TagEntry(Target, [String], String)
        case TagEntries(Target, [String], [String])
        case ChangeTagLabel(Target, String, String)
        case UntagEntries(Target, [String], [String])
        case DeleteTags(Target, [String])
        // Topics API
        case FetchTopics(Target)
        case AddTopic(Target, String, String)
        case UpdateTopic(Target, String, String)
        case RemoveTopic(Target, String)
        
        var method: Alamofire.Method {
            switch self {
                // Categories API
            case .FetchCategories:           return .GET
            case .UpdateCategory:            return .POST
            case .DeleteCategory:            return .DELETE
                // Entries API
            case .FetchEntry:                return .GET
            case .FetchEntries:              return .POST
            case .CreateEntry:               return .POST
                // Feeds API
            case .FetchFeed:                 return .GET
            case .FetchFeeds:                return .POST
                // Markers API
            case .FetchUnreadCounts:         return .GET
            case .MarkAs:                    return .POST
            case .FetchLatestReadOperations: return .GET
            case .FetchLatestTaggedEntryIds: return .GET
                // Profile API
            case .FetchProfile:              return .GET
            case .UpdateProfile:             return .GET
                //Search API
            case .SearchFeeds:               return .GET
            case .SearchContentOfStream:     return .GET
                //Streams API
            case .FetchEntryIds:             return .GET
            case .FetchContents:             return .GET
                // Subscriptions API
            case .FetchSubscriptions:        return .GET
            case .SubscribeTo:               return .POST
            case .UpdateSubscription:        return .POST
            case .UnsubscribeTo:             return .DELETE
                // Tags API
            case .FetchTags:                 return .GET
            case .TagEntry:                  return .PUT
            case .TagEntries:                return .PUT
            case .ChangeTagLabel:            return .POST
            case .UntagEntries:              return .DELETE
            case .DeleteTags:                return .DELETE
                // Topics API
            case .FetchTopics:               return .GET
            case .AddTopic:                  return .POST
            case .UpdateTopic:               return .POST
            case .RemoveTopic:               return .DELETE
            }
        }

        var url: String {
            switch self {
                // Categories API
            case .FetchCategories(let target):
                return target.baseUrl + "/v3/categories"
            case .UpdateCategory(let target, let categoryId, let label):
                return target.baseUrl + "/v3/categories/\(urlEncode(categoryId))"
            case .DeleteCategory(let target, let categoryId):
                return target.baseUrl + "/v3/categories/\(urlEncode(categoryId))"
                // Entries API
            case .FetchEntry(let target, let entryId):
                return target.baseUrl + "/v3/entries/\(urlEncode(entryId))"
            case .FetchEntries(let target, let entryIds):
                return target.baseUrl + "/v3/entries/.mget"
            case .CreateEntry(let target, let entry):
                return target.baseUrl + "/v3/entries/"
                // Feeds API
            case .FetchFeed(let target, let feedId):
                return target.baseUrl + "/v3/feeds/\(urlEncode(feedId))"
            case .FetchFeeds(let target, let feedIds):
                return target.baseUrl + "/v3/feeds/.mget"
                // Markers API
            case .FetchUnreadCounts(let target, let unreadCountsParams):
                return target.baseUrl + "/v3/markers/counts"
            case .MarkAs(let target, let params):
                return target.baseUrl + "/v3/markers"
            case .FetchLatestReadOperations(let target, let newerThan):
                return target.baseUrl + "/v3/markers/reads"
            case .FetchLatestTaggedEntryIds(let target, let newerThan):
                return target.baseUrl + "/v3/markers/tags"
                // Profile API
            case .FetchProfile(let target):
                return target.baseUrl + "/v3/profile"
            case .UpdateProfile(let target, let profile):
                return target.baseUrl + "/v3/profile"
                //Search API
            case .SearchFeeds(let target, let query):
                return target.baseUrl + "/v3/search/feeds"
            case .SearchContentOfStream(let target, let streamId, let searchTerm, let query):
                return target.baseUrl + "/v3/search/" + urlEncode(streamId) + "/contents?query=" + urlEncode(searchTerm)
                // Streams API
            case .FetchEntryIds(let target, let streamId,  let paginationParams):
                return target.baseUrl + "/v3/streams/" + urlEncode(streamId) + "/ids"
            case .FetchContents(let target, let streamId, let paginationParams):
                return target.baseUrl + "/v3/streams/" + urlEncode(streamId) + "/contents"
                // Subscriptions API
            case .FetchSubscriptions(let target):
                return target.baseUrl + "/v3/subscriptions"
            case .SubscribeTo(let target, let subscription):
                return target.baseUrl + "/v3/subscriptions"
            case .UpdateSubscription(let target, let subscription):
                return target.baseUrl + "/v3/subscriptions"
            case .UnsubscribeTo(let target, let feedId):
                return target.baseUrl + "/v3/subscriptions/\(urlEncode(feedId))"
                // Tags API
            case .FetchTags(let target):
                return target.baseUrl + "/v3/tags"
            case .TagEntry(let target, let tagIds, let entryId):
                let tids = join(",", tagIds.map({ self.urlEncode($0) }))
                return target.baseUrl + "/v3/tags/\(tids))"
            case .TagEntries(let target, let tagIds, let entryIds):
                let tids = join(",", tagIds.map({ self.urlEncode($0) }))
                return target.baseUrl + "/v3/tags/\(tids)"
            case .ChangeTagLabel(let target, let tagId, let label):
                return target.baseUrl + "/v3/tags/\(urlEncode(tagId))"
            case .UntagEntries(let target, let tagIds, let entryIds):
                let tids = join(",", tagIds.map({   self.urlEncode($0) }))
                let eids = join(",", entryIds.map({ self.urlEncode($0) }))
                return target.baseUrl + "/v3/tags/\(tids)/\(eids)"
            case .DeleteTags(let target, let tagIds):
                let tids = join(",", tagIds.map({ self.urlEncode($0) }))
                return target.baseUrl + "/v3/tags/\(tids)"
                // Topics API
            case .FetchTopics(let target):
                return target.baseUrl + "/v3/topics"
            case .AddTopic(let target, let id, let interest):
                return target.baseUrl + "/v3/topics"
            case .UpdateTopic(let target, let id, let interest):
                return target.baseUrl + "/v3/topics"
            case .RemoveTopic(let target, let topicId):
                return target.baseUrl + "/v3/topics/\(urlEncode(topicId))"
            }
        }
        // MARK: URLRequestConvertible
        public var URLRequest: NSURLRequest {
            let J = Alamofire.ParameterEncoding.JSON
            let U = Alamofire.ParameterEncoding.URL
            let URL = NSURL(string: url)!
            let req = NSMutableURLRequest(URL: URL)

            req.HTTPMethod = method.rawValue

            switch self {
                // Categories API
            case .FetchCategories:                        return req
            case .UpdateCategory(let target, let categoryId, let label):
                return J.encode(req, parameters: ["label": label]).0
            case .DeleteCategory:                         return req
                // Entries API
            case .FetchEntry:                             return req
            case .FetchEntries(let target, let entryIds): return req.addParam(entryIds)
            case .CreateEntry(let target, let entry):     return J.encode(req, parameters: entry).0
                // Feeds API
            case .FetchFeed:                  return req
            case .FetchFeeds(let target, let feedIds):    return req.addParam(feedIds)
                // Markers API
            case .FetchUnreadCounts(let target, let unreadCountsParams):
                return J.encode(req, parameters: unreadCountsParams).0
            case .MarkAs(let target, let params):
                return J.encode(req, parameters: params).0
            case .FetchLatestReadOperations(let target, let newerThan):
                if let n = newerThan {
                    return J.encode(req, parameters: ["newerThan": NSNumber(longLong: n)]).0
                }
                return req
            case .FetchLatestTaggedEntryIds(let target, let newerThan):
                if let n = newerThan {
                    return J.encode(req, parameters: ["newerThan": NSNumber(longLong: n)]).0
                }
                return req
                // Profile API
            case .FetchProfile:       return req
            case .UpdateProfile(let target, let params):
                return J.encode(req, parameters: params).0
                // Search API
            case .SearchFeeds(let target, let query):
                return U.encode(req, parameters: query).0
            case .SearchContentOfStream(let target, let streamId, let searchTerm, let query):
                return U.encode(req, parameters: query).0
                //Streams API
            case .FetchEntryIds(let target, let streamId, let params):
                return U.encode(req, parameters: params).0
            case .FetchContents(let target, let streamId, let params):
                return U.encode(req, parameters: params).0
                // Subscriptions API
            case .FetchSubscriptions: return req
            case .SubscribeTo(let target, let subscription):
                return J.encode(req, parameters: subscription).0
            case .UpdateSubscription(let target, let subscription):
                return J.encode(req, parameters: subscription).0
            case .UnsubscribeTo:      return req
                // Tags API
            case .FetchTags:          return req
            case .TagEntry(let target, let tagIds, let entryId):
                return J.encode(req, parameters: ["entryId": entryId]).0
            case .TagEntries(let target, let tagIds, let entryIds):
                return J.encode(req, parameters: ["entryIds": entryIds]).0
            case .ChangeTagLabel(let target, let tagId, let label):
                return J.encode(req, parameters: ["label": label]).0
            case .UntagEntries:       return req
            case .DeleteTags:         return req
                // Topics API
            case .FetchTopics:        return req
            case .AddTopic(let target, let id, let interest):
                return J.encode(req, parameters: ["id": id, "interest": interest]).0
            case .UpdateTopic(let target, let id, let interest):
                return J.encode(req, parameters: ["id": id, "interest": interest]).0
            case .RemoveTopic:        return req
            }
        }
    }
}

