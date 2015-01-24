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
    public func fetchEntry(entryId: String, completionHandler: (NSURLRequest, NSHTTPURLResponse?, Entry?, NSError?) -> Void) -> Self {
        Alamofire.request(Router.FetchEntry(entryId)).responseObject(completionHandler)
        return self
    }
    
    /**
        Get the content for a dynamic list of entries
        POST /v3/entries/.mget
        (Authorization is optional)
    */
    public func fetchEntries(entryIds: [String], completionHandler: (NSURLRequest, NSHTTPURLResponse?, [Entry]?, NSError?) -> Void) -> Self {
        Alamofire.request(Router.FetchEntries(entryIds)).responseCollection(completionHandler)
        return self
    }
    
    /**
        Create and tag an entry
        POST /v3/entries/
        (Authorization is required)
    */
    public func createEntry(entry: Entry, completionHandler: (NSURLRequest, NSHTTPURLResponse?, PaginatedCollection<String>?, NSError?) -> Void) -> Self {
        Alamofire.request(Router.CreateEntry(entry)).responseObject(completionHandler)
        return self
    }
}
