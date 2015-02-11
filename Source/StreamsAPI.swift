//
//  StreamsAPI.swift
//  FeedlyKit
//
//  Created by Hiroki Kumamoto on 1/20/15.
//  Copyright (c) 2015 Hiroki Kumamoto. All rights reserved.
//

import Alamofire
import SwiftyJSON

@objc public class PaginatedEntryCollection: ResponseObjectSerializable {
    public let id:           String
    public let updated:      Int64?
    public let continuation: String?
    public let title:        String?
    public let direction:    String?
    public let alternate:    Link?
    public let items:        [Entry]
    required public init?(response: NSHTTPURLResponse, representation: AnyObject) {
        let json     = JSON(representation)
        id           = json["id"].stringValue
        updated      = json["update"].int64
        continuation = json["continuation"].string
        title        = json["title"].string
        direction    = json["direction"].string
        alternate    = json["alternate"].isEmpty ? nil : Link(json: json["alternate"])
        items        = json["items"].arrayValue.map( {Entry(json: $0)} )
    }
}

@objc public class PaginatedIdCollection: ResponseObjectSerializable {
    public let id:           String
    public let updated:      Int64?
    public let continuation: String?
    public let title:        String?
    public let direction:    String?
    public let alternate:    Link?
    public let items:        [String]
    required public init?(response: NSHTTPURLResponse, representation: AnyObject) {
        let json     = JSON(representation)
        id           = json["id"].stringValue
        updated      = json["update"].int64
        continuation = json["continuation"].string
        title        = json["title"].string
        direction    = json["direction"].string
        alternate    = json["alternate"].isEmpty ? nil : Link(json: json["alternate"])
        items        = json["items"].arrayValue.map( { $0.stringValue } )
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
    public func fetchEntryIds(streamId: String, paginationParams: PaginationParams, completionHandler: (NSURLRequest, NSHTTPURLResponse?, PaginatedIdCollection?, NSError?) -> Void) -> Self {
        Alamofire.request(Router.FetchEntryIds(streamId, paginationParams)).responseObject(completionHandler)
        return self
    }
    
    /**
        Get the content of a stream
        GET /v3/streams/:streamId/contents
           or
        GET /v3/streams/contents?streamId=:streamId
        (Authorization is optional; it is required for category and tag streams)
        TODO
    */
    public func fetchContents(streamId: String, paginationParams: PaginationParams, completionHandler: (NSURLRequest, NSHTTPURLResponse?, PaginatedEntryCollection?, NSError?) -> Void) -> Self {
        Alamofire.request(Router.FetchContents(streamId, paginationParams)).responseObject(completionHandler)
        return self
    }
}
