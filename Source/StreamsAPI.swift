//
//  StreamsAPI.swift
//  FeedlyKit
//
//  Created by Hiroki Kumamoto on 1/20/15.
//  Copyright (c) 2015 Hiroki Kumamoto. All rights reserved.
//

import Alamofire
import SwiftyJSON

extension CloudAPIClient {
    /**
        Get a list of entry ids for a specific stream
        GET /v3/streams/:streamId/ids
          or
        GET /v3/streams/ids?streamId=:streamId
        (Authorization is optional; it is required for category and tag streams)
        TODO
    */
    public func fetchEntryIds(streamId: String, completionHandler: (NSURLRequest, NSHTTPURLResponse?, PaginatedCollection<String>?, NSError?) -> Void) -> Self {
        Alamofire.request(Router.FetchEntryIds(streamId)).responseObject(completionHandler)
        return self
    }
    
    /**
        Get the content of a stream
        GET /v3/streams/:streamId/contents
           or
        GET /v3/streams/contents?streamId=:streamId
        (Authorization is optional; it is required for category and tag streams)
        TODO
    */
    public func fetchContents(streamId: String, completionHandler: (NSURLRequest, NSHTTPURLResponse?, PaginatedCollection<Entry>?, NSError?) -> Void) -> Self {
        Alamofire.request(Router.FetchContents(streamId)).responseObject(completionHandler)
        return self
    }
}
