
//
//  FeedlyAPIClient.swift
//  MusicFav
//
//  Created by Hiroki Kumamoto on 12/21/14.
//  Copyright (c) 2014 Hiroki Kumamoto. All rights reserved.
//

import SwiftyJSON
import Alamofire

public protocol ResponseObjectSerializable {
    init?(response: NSHTTPURLResponse, representation: AnyObject)
}

public protocol ResponseCollectionSerializable {
    static func collection(response response: NSHTTPURLResponse, representation: AnyObject) -> [Self]?
}

public typealias AccessToken = String

extension Alamofire.Request {
    public func responseObject<T: ResponseObjectSerializable>(completionHandler: (Response<T, NSError>) -> Void) -> Self {
        let responseSerializer = ResponseSerializer<T, NSError> { request, response, data, error in
            guard error == nil else { return .Failure(error!) }
            let JSONSerializer = Request.JSONResponseSerializer(options: .AllowFragments)
            let result = JSONSerializer.serializeResponse(request, response, data, error)
            switch result {
            case .Success(let value):
                if let
                    response = response,
                    responseObject = T(response: response, representation: value)
                {
                    return .Success(responseObject)
                } else {
                    let failureReason = "JSON could not be serialized into response object: \(value)"
                    let error = Error.errorWithCode(.JSONSerializationFailed, failureReason: failureReason)
                    return .Failure(error)
                }
            case .Failure(let error):
                return .Failure(error)
            }
        }
        return response(responseSerializer: responseSerializer, completionHandler: completionHandler)
    }

    public func responseCollection<T: ResponseCollectionSerializable>(completionHandler: (Response<[T], NSError>) -> Void) -> Self {
        let responseSerializer = ResponseSerializer<[T], NSError> { request, response, data, error in
            guard error == nil else { return .Failure(error!) }
            let JSONSerializer = Request.JSONResponseSerializer(options: .AllowFragments)
            let result = JSONSerializer.serializeResponse(request, response, data, error)
            switch result {
            case .Success(let value):
                if let
                    response = response,
                    responseObject = T.collection(response: response, representation: value)
                {
                    return .Success(responseObject)
                } else {
                    let failureReason = "JSON could not be serialized into response object: \(value)"
                    let error = Error.errorWithCode(.JSONSerializationFailed, failureReason: failureReason)
                    return .Failure(error)
                }
            case .Failure(let error):
                return .Failure(error)
            }
        }
        return response(responseSerializer: responseSerializer, completionHandler: completionHandler)
    }

    public func response(completionHandler: (Response<Void, NSError>) -> Void) -> Self {
        return responseString(encoding: NSUTF8StringEncoding) { response in
            if response.result.isSuccess {
                completionHandler(Response<Void, NSError>(request: response.request,
                                                         response: response.response,
                                                             data: response.data,
                                                           result: Result.Success()))
            } else {
                completionHandler(Response<Void, NSError>(request: response.request,
                                                         response: response.response,
                                                             data: response.data,
                                                           result: Result.Failure(response.result.error!)))
            }
        }
    }
}

public protocol ParameterEncodable {
    func toParameters() -> [String: AnyObject]
}

public extension Alamofire.ParameterEncoding {
    func encode(URLRequest: URLRequestConvertible, parameters: ParameterEncodable?) -> (NSMutableURLRequest, NSError?) {
        return encode(URLRequest, parameters: parameters?.toParameters())
    }
}

extension NSMutableURLRequest {
    func addParam(params: AnyObject) -> NSMutableURLRequest {
        let data = try? NSJSONSerialization.dataWithJSONObject(params, options: NSJSONWritingOptions.PrettyPrinted)
        self.HTTPBody = data
        self.setValue("application/json", forHTTPHeaderField: "Content-Type")
        return self
    }
}

public class CloudAPIClient {
    public enum Target {
        static let sandboxBaseUrl    = "http://sandbox.feedly.com"
        static let productionBaseUrl = "http://cloud.feedly.com"

        case Sandbox
        case Production
        case Custom(String)
        public var baseUrl: String {
            get {
                switch self {
                case .Sandbox:             return Target.sandboxBaseUrl
                case .Production:          return Target.productionBaseUrl
                case .Custom(let baseUrl): return baseUrl
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
            return string.stringByAddingPercentEncodingWithAllowedCharacters(.URLHostAllowedCharacterSet())!
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
        case UpdateProfile(Target, [String:AnyObject])
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
        // Custom
        case Api(API)
        
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
                // Custom
            case .Api(let api):              return api.method
            }
        }

        var url: String {
            switch self {
                // Categories API
            case .FetchCategories(let target):                   return target.baseUrl + "/v3/categories"
            case .UpdateCategory(let target, let categoryId, _): return target.baseUrl + "/v3/categories/\(urlEncode(categoryId))"
            case .DeleteCategory(let target, let categoryId):    return target.baseUrl + "/v3/categories/\(urlEncode(categoryId))"
                // Entries API
            case .FetchEntry(let target, let entryId):           return target.baseUrl + "/v3/entries/\(urlEncode(entryId))"
            case .FetchEntries(let target, _):                   return target.baseUrl + "/v3/entries/.mget"
            case .CreateEntry(let target, _):                    return target.baseUrl + "/v3/entries/"
                // Feeds API
            case .FetchFeed(let target, let feedId):             return target.baseUrl + "/v3/feeds/\(urlEncode(feedId))"
            case .FetchFeeds(let target, _):                     return target.baseUrl + "/v3/feeds/.mget"
                // Markers API
            case .FetchUnreadCounts(let target, _):              return target.baseUrl + "/v3/markers/counts"
            case .MarkAs(let target, _):                         return target.baseUrl + "/v3/markers"
       
            case .FetchLatestReadOperations(let target, _):      return target.baseUrl + "/v3/markers/reads"
            case .FetchLatestTaggedEntryIds(let target, _):      return target.baseUrl + "/v3/markers/tags"
                // Profile API
            case .FetchProfile(let target):                      return target.baseUrl + "/v3/profile"
            case .UpdateProfile(let target, _):                  return target.baseUrl + "/v3/profile"
                //Search API
            case .SearchFeeds(let target, _):                    return target.baseUrl + "/v3/search/feeds"
            case .SearchContentOfStream(let target, let streamId, let searchTerm, _):
                                                                 return target.baseUrl + "/v3/search/" + urlEncode(streamId) + "/contents?query=" + urlEncode(searchTerm)
                // Streams API
            case .FetchEntryIds(let target, let streamId,  _):   return target.baseUrl + "/v3/streams/" + urlEncode(streamId) + "/ids"
            case .FetchContents(let target, let streamId, _):    return target.baseUrl + "/v3/streams/" + urlEncode(streamId) + "/contents"
                // Subscriptions API
            case .FetchSubscriptions(let target):                return target.baseUrl + "/v3/subscriptions"
            case .SubscribeTo(let target, _):                    return target.baseUrl + "/v3/subscriptions"
            case .UpdateSubscription(let target, _):             return target.baseUrl + "/v3/subscriptions"
            case .UnsubscribeTo(let target, let feedId):         return target.baseUrl + "/v3/subscriptions/\(urlEncode(feedId))"
                // Tags API
            case .FetchTags(let target):                         return target.baseUrl + "/v3/tags"
            case .TagEntry(let target, let tagIds, _):
                let tids = tagIds.map({ self.urlEncode($0) }).joinWithSeparator(",")
                                                                 return target.baseUrl + "/v3/tags/\(tids))"
            case .TagEntries(let target, let tagIds, _):
                let tids = tagIds.map({ self.urlEncode($0) }).joinWithSeparator(",")
                                                                 return target.baseUrl + "/v3/tags/\(tids)"
            case .ChangeTagLabel(let target, let tagId, _):      return target.baseUrl + "/v3/tags/\(urlEncode(tagId))"
            case .UntagEntries(let target, let tagIds, _):
                let tids = tagIds.map({   self.urlEncode($0) }).joinWithSeparator(",")
                                                                 return target.baseUrl + "/v3/tags/\(tids)"
            case .DeleteTags(let target, let tagIds):
                let tids = tagIds.map({ self.urlEncode($0) }).joinWithSeparator(",")
                                                                 return target.baseUrl + "/v3/tags/\(tids)"
                // Custom
            case .Api(let api):                                  return api.url
            }
        }
        // MARK: URLRequestConvertible
        public var URLRequest: NSMutableURLRequest {
            let J = Alamofire.ParameterEncoding.JSON
            let U = Alamofire.ParameterEncoding.URL
            let URL = NSURL(string: url)!
            let req = NSMutableURLRequest(URL: URL)

            req.HTTPMethod = method.rawValue

            switch self {
                // Categories API
            case .FetchCategories:                              return req
            case .UpdateCategory(_, _, let label):              return J.encode(req, parameters: ["label": label]).0
            case .DeleteCategory:                               return req
                // Entries API
            case .FetchEntry:                                   return req
            case .FetchEntries(_, let entryIds):                return req.addParam(entryIds)
            case .CreateEntry(_, let entry):                    return J.encode(req, parameters: entry).0
                // Feeds API
            case .FetchFeed:                                    return req
            case .FetchFeeds(_, let feedIds):                   return req.addParam(feedIds)
                // Markers API
            case .FetchUnreadCounts(_, let unreadCountsParams): return U.encode(req, parameters: unreadCountsParams).0
            case .MarkAs(_, let params):                        return J.encode(req, parameters: params).0
            case .FetchLatestReadOperations(_, let newerThan):
                if let n = newerThan {
                    return J.encode(req, parameters: ["newerThan": NSNumber(longLong: n)]).0
                }
                return req
            case .FetchLatestTaggedEntryIds(_, let newerThan):
                if let n = newerThan {
                    return J.encode(req, parameters: ["newerThan": NSNumber(longLong: n)]).0
                }
                return req
                // Profile API
            case .FetchProfile:                              return req
            case .UpdateProfile(_, let params):              return U.encode(req, parameters: params).0
                // Search API
            case .SearchFeeds(_, let query):                 return U.encode(req, parameters: query).0
            case .SearchContentOfStream(_, _, _, let query): return U.encode(req, parameters: query).0
                //Streams API
            case .FetchEntryIds(_, _, let params):           return U.encode(req, parameters: params).0
            case .FetchContents(_, _, let params):           return U.encode(req, parameters: params).0
                // Subscriptions API
            case .FetchSubscriptions:                        return req
            case .SubscribeTo(_, let subscription):          return J.encode(req, parameters: subscription).0
            case .UpdateSubscription(_, let subscription):   return J.encode(req, parameters: subscription).0
            case .UnsubscribeTo:                             return req
                // Tags API
            case .FetchTags:                                 return req
            case .TagEntry(_, _, let entryId):               return J.encode(req, parameters: ["entryId": entryId]).0
            case .TagEntries(_, _, let entryIds):            return J.encode(req, parameters: ["entryIds": entryIds]).0
            case .ChangeTagLabel(_, _, let label):           return J.encode(req, parameters: ["label": label]).0
            case .UntagEntries(_, _, let entryIds):          return J.encode(req, parameters: ["entryIds": entryIds]).0
            case .DeleteTags:                                return req
                // Custom
            case .Api(let api):                              return api.URLRequest
            }
        }
    }
}

