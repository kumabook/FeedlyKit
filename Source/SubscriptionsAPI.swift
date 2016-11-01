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
    public func fetchSubscriptions(_ completionHandler: @escaping (DataResponse<[Subscription]>) -> Void) -> Request {
        return manager.request(Router.fetchSubscriptions(target)).responseCollection(completionHandler: completionHandler)
    }
    
    /**
        Subscribe to a feed
        POST /v3/subscriptions
    */
    public func subscribeTo(_ feed: Feed, categories: [Category], completionHandler: @escaping (DefaultDataResponse) -> Void) -> Request {
        let subscription = Subscription(feed: feed, categories: categories)
        return subscribeTo(subscription, completionHandler: completionHandler)
    }

    public func subscribeTo(_ subscription: Subscription, completionHandler: @escaping (DefaultDataResponse) -> Void) -> Request {
        return manager.request(Router.subscribeTo(target, subscription)).validate().response(completionHandler: completionHandler)
    }

    /**
        Update an existing subscription
        POST /v3/subscriptions
    */
    public func updateSubscription(_ subscription: Subscription, completionHandler: @escaping (DefaultDataResponse) -> Void) -> Request {
        return manager.request(Router.updateSubscription(target, subscription)).validate().response(completionHandler: completionHandler)
    }
    
    /**
        Unsubscribe from a feed
        DELETE /v3/subscriptions/:feedId
    */
    public func unsubscribeTo(_ feedId: String, completionHandler: @escaping (DefaultDataResponse) -> Void) -> Request {
        return manager.request(Router.unsubscribeTo(target, feedId)).validate().response(completionHandler: completionHandler)
    }
}
