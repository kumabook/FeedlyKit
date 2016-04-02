//
//  StreamsAPI.swift
//  FeedlyKit
//
//  Created by Hiroki Kumamoto on 1/20/15.
//  Copyright (c) 2015 Hiroki Kumamoto. All rights reserved.
//

import Alamofire
import SwiftyJSON

public class PaginationParams: ParameterEncodable {
    public var count:        Int?
    public var ranked:       String?
    public var unreadOnly:   Bool?
    public var newerThan:    Int64?
    public var continuation: String?
    public init() {}
    public func toParameters() -> [String : AnyObject] {
        var params: [String:AnyObject] = [:]
        if let _count        = count        { params["count"]        = _count }
        if let _ranked       = ranked       { params["ranked"]       = _ranked }
        if let _unreadOnly   = unreadOnly   { params["unreadOnly"]   = _unreadOnly ? "true" : "false" }
        if let _newerThan    = newerThan    { params["newerThan"]    = NSNumber(longLong: _newerThan) }
        if let _continuation = continuation { params["continuation"] = _continuation }
        return params
    }
}

public class PaginatedEntryCollection: ResponseObjectSerializable {
    public private(set) var id:           String
    public private(set) var updated:      Int64?
    public private(set) var continuation: String?
    public private(set) var title:        String?
    public private(set) var direction:    String?
    public private(set) var alternate:    Link?
    public private(set) var items:        [Entry]
    required public init?(response: NSHTTPURLResponse, representation: AnyObject) {
        let json     = JSON(representation)
        id           = json["id"].stringValue
        updated      = json["updated"].int64
        continuation = json["continuation"].string
        title        = json["title"].string
        direction    = json["direction"].string
        alternate    = json["alternate"].isEmpty ? nil : Link(json: json["alternate"])
        items        = json["items"].arrayValue.map( {Entry(json: $0)} )
    }
}

public class PaginatedIdCollection: ResponseObjectSerializable {
    public let continuation: String?
    public let ids:          [String]
    required public init?(response: NSHTTPURLResponse, representation: AnyObject) {
        let json     = JSON(representation)
        continuation = json["continuation"].string
        ids          = json["ids"].arrayValue.map( { $0.stringValue } )
    }
}

extension CloudAPIClient {
    /**
        Get a list of entry ids for a specific stream
        GET /v3/streams/:streamId/ids
          or
        GET /v3/streams/ids?streamId=:streamId
        (Authorization is optional; it is required for category and tag streams)
        TODO
    */
    public func fetchEntryIds(streamId: String, paginationParams: PaginationParams, completionHandler: (Response<PaginatedIdCollection, NSError>) -> Void) -> Request {
        return manager.request(Router.FetchEntryIds(target, streamId, paginationParams))
                      .validate()
                      .responseObject(completionHandler)
    }
    
    /**
        Get the content of a stream
        GET /v3/streams/:streamId/contents
           or
        GET /v3/streams/contents?streamId=:streamId
        (Authorization is optional; it is required for category and tag streams)
        TODO
    */
    public func fetchContents(streamId: String, paginationParams: PaginationParams, completionHandler: (Response<PaginatedEntryCollection, NSError>) -> Void) -> Request {
        return manager.request(Router.FetchContents(target, streamId, paginationParams))
                      .validate()
                      .responseObject(completionHandler)
    }
}
