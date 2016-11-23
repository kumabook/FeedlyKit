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
    init?(response: HTTPURLResponse, representation: Any)
}

public protocol ResponseCollectionSerializable {
    static func collection(_ response: HTTPURLResponse, representation: Any) -> [Self]?
}

public typealias AccessToken = String

enum APIError: Error {
    case network(error: Error) // Capture any underlying Error from the URLSession API
    case dataSerialization(error: Error)
    case jsonSerialization(error: Error)
    case objectSerialization(reason: String)
}

extension DataRequest {
    @discardableResult
    public func responseObject<T: ResponseObjectSerializable>(_ queue: DispatchQueue? = nil, completionHandler: @escaping (DataResponse<T>) -> Void) -> Self {
        let responseSerializer = DataResponseSerializer<T> { request, response, data, error in
            guard error == nil else { return .failure(APIError.network(error: error!)) }

            let jsonResponseSerializer = DataRequest.jsonResponseSerializer(options: .allowFragments)
            let result = jsonResponseSerializer.serializeResponse(request, response, data, nil)

            guard case let .success(jsonObject) = result else {
                return .failure(APIError.jsonSerialization(error: result.error!))
            }

            guard let response = response, let responseObject = T(response: response, representation: jsonObject) else {
                return .failure(APIError.objectSerialization(reason: "JSON could not be serialized: \(jsonObject)"))
            }

            return .success(responseObject)
        }
        return response(queue: queue, responseSerializer: responseSerializer, completionHandler: completionHandler)
    }

    @discardableResult
    public func responseCollection<T: ResponseCollectionSerializable>(_ queue: DispatchQueue? = nil,  completionHandler: @escaping (DataResponse<[T]>) -> Void) -> Self {
        let responseSerializer = DataResponseSerializer<[T]> { request, response, data, error in
            guard error == nil else { return .failure(error!) }
            let jsonResponseSerializer = DataRequest.jsonResponseSerializer(options: .allowFragments)
            let result = jsonResponseSerializer.serializeResponse(request, response, data, nil)
            guard case let .success(value) = result else {
                return .failure(APIError.jsonSerialization(error: result.error!))
            }

            guard let response = response, let responseObject = T.collection(response, representation: value) else {
                return .failure(APIError.objectSerialization(reason: "JSON could not be serialized: \(value)"))
            }
             return .success(responseObject)
        }
        return response(queue: queue, responseSerializer: responseSerializer, completionHandler: completionHandler)
    }

    public func response(_ completionHandler: @escaping (DataResponse<Void>) -> Void) -> Self {
        return responseString(encoding: String.Encoding.utf8) { response in
            if response.result.isSuccess {
                completionHandler(DataResponse<Void>(request: response.request,
                                                         response: response.response,
                                                             data: response.data,
                                                           result: Result.success()))
            } else {
                completionHandler(DataResponse<Void>(request: response.request,
                                                         response: response.response,
                                                             data: response.data,
                                                           result: Result.failure(response.result.error!)))
            }
        }
    }
}

public protocol ParameterEncodable {
    func toParameters() -> [String: Any]
}

public extension Alamofire.ParameterEncoding {
    func encode(_ URLRequest: URLRequestConvertible, with: ParameterEncodable?) throws -> URLRequest {
        return try encode(URLRequest, with: with?.toParameters())
    }
}

extension URLRequest {
    mutating func addParam(_ params: Any) -> URLRequest {
        let data = try? JSONSerialization.data(withJSONObject: params, options: JSONSerialization.WritingOptions.prettyPrinted)
        self.httpBody = data
        self.setValue("application/json", forHTTPHeaderField: "Content-Type")
        return self
    }
}

open class CloudAPIClient {
    public enum Target {
        static let sandboxBaseUrl    = "http://sandbox.feedly.com"
        static let productionBaseUrl = "http://cloud.feedly.com"

        case sandbox
        case production
        case custom(String)
        public var baseUrl: String {
            get {
                switch self {
                case .sandbox:             return Target.sandboxBaseUrl
                case .production:          return Target.productionBaseUrl
                case .custom(let baseUrl): return baseUrl
                }
            }
        }
    }

    open var manager: Alamofire.SessionManager!
    open var target: Target

    public init(target: Target) {
        self.target = target
        manager     = Alamofire.SessionManager(configuration: URLSessionConfiguration.ephemeral)
    }

    open func setAccessToken(_ accessToken: AccessToken?) {
        let configuration = manager.session.configuration
        var headers = configuration.httpAdditionalHeaders ?? [:]
        if let token = accessToken {
            headers["Authorization"] = "Bearer \(token)"
        } else {
            headers.removeValue(forKey: "Authorization")
        }
        configuration.httpAdditionalHeaders = headers
        manager = Alamofire.SessionManager(configuration: configuration)
    }

