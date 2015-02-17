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
    public typealias AccessToken = String
    
    public enum Target {
        static let sandboxBaseUrl    = "https://sandbox.feedly.com"
        static let productionBaseUrl = "http://cloud.feedly.com/"

        case Sandbox
        case Production
        var baseUrl: String {
            get {
                switch self {
                case .Sandbox:    return Target.sandboxBaseUrl
                case .Production: return Target.productionBaseUrl
                }
            }
        }
    }
    public struct Config {
        public static var target:      Target  = Target.Sandbox
        public static var accessToken: AccessToken?
        static var baseURLString: String  = Config.target.baseUrl
    }

    public class var baseURLString: String       { get { return Config.target.baseUrl } }
    public class var accessToken:   AccessToken? { get { return Config.accessToken } }

    public init() {
    }
    
    public enum Router: URLRequestConvertible {
        var comma: String { return "," }
        func urlEncode(string: String) -> String {
            return string.stringByAddingPercentEncodingWithAllowedCharacters(
                                NSCharacterSet.URLHostAllowedCharacterSet())!
        }
        // Categories API
        case FetchCategories
        case UpdateCategory(String, String)
        case DeleteCategory(String)
        // Entries API
        case FetchEntry(String)
        case FetchEntries([String])
        case CreateEntry(Entry)
        // Feeds API
        case FetchFeed(String)
        case FetchFeeds([String])
        // Markers API
        case FetchUnreadCounts((autorefresh: Bool?, newerThan: Int64?, streamId: String?))
        case MarkAs(Marker.Action, [String], Marker.ItemType)
        case FetchLatestRead(Int64?)
        case FetchLatestTaggedEntryIds(Int64?)
        // Profile API
        case FetchProfile
        case UpdateProfile([String:String])
        // Search API
        case SearchFeeds(SearchQueryOfFeed)
        case SearchContentOfStream(String, String, SearchQueryOfContent)
        // Streams API
        case FetchEntryIds(String, PaginationParams)
        case FetchContents(String, PaginationParams)
        // Subscriptions API
        case FetchSubscriptions
        case SubscribeTo(Feed, [Category])
        case UpdateSubscription(Subscription)
        case UnsubscripbeTo(String)
        // Tags API
        case FetchTags
        case TagEntry([String], String)
        case TagEntries([String], [String])
        case ChangeTagLabel(String, String)
        case UntagEntries([String], [String])
        case DeleteTags([String])
        // Topics API
        case FetchTopics
        case AddTopic(String, String)
        case UpdateTopic(String, String)
        case RemoveTopic(String)
        
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
            case .FetchLatestRead:           return .GET
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
            case .UnsubscripbeTo:            return .DELETE
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

        var path: String {
            switch self {
                // Categories API
            case .FetchCategories:                  return "/v3/categories"
            case .UpdateCategory(let categoryId):   return "/v3/categories/\(categoryId)"
            case .DeleteCategory(let categoryId):   return "/v3/categories/\(categoryId)"
                // Entries API
            case .FetchEntry(let entryId):          return "/v3/entries/\(entryId)"
            case .FetchEntries:                     return "/v3/entries/.mget"
            case .CreateEntry:                      return "/v3/entries/"
                // Feeds API
            case .FetchFeed(let feedId):            return "/v3/feeds/\(feedId)"
            case .FetchFeeds:                       return "/v3/feeds/.mget"
                // Markers API
            case .FetchUnreadCounts:                return "/v3/markers/counts"
            case .MarkAs:                           return "/v3/markers"
            case .FetchLatestRead:                  return "/v3/markers/reads"
            case .FetchLatestTaggedEntryIds:        return "/v3/markers/tags"
                // Profile API
            case .FetchProfile:                     return "/v3/profile"
            case .UpdateProfile:                    return "/v3/profile"
                //Search API
            case .SearchFeeds:                      return "/v3/search/feeds"
            case .SearchContentOfStream(let streamId, let searchTerm, let query):
                return "/v3/search/" + urlEncode(streamId) + "/contents?query=" + searchTerm
                // Streams API
            case .FetchEntryIds(let streamId,  let paginationParams):
                return "/v3/streams/" + urlEncode(streamId) + "/ids"
            case .FetchContents(let streamId, let paginationParams):
                return "/v3/streams/" + urlEncode(streamId) + "/contents"
                // Subscriptions API
            case .FetchSubscriptions:               return "/v3/subscriptions"
            case .SubscribeTo:                      return "/v3/subscriptions"
            case .UpdateSubscription:               return "/v3/subscriptions"
            case .UnsubscripbeTo(let feedId):       return "/v3/subscriptions/\(feedId)"
                // Tags API
            case .FetchTags:                        return "/v3/tags"
            case .TagEntry(let tagIds, let entryId):
                                                    return "/v3/tags/\(join(self.comma, tagIds))"
            case .TagEntries(let tagIds, let entryIds):
                                                    return "/v3/tags/\(join(self.comma, tagIds))"
            case .ChangeTagLabel(let tagId):        return "/v3/tags/:\(tagId)"
            case .UntagEntries(let tagIds,
                              let entryIds):
                let tids = join(",", tagIds)
                let eids = join(",", entryIds)
                                                    return "/v3/tags/\(tids)/\(eids)"
            case .DeleteTags(let tagIds):
                let ids = join(",", tagIds)
                                                    return "/v3/tags/\(ids)"
                // Topics API
            case .FetchTopics:                      return "/v3/topics"
            case .AddTopic:                         return "/v3/topics"
            case .UpdateTopic:                      return "/v3/topics"
            case .RemoveTopic(let topicId):         return "/v3/topics/\(topicId)"
            }
        }
        // MARK: URLRequestConvertible
        public var URLRequest: NSURLRequest {
            let J = Alamofire.ParameterEncoding.JSON
            let U = Alamofire.ParameterEncoding.URL
            let URL = NSURL(string: CloudAPIClient.baseURLString + path)!
            let req = NSMutableURLRequest(URL: URL)

            req.HTTPMethod = method.rawValue
            
            if let token = CloudAPIClient.accessToken {
                req.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
            }
            
            switch self {
                // Categories API
            case .FetchCategories: return req
            case .UpdateCategory(let categoryId, let label):
                return J.encode(req, parameters: ["label": label]).0
            case .DeleteCategory:  return req
                // Entries API
            case .FetchEntry:                 return req
            case .FetchEntries(let entryIds): return req.addParam(entryIds)
            case .CreateEntry(let entry):     return J.encode(req, parameters: entry).0
                // Feeds API
            case .FetchFeed:                  return req
            case .FetchFeeds(let feedIds):    return req.addParam(feedIds)
                // Markers API
            case .FetchUnreadCounts(let (autorefresh: autorefresh, newerThan: newerThan, streamId: streamId)):
                var params: [String: AnyObject] = [:]
                if autorefresh != nil { params["autorefresh"] = autorefresh! }
                if newerThan   != nil { params["newerThan"]   =  NSNumber(longLong: newerThan!) }
                if streamId    != nil { params["streamId"]    = streamId }
                return J.encode(req, parameters: params).0
            case .MarkAs(let action, let itemIds, let type):
                var params: [String: AnyObject] = [:]
                params[type.key] = itemIds
                params["action"] = action.rawValue
                params["type"]   = type.type
                return J.encode(req, parameters: params).0
            case .FetchLatestRead(let newerThan):
                if let n = newerThan {
                    return J.encode(req, parameters: ["newerThan": NSNumber(longLong: n)]).0
                }
                return req
            case .FetchLatestTaggedEntryIds(let newerThan):
                if let n = newerThan {
                    return J.encode(req, parameters: ["newerThan": NSNumber(longLong: n)]).0
                }
                return req
                // Profile API
            case .FetchProfile:       return req
            case .UpdateProfile(let params):
                return J.encode(req, parameters: params).0
                // Search API
            case .SearchFeeds(let query):
                return U.encode(req, parameters: query).0
            case .SearchContentOfStream(let streamId, let searchTerm, let query):
                return U.encode(req, parameters: query).0
                //Streams API
            case .FetchEntryIds(let streamId, let params):
                return J.encode(req, parameters: params).0
            case .FetchContents(let streamId, let params):
                return J.encode(req, parameters: params).0
                // Subscriptions API
            case .FetchSubscriptions: return req
            case .SubscribeTo(let feed, let categories):
                return J.encode(req, parameters: Subscription(feed: feed, categories: categories)).0
            case .UpdateSubscription(let subscription):
                return J.encode(req, parameters: subscription).0
            case .UnsubscripbeTo:     return req
                // Tags API
            case .FetchTags:          return req
            case .TagEntry(let tagIds, let entryId):
                return J.encode(req, parameters: ["entryId": entryId]).0
            case .TagEntries(let tagIds, let entryIds):
                return J.encode(req, parameters: ["entryIds": entryIds]).0
            case .ChangeTagLabel(let tagId, let label):
                return J.encode(req, parameters: ["label": label]).0
            case .UntagEntries:       return req
            case .DeleteTags:         return req
                // Topics API
            case .FetchTopics:        return req
            case .AddTopic(let id, let interest):
                return J.encode(req, parameters: ["id": id, "interest": interest]).0
            case .UpdateTopic(let id, let interest):
                return J.encode(req, parameters: ["id": id, "interest": interest]).0
            case .RemoveTopic:        return req
            }
        }
    }
}

