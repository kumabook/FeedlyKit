//
//  SearchAPI.swift
//  FeedlyKit
//
//  Created by Hiroki Kumamoto on 2/11/15.
//  Copyright (c) 2015 Hiroki Kumamoto. All rights reserved.
//

import Alamofire
import SwiftyJSON

public typealias Locale = String

open class SearchQueryOfFeed: ParameterEncodable {
    open var query:  String
    open var count:  Int?
    open var locale: Locale?
    public init(query: String) {
        self.query = query
    }
    open func toParameters() -> [String : Any] {
        var params: [String: Any] = ["query":query]
        if let _count  = count  { params["count"]  = _count }
        if let _locale = locale { params["locale"] = _locale }
        return params
    }
}

open class SearchQueryOfContent: ParameterEncodable {
    public enum Field: String {
        case all      = "all"
        case title    = "title"
        case author   = "author"
        case keywords = "keywords"
    }
    public enum Embedded: String {
        case audio    = "audio"
        case video    = "video"
        case doc      = "doc"
        case any      = "any"
    }
    public enum Engagement: String {
        case medium = "medium"
        case high   = "high"
    }
    open var query:        String
    open var count:        Int?
    open var newerThan:    Int?
    open var continuation: String?
    open var fields:       [Field]?
    open var embedded:     Embedded?
    open var engagement:   Engagement?
    open var locale:       Locale?
    public init(query: String) {
        self.query = query
    }
    open func toParameters() -> [String : Any] {
        var params: [String:AnyObject] = ["query":query as AnyObject]
        if let _count        = count        { params["count"]      = _count as AnyObject? }
        if let _newerThan    = newerThan    { params["newerThan"]  = _newerThan as AnyObject? }
        if let _continuation = continuation { params["count"]      = _continuation as AnyObject? }
        if let _fields       = fields       { params["fields"]     = _fields.map({ $0.rawValue }).joined(separator: ",") as AnyObject? }
        if let _embedded     = embedded     { params["embedded"]   = _embedded.rawValue as AnyObject? }
        if let _engagement   = engagement   { params["engagement"] = _engagement.rawValue as AnyObject? }
        if let _locale       = locale       { params["locale"]     = _locale as AnyObject? }
        return params
    }
}

open class SearchResultFeeds: ResponseObjectSerializable {
    open let hint: String
    open let related: [String]
    open let results: [Feed]
    @objc required public convenience init?(response: HTTPURLResponse, representation: Any) {
        let json = JSON(representation)
        self.init(json: json)
    }

    public init(json: JSON) {
        self.hint    = json["hint"].stringValue
        self.related = json["related"].arrayValue.map({ $0.stringValue })
        self.results = json["results"].arrayValue.map({ Feed(json:$0) })
    }
}

extension CloudAPIClient {
    /**
        Find feeds based on title, url or #topic
        GET /v3/search/feeds
    */
    public func searchFeeds(_ query: SearchQueryOfFeed, completionHandler: @escaping (DataResponse<SearchResultFeeds>) -> Void) -> Request {
        return manager.request(Router.searchFeeds(target, query)).validate().responseObject(completionHandler: completionHandler)
    }

    /**
        Search the content of a stream
        GET /v3/search/:streamId/contents?query=:searchTerm
    */
    public func searchContentOfStream(_ streamId: String, searchTerm: String, query: SearchQueryOfContent, completionHandler: @escaping (DataResponse<PaginatedEntryCollection>) -> Void) -> Request {
        return manager.request(Router.searchContentOfStream(target, streamId, searchTerm, query))
                      .validate()
                      .responseObject(completionHandler: completionHandler)
    }
}
