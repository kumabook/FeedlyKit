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
    public func fetchFeed(feedId: String, completionHandler: (NSURLRequest, NSHTTPURLResponse?, Feed?, NSError?) -> Void) -> Self {
        Alamofire.request(Router.FetchFeed(feedId)).responseObject(completionHandler)
        return self
    }
    /**
    Get the metadata for a list of feeds
    POST /v3/feeds/.mget
    */
    public func fetchFeeds(feedIds: [String], completionHandler: (NSURLRequest, NSHTTPURLResponse?, [Feed]?, NSError?) -> Void) -> Self {
        Alamofire.request(Router.FetchFeeds(feedIds)).responseCollection(completionHandler)
        return self
    }
}