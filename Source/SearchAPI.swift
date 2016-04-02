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

public class SearchQueryOfFeed: ParameterEncodable {
    public var query:  String
    public var count:  Int?
    public var locale: Locale?
    public init(query: String) {
        self.query = query
    }
    public func toParameters() -> [String : AnyObject] {
        var params: [String:AnyObject] = ["query":query]
        if let _count  = count  { params["count"]  = _count }
        if let _locale = locale { params["locale"] = _locale }
        return params
    }
}

public class SearchQueryOfContent: ParameterEncodable {
    public enum Field: String {
        case All      = "all"
        case Title    = "title"
        case Author   = "author"
        case Keywords = "keywords"
    }
    public enum Embedded: String {
        case Audio = "audio"
        case Video = "video"
        case Doc   = "doc"
        case Any   = "any"
    }
    public enum Engagement: String {
        case Medium = "medium"
        case High   = "high"
    }
    public var query:        String
    public var count:        Int?
    public var newerThan:    Int?
    public var continuation: String?
    public var fields:       [Field]?
    public var embedded:     Embedded?
    public var engagement:   Engagement?
    public var locale:       Locale?
    public init(query: String) {
        self.query = query
    }
    public func toParameters() -> [String : AnyObject] {
        var params: [String:AnyObject] = ["query":query]
        if let _count        = count        { params["count"]      = _count }
        if let _newerThan    = newerThan    { params["newerThan"]  = _newerThan }
        if let _continuation = continuation { params["count"]      = _continuation }
        if let _fields       = fields       { params["fields"]     = _fields.map({ $0.rawValue }).joinWithSeparator(",") }
        if let _embedded     = embedded     { params["embedded"]   = _embedded.rawValue }
        if let _engagement   = engagement   { params["engagement"] = _engagement.rawValue }
        if let _locale       = locale       { params["locale"]     = _locale }
        return params
    }
}

public class SearchResultFeeds: ResponseObjectSerializable {
    public let hint: String
    public let related: [String]
    public let results: [Feed]
    @objc required public convenience init?(response: NSHTTPURLResponse, representation: AnyObject) {
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
    public func searchFeeds(query: SearchQueryOfFeed, completionHandler: (Response<SearchResultFeeds, NSError>) -> Void) -> Request {
        return manager.request(Router.SearchFeeds(target, query)).validate().responseObject(completionHandler)
    }

    /**
        Search the content of a stream
        GET /v3/search/:streamId/contents?query=:searchTerm
    */
    public func searchContentOfStream(streamId: String, searchTerm: String, query: SearchQueryOfContent, completionHandler: (Response<PaginatedEntryCollection, NSError>) -> Void) -> Request {
        return manager.request(Router.SearchContentOfStream(target, streamId, searchTerm, query))
                      .validate()
                      .responseObject(completionHandler)
    }
}