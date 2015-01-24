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
    public func fetchSubscriptions(completionHandler: (NSURLRequest, NSHTTPURLResponse?, [Subscription]?, NSError?) -> Void) -> Self {
        Alamofire.request(Router.FetchSubscriptions).responseCollection(completionHandler)
        return self
    }
    
    /**
        Subscribe to a feed
        POST /v3/subscriptions
    */
    public func subscribeTo(subscription: Subscription, completionHandler: (NSURLRequest, NSHTTPURLResponse?, NSError?) -> Void) -> Self {
        Alamofire.request(Router.SubscribeTo(subscription)).response(completionHandler)
        return self
    }
    /**
        Update an existing subscription
        POST /v3/subscriptions
    */
    public func updateSubscription(subscription: Subscription, completionHandler: (NSURLRequest, NSHTTPURLResponse?, NSError?) -> Void) -> Self {
        Alamofire.request(Router.UpdateSubscription(subscription)).response(completionHandler)
        return self
    }
    
    /**
        Unsubscribe from a feed
        DELETE /v3/subscriptions/:feedId
    */
    public func unsubscripbeTo(feedId: String, completionHandler: (NSURLRequest, NSHTTPURLResponse?, NSError?) -> Void) -> Self {
        Alamofire.request(Router.UnsubscripbeTo(feedId)).response(completionHandler)
        return self
    }
}