    public enum Router: URLRequestConvertible {
        var comma: String { return "," }
        func urlEncode(_ string: String) -> String {
            return string.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)!
        }
        // Categories API
        case fetchCategories(Target)
        case updateCategory(Target, String, String)
        case deleteCategory(Target, String)
        // Entries API
        case fetchEntry(Target, String)
        case fetchEntries(Target, [String])
        case createEntry(Target, Entry)
        // Feeds API
        case fetchFeed(Target, String)
        case fetchFeeds(Target, [String])
        // Markers API
        case fetchUnreadCounts(Target, UnreadCountsParams)
        case markAs(Target, MarkerParam)
        case fetchLatestReadOperations(Target, Int64?)
        case fetchLatestTaggedEntryIds(Target, Int64?)
        // Preferences API
        case fetchPreferences(Target)
        case updatePreferences(Target, [String:String])
        // Profile API
        case fetchProfile(Target)
        case updateProfile(Target, [String:Any])
        // Search API
        case searchFeeds(Target, SearchQueryOfFeed)
        case searchContentOfStream(Target, String, String, SearchQueryOfContent)
        // Streams API
        case fetchEntryIds(Target, String, PaginationParams)
        case fetchContents(Target, String, PaginationParams)
        // Subscriptions API
        case fetchSubscriptions(Target)
        case subscribeTo(Target, Subscription)
        case updateSubscription(Target, Subscription)
        case unsubscribeTo(Target, String)
        // Tags API
        case fetchTags(Target)
        case tagEntry(Target, [String], String)
        case tagEntries(Target, [String], [String])
        case changeTagLabel(Target, String, String)
        case untagEntries(Target, [String], [String])
        case deleteTags(Target, [String])
        // Custom
        case api(API)

        var method: Alamofire.HTTPMethod {
            switch self {
                // Categories API
            case .fetchCategories:           return .get
            case .updateCategory:            return .post
            case .deleteCategory:            return .delete
                // Entries API
            case .fetchEntry:                return .get
            case .fetchEntries:              return .post
            case .createEntry:               return .post
                // Feeds API
            case .fetchFeed:                 return .get
            case .fetchFeeds:                return .post
                // Markers API
            case .fetchUnreadCounts:         return .get
            case .markAs:                    return .post
            case .fetchLatestReadOperations: return .get
            case .fetchLatestTaggedEntryIds: return .get
            // Preferences API
            case .fetchPreferences:           return .get
            case .updatePreferences:          return .post
                // Profile API
            case .fetchProfile:              return .get
            case .updateProfile:             return .get
                //Search API
            case .searchFeeds:               return .get
            case .searchContentOfStream:     return .get
                //Streams API
            case .fetchEntryIds:             return .get
            case .fetchContents:             return .get
                // Subscriptions API
            case .fetchSubscriptions:        return .get
            case .subscribeTo:               return .post
            case .updateSubscription:        return .post
            case .unsubscribeTo:             return .delete
                // Tags API
            case .fetchTags:                 return .get
            case .tagEntry:                  return .put
            case .tagEntries:                return .put
            case .changeTagLabel:            return .post
            case .untagEntries:              return .delete
            case .deleteTags:                return .delete
                // Custom
            case .api(let api):              return api.method
            }
        }

