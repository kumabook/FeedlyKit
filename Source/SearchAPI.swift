//
//  SearchAPI.swift
//  FeedlyKit
//
//  Created by Hiroki Kumamoto on 2/11/15.
//  Copyright (c) 2015 Hiroki Kumamoto. All rights reserved.
//

import Foundation
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
        if let c = count  { params["count"]  = c }
        if let l = locale { params["locale"] = l }
        return params
    }
}

open class SearchQueryOfContent: ParameterEncodable {
    public enum Field: String {
        case all
        case title
        case author
        case keywords
    }
    public enum Embedded: String {
        case audio
        case video
        case doc
        case any
    }
    public enum Engagement: String {
        case medium
        case high
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
        if let c   = count        { params["count"]      = c as AnyObject? }
        if let n   = newerThan    { params["newerThan"]  = n as AnyObject? }
        if let co  = continuation { params["count"]      = co as AnyObject? }
        if let f   = fields       { params["fields"]     = f.map({ $0.rawValue }).joined(separator: ",") as AnyObject? }
        if let emb = embedded     { params["embedded"]   = emb.rawValue as AnyObject? }
        if let eng = engagement   { params["engagement"] = eng.rawValue as AnyObject? }
        if let l   = locale       { params["locale"]     = l as AnyObject? }
        return params
    }
}

open class SearchResultFeeds: ResponseObjectSerializable {
    public let hint: String
    public let related: [String]
    public let results: [Feed]
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
