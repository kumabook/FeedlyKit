//
//  MixesAPI.swift
//  FeedlyKit
//
//  Created by Hiroki Kumamoto on 2017/05/31.
//  Copyright © 2017 Hiroki Kumamoto. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

open class MixParams: PaginationParams {
    open var hours:    Int?
    open var backfill: Bool?
    open var locale:   String?
    open override func toParameters() -> [String : Any] {
        var params: [String: Any] = [:]
        if let count        = count        { params["count"]        = count }
        if let unreadOnly   = unreadOnly   { params["unreadOnly"]   = unreadOnly ? "true" : "false" }
        if let hours        = hours        { params["hours"]        = NSNumber(value: hours) }
        if let backfill     = backfill     { params["backfill"]     = backfill }
        if let locale       = locale       { params["locale"]       = locale }
        if let newerThan    = newerThan    { params["newerThan"]    = NSNumber(value: newerThan) }
        if let continuation = continuation { params["continuation"] = continuation }
        return params
    }
}

extension CloudAPIClient {
    /**
     Get a mix of the most engaging content available in a stream
     Get the content of a stream
     GET /v3/mixes/:streamId/contents
     or
     GET /v3/mixes/contents?streamId=:streamId
     (Authorization is optional; it is required for category and tag streams)
     */
    public func fetchMix(_ streamId: String, paginationParams: MixParams, completionHandler: @escaping (DataResponse<PaginatedEntryCollection>) -> Void) -> Request {
        return manager.request(Router.fetchMix(target, streamId, paginationParams))
            .validate()
            .responseObject(completionHandler: completionHandler)
    }
}
