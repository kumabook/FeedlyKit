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
    public func fetchSubscriptions(completionHandler: (Response<[Subscription], NSError>) -> Void) -> Request {
        return manager.request(Router.FetchSubscriptions(target)).responseCollection(completionHandler)
    }
    
    /**
        Subscribe to a feed
        POST /v3/subscriptions
    */
    public func subscribeTo(feed: Feed, categories: [Category], completionHandler: (Response<Void, NSError>) -> Void) -> Request {
        let subscription = Subscription(feed: feed, categories: categories)
        return subscribeTo(subscription, completionHandler: completionHandler)
    }

    public func subscribeTo(subscription: Subscription, completionHandler: (Response<Void, NSError>) -> Void) -> Request {
        return manager.request(Router.SubscribeTo(target, subscription)).validate().response(completionHandler)
    }

    /**
        Update an existing subscription
        POST /v3/subscriptions
    */
    public func updateSubscription(subscription: Subscription, completionHandler: (Response<Void, NSError>) -> Void) -> Request {
        return manager.request(Router.UpdateSubscription(target, subscription)).validate().response(completionHandler)
    }
    
    /**
        Unsubscribe from a feed
        DELETE /v3/subscriptions/:feedId
    */
    public func unsubscribeTo(feedId: String, completionHandler: (Response<Void, NSError>) -> Void) -> Request {
        return manager.request(Router.UnsubscribeTo(target, feedId)).validate().response(completionHandler)
    }
}
