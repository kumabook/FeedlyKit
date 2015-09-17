//
//  TopicsAPI.swift
//  FeedlyKit
//
//  Created by Hiroki Kumamoto on 1/20/15.
//  Copyright (c) 2015 Hiroki Kumamoto. All rights reserved.
//

import Alamofire
import SwiftyJSON

extension CloudAPIClient {
    /**
        Get the list of topics the user has added to their feedly
        GET /v3/topics
        (Authorization is required)
    */
    public func fetchTopics(completionHandler: (NSURLRequest?, NSHTTPURLResponse?, Result<[Topic]>) -> Void) -> Request {
        return manager.request(Router.FetchTopics(target)).validate().responseCollection(completionHandler)
    }
    
    /**
        Add a topic to the user feedly account
        POST /v3/topics
        (Authorization is required)
    */
    public func addTopic(interest: String, topicId: String, completionHandler: (NSURLRequest?, NSHTTPURLResponse?, Result<Void>) -> Void) -> Request {
        return manager.request(Router.AddTopic(target, interest, topicId)).validate().response(completionHandler)
    }
    
    /**
        Update an existing topic
        POST /v3/topics
        (Authorization is required)
    */
    public func updateTopic(interest: String, topicId: String, completionHandler: (NSURLRequest?, NSHTTPURLResponse?, Result<Void>) -> Void) -> Request {
        return manager.request(Router.UpdateTopic(target, interest, topicId)).validate().response(completionHandler)
    }
    
    /**
        Remove a topic from a feedly account
        DELETE /v3/topics/:topicId
        (Authorization is required)
    */
    public func removeTopic(topicId: String, completionHandler: (NSURLRequest?, NSHTTPURLResponse?, Result<Void>) -> Void) -> Request {
        return manager.request(Router.RemoveTopic(target, topicId)).validate().response(completionHandler)
    }
}
