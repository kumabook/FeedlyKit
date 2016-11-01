//
//  StreamsAPI.swift
//  FeedlyKit
//
//  Created by Hiroki Kumamoto on 1/20/15.
//  Copyright (c) 2015 Hiroki Kumamoto. All rights reserved.
//

import Alamofire
import SwiftyJSON

open class PaginationParams: ParameterEncodable {
    open var count:        Int?
    open var ranked:       String?
    open var unreadOnly:   Bool?
    open var newerThan:    Int64?
    open var continuation: String?
    public init() {}
    open func toParameters() -> [String : Any] {
        var params: [String:AnyObject] = [:]
        if let _count        = count        { params["count"]        = _count as AnyObject? }
        if let _ranked       = ranked       { params["ranked"]       = _ranked as AnyObject? }
        if let _unreadOnly   = unreadOnly   { params["unreadOnly"]   = _unreadOnly ? "true" as AnyObject? : "false" as AnyObject? }
        if let _newerThan    = newerThan    { params["newerThan"]    = NSNumber(value: _newerThan as Int64) }
        if let _continuation = continuation { params["continuation"] = _continuation as AnyObject? }
        return params
    }
}

open class PaginatedEntryCollection: ResponseObjectSerializable {
    open fileprivate(set) var id:           String
    open fileprivate(set) var updated:      Int64?
    open fileprivate(set) var continuation: String?
    open fileprivate(set) var title:        String?
    open fileprivate(set) var direction:    String?
    open fileprivate(set) var alternate:    Link?
    open fileprivate(set) var items:        [Entry]
    required public init?(response: HTTPURLResponse, representation: Any) {
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

open class PaginatedIdCollection: ResponseObjectSerializable {
    open let continuation: String?
    open let ids:          [String]
    required public init?(response: HTTPURLResponse, representation: Any) {
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
    public func fetchEntryIds(_ streamId: String, paginationParams: PaginationParams, completionHandler: @escaping (DataResponse<PaginatedIdCollection>) -> Void) -> Request {
        return manager.request(Router.fetchEntryIds(target, streamId, paginationParams))
                      .validate()
                      .responseObject(completionHandler: completionHandler)
    }
    
    /**
        Get the content of a stream
        GET /v3/streams/:streamId/contents
           or
        GET /v3/streams/contents?streamId=:streamId
        (Authorization is optional; it is required for category and tag streams)
        TODO
    */
    public func fetchContents(_ streamId: String, paginationParams: PaginationParams, completionHandler: @escaping (DataResponse<PaginatedEntryCollection>) -> Void) -> Request {
        return manager.request(Router.fetchContents(target, streamId, paginationParams))
                      .validate()
                      .responseObject(completionHandler: completionHandler)
    }
}