        var url: String {
            switch self {
                // Categories API
            case .fetchCategories(let target):                   return target.baseUrl + "/v3/categories"
            case .updateCategory(let target, let categoryId, _): return target.baseUrl + "/v3/categories/\(urlEncode(categoryId))"
            case .deleteCategory(let target, let categoryId):    return target.baseUrl + "/v3/categories/\(urlEncode(categoryId))"
                // Entries API
            case .fetchEntry(let target, let entryId):           return target.baseUrl + "/v3/entries/\(urlEncode(entryId))"
            case .fetchEntries(let target, _):                   return target.baseUrl + "/v3/entries/.mget"
            case .createEntry(let target, _):                    return target.baseUrl + "/v3/entries/"
                // Feeds API
            case .fetchFeed(let target, let feedId):             return target.baseUrl + "/v3/feeds/\(urlEncode(feedId))"
            case .fetchFeeds(let target, _):                     return target.baseUrl + "/v3/feeds/.mget"
                // Markers API
            case .fetchUnreadCounts(let target, _):              return target.baseUrl + "/v3/markers/counts"
            case .markAs(let target, _):                         return target.baseUrl + "/v3/markers"

            case .fetchLatestReadOperations(let target, _):      return target.baseUrl + "/v3/markers/reads"
            case .fetchLatestTaggedEntryIds(let target, _):      return target.baseUrl + "/v3/markers/tags"
            // Preferences API
            case .fetchPreferences(let target):                   return target.baseUrl + "/v3/preferences"
            case .updatePreferences(let target, _):               return target.baseUrl + "/v3/preferences"
                // Profile API
            case .fetchProfile(let target):                      return target.baseUrl + "/v3/profile"
            case .updateProfile(let target, _):                  return target.baseUrl + "/v3/profile"
                //Search API
            case .searchFeeds(let target, _):                    return target.baseUrl + "/v3/search/feeds"
            case .searchContentOfStream(let target, let streamId, let searchTerm, _):
                                                                 return target.baseUrl + "/v3/search/" + urlEncode(streamId) + "/contents?query=" + urlEncode(searchTerm)
                // Streams API
            case .fetchEntryIds(let target, let streamId,  _):   return target.baseUrl + "/v3/streams/" + urlEncode(streamId) + "/ids"
            case .fetchContents(let target, let streamId, _):    return target.baseUrl + "/v3/streams/" + urlEncode(streamId) + "/contents"
                // Subscriptions API
            case .fetchSubscriptions(let target):                return target.baseUrl + "/v3/subscriptions"
            case .subscribeTo(let target, _):                    return target.baseUrl + "/v3/subscriptions"
            case .updateSubscription(let target, _):             return target.baseUrl + "/v3/subscriptions"
            case .unsubscribeTo(let target, let feedId):         return target.baseUrl + "/v3/subscriptions/\(urlEncode(feedId))"
                // Tags API
            case .fetchTags(let target):                         return target.baseUrl + "/v3/tags"
            case .tagEntry(let target, let tagIds, _):
                let tids = tagIds.map({ self.urlEncode($0) }).joined(separator: ",")
                                                                 return target.baseUrl + "/v3/tags/\(tids))"
            case .tagEntries(let target, let tagIds, _):
                let tids = tagIds.map({ self.urlEncode($0) }).joined(separator: ",")
                                                                 return target.baseUrl + "/v3/tags/\(tids)"
            case .changeTagLabel(let target, let tagId, _):      return target.baseUrl + "/v3/tags/\(urlEncode(tagId))"
            case .untagEntries(let target, let tagIds, _):
                let tids = tagIds.map({   self.urlEncode($0) }).joined(separator: ",")
                                                                 return target.baseUrl + "/v3/tags/\(tids)"
            case .deleteTags(let target, let tagIds):
                let tids = tagIds.map({ self.urlEncode($0) }).joined(separator: ",")
                                                                 return target.baseUrl + "/v3/tags/\(tids)"
                // Custom
            case .api(let api):                                  return api.url
            }
        }
        // MARK: URLRequestConvertible
        // swiftlint:disable cyclomatic_complexity
        public func asURLRequest() throws -> URLRequest {
            let U =  URLEncoding.default
            let J = JSONEncoding.default

            var req = try URLRequest(url:  URL(string: url)!, method: HTTPMethod(rawValue: method.rawValue)!)
            switch self {
                // Categories API
            case .fetchCategories, .deleteCategory:             return req
            case .updateCategory(_, _, let label):              return try J.encode(req, with: ["label": label])
                // Entries API
            case .fetchEntry:                                   return req
            case .fetchEntries(_, let entryIds):                return req.addParam(entryIds)
            case .createEntry(_, let entry):                    return try J.encode(req, with: entry)
                // Feeds API
            case .fetchFeed:                                    return req
            case .fetchFeeds(_, let feedIds):                   return req.addParam(feedIds)
                // Markers API
            case .fetchUnreadCounts(_, let unreadCountsParams): return try U.encode(req, with: unreadCountsParams)
            case .markAs(_, let params):                        return try J.encode(req, with: params)
            case .fetchLatestReadOperations(_, let newerThan):
                if let n = newerThan {
                    return try J.encode(req, with: ["newerThan": NSNumber(value: n as Int64)])
                }
                return req
            case .fetchLatestTaggedEntryIds(_, let newerThan):
                if let n = newerThan {
                    return try J.encode(req, with: ["newerThan": NSNumber(value: n as Int64)])
                }
                return req
                // Preferences API
            case .fetchPreferences:                          return req
            case .updatePreferences(_, let params):          return try J.encode(req, with: params)
                // Profile API
            case .fetchProfile:                              return req
            case .updateProfile(_, let params):              return try U.encode(req, with: params)
                // Search API
            case .searchFeeds(_, let query):                 return try U.encode(req, with: query)
            case .searchContentOfStream(_, _, _, let query): return try U.encode(req, with: query)
                //Streams API
            case .fetchEntryIds(_, _, let params):           return try U.encode(req, with: params)
            case .fetchContents(_, _, let params):           return try U.encode(req, with: params)
                // Subscriptions API
            case .fetchSubscriptions, .unsubscribeTo:        return req
            case .subscribeTo(_, let subscription):          return try J.encode(req, with: subscription)
            case .updateSubscription(_, let subscription):   return try J.encode(req, with: subscription)
                // Tags API
            case .fetchTags, .deleteTags:                    return req
            case .tagEntry(_, _, let entryId):               return try J.encode(req, with: ["entryId": entryId])
            case .tagEntries(_, _, let entryIds):            return try J.encode(req, with: ["entryIds": entryIds])
            case .changeTagLabel(_, _, let label):           return try J.encode(req, with: ["label": label])
            case .untagEntries(_, _, let entryIds):          return try J.encode(req, with: ["entryIds": entryIds])
                // Custom
            case .api(let api):                              return try api.asURLRequest()
            }
        }
    }
}
