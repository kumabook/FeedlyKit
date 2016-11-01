//
//  FeedAPI.swift
//  FeedlyKit
//
//  Created by Hiroki Kumamoto on 1/20/15.
//  Copyright (c) 2015 Hiroki Kumamoto. All rights reserved.
//

import Alamofire
import SwiftyJSON

extension CloudAPIClient {
    /**
    Get the metadata about a specific feed
    GET /v3/feeds/:feedId
    */
    public func fetchFeed(_ feedId: String, completionHandler: @escaping (DataResponse<Feed>) -> Void) -> Request {
        return manager.request(Router.fetchFeed(target, feedId)).validate().responseObject(completionHandler: completionHandler)
    }
    /**
    Get the metadata for a list of feeds
    POST /v3/feeds/.mget
    */
    public func fetchFeeds(_ feedIds: [String], completionHandler: @escaping (DataResponse<[Feed]>) -> Void) -> Request {
        return manager.request(Router.fetchFeeds(target, feedIds)).validate().responseCollection(completionHandler: completionHandler)
    }
}
