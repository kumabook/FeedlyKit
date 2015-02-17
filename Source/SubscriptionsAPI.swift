//
//  Subscriptions.swift
//  FeedlyKit
//
//  Created by Hiroki Kumamoto on 1/20/15.
//  Copyright (c) 2015 Hiroki Kumamoto. All rights reserved.
//

import Alamofire
import SwiftyJSON

extension CloudAPIClient {

    /**
        Get the user’s subscriptions
        GET /v3/subscriptions
        @param completionHandler handler function
        @return self
    */
    public func fetchSubscriptions(completionHandler: (NSURLRequest, NSHTTPURLResponse?, [Subscription]?, NSError?) -> Void) -> Request {
        return request(Router.FetchSubscriptions).responseCollection(completionHandler)
    }
    
    /**
        Subscribe to a feed
        POST /v3/subscriptions
    */
    public func subscribeTo(subscription: Subscription, completionHandler: (NSURLRequest, NSHTTPURLResponse?, NSError?) -> Void) -> Request {
        return request(Router.SubscribeTo(subscription)).validate().response(completionHandler)
    }
    /**
        Update an existing subscription
        POST /v3/subscriptions
    */
    public func updateSubscription(subscription: Subscription, completionHandler: (NSURLRequest, NSHTTPURLResponse?, NSError?) -> Void) -> Request {
        return request(Router.UpdateSubscription(subscription)).validate().response(completionHandler)
    }
    
    /**
        Unsubscribe from a feed
        DELETE /v3/subscriptions/:feedId
    */
    public func unsubscripbeTo(feedId: String, completionHandler: (NSURLRequest, NSHTTPURLResponse?, NSError?) -> Void) -> Request {
        return request(Router.UnsubscripbeTo(feedId)).validate().response(completionHandler)
    }
}
