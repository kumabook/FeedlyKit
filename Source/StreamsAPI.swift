//
//  StreamsAPI.swift
//  FeedlyKit
//
//  Created by Hiroki Kumamoto on 1/20/15.
//  Copyright (c) 2015 Hiroki Kumamoto. All rights reserved.
//

import Foundation
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
        if let c  = count        { params["count"]        = c as AnyObject? }
        if let r  = ranked       { params["ranked"]       = r as AnyObject? }
        if let u  = unreadOnly   { params["unreadOnly"]   = u ? "true" as AnyObject? : "false" as AnyObject? }
        if let n  = newerThan    { params["newerThan"]    = NSNumber(value: n as Int64) }
        if let co = continuation { params["continuation"] = co as AnyObject? }
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
    required public convenience init?(response: HTTPURLResponse, representation: Any) {
        self.init(json: JSON(representation))
    }

    public init(json: JSON) {
        id           = json["id"].stringValue
        updated      = json["updated"].int64
        continuation = json["continuation"].string
        title        = json["title"].string
        direction    = json["direction"].string
        alternate    = json["alternate"].isEmpty ? nil : Link(json: json["alternate"])
        items        = json["items"].arrayValue.map({Entry(json: $0)})
    }

    public init(id: String, updated: Int64?, continuation: String?, title: String?, direction: String?, alternate: Link?, items: [Entry]) {
        self.id           = id
        self.updated      = updated
        self.continuation = continuation
        self.title        = title
        self.direction    = direction
        self.alternate    = alternate
        self.items        = items
    }
}

open class PaginatedIdCollection: ResponseObjectSerializable {
    public let continuation: String?
    public let ids:          [String]
    required public init?(response: HTTPURLResponse, representation: Any) {
        let json     = JSON(representation)
        continuation = json["continuation"].string
        ids          = json["ids"].arrayValue.map({ $0.stringValue })
    }
}

extension CloudAPIClient {
    /**
        Get a list of entry ids for a specific stream
        GET /v3/streams/:streamId/ids
          or
        GET /v3/streams/ids?streamId=:streamId
        (Authorization is optional; it is required for category and tag streams)
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
    */
    public func fetchContents(_ streamId: String, paginationParams: PaginationParams, completionHandler: @escaping (DataResponse<PaginatedEntryCollection>) -> Void) -> Request {
        return manager.request(Router.fetchContents(target, streamId, paginationParams))
                      .validate()
                      .responseObject(completionHandler: completionHandler)
    }
}
