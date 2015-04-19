//
//  EntriesAPI.swift
//  FeedlyKit
//
//  Created by Hiroki Kumamoto on 1/20/15.
//  Copyright (c) 2015 Hiroki Kumamoto. All rights reserved.
//

import Alamofire
import SwiftyJSON

extension CloudAPIClient {
    /**
        Get the content of an entry
        GET /v3/entries/:entryId
        (Authorization is optional)
    */
    public func fetchEntry(entryId: String, completionHandler: (NSURLRequest, NSHTTPURLResponse?, Entry?, NSError?) -> Void) -> Request {
        return manager.request(Router.FetchEntry(target, entryId)).validate().responseObject(completionHandler)
    }
    
    /**
        Get the content for a dynamic list of entries
        POST /v3/entries/.mget
        (Authorization is optional)
    */
    public func fetchEntries(entryIds: [String], completionHandler: (NSURLRequest, NSHTTPURLResponse?, [Entry]?, NSError?) -> Void) -> Request {
        return manager.request(Router.FetchEntries(target, entryIds)).validate().responseCollection(completionHandler)
    }
    
    /**
        Create and tag an entry
        POST /v3/entries/
        (Authorization is required)
    */
    public func createEntry(entry: Entry, completionHandler: (NSURLRequest, NSHTTPURLResponse?, [String]?, NSError?) -> Void) -> Request {
        return manager.request(Router.CreateEntry(target, entry)).validate()
    }
}
