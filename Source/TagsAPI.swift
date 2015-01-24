//
//  TagsAPI.swift
//  FeedlyKit
//
//  Created by Hiroki Kumamoto on 1/20/15.
//  Copyright (c) 2015 Hiroki Kumamoto. All rights reserved.
//

import Alamofire
import SwiftyJSON

extension CloudAPIClient {
    /**
        Get the list of tags created by the user.
        GET /v3/tags
        (Authorization is required)
    */
    public func fetchTags(completionHandler: (NSURLRequest, NSHTTPURLResponse?, [Tag]?, NSError?) -> Void) -> Self {
        Alamofire.request(Router.FetchTags).responseCollection(completionHandler)
        return self
    }
    /**
        Tag an existing entry
        PUT /v3/tags/:tagId1,:tagId2
        (Authorization is required)
    */
    public func tagEntry(tagIds: [String], entryId: String, completionHandler:(NSURLRequest, NSHTTPURLResponse?, NSError?) -> Void) -> Self {
        Alamofire.request(Router.TagEntry(tagIds, entryId)).response(completionHandler)
        return self
    }
    
    /**
        Tag multiple entries
        PUT /v3/tags/:tagId1,:tagId2
    */
    public func tagEntries(tagIds: [String], entryIds: [String], completionHandler:(NSURLRequest, NSHTTPURLResponse?, NSError?) -> Void) -> Self {
        Alamofire.request(Router.TagEntries(tagIds, entryIds)).response(completionHandler)
        return self
    }
    
    /**
        Change a tag label
        POST /v3/tags/:tagId
    */
    public func changeTagLabel(tagId: String, label: String, completionHandler:(NSURLRequest, NSHTTPURLResponse?, NSError?) -> Void) -> Self {
        Alamofire.request(Router.ChangeTagLabel(tagId, label)).response(completionHandler)
        return self
    }
    /**
        Untag multiple entries
        DELETE /v3/tags/:tagId1,tagId2/:entryId1,entryId2
        (Authorization is required)
    */
    public func untagEntries(tagIds: [String], entryIds: [String], completionHandler:(NSURLRequest, NSHTTPURLResponse?, NSError?) -> Void) -> Self {
        Alamofire.request(Router.UntagEntries(tagIds, entryIds)).response(completionHandler)
        return self
    }
    
    /**
        Delete tags
        DELETE /v3/tags/:tagId1,:tagId2
        (Authorization is required)
    */
    public func deleteTags(tagIds: [String], completionHandler:(NSURLRequest, NSHTTPURLResponse?, NSError?) -> Void) -> Self {
        Alamofire.request(Router.DeleteTags(tagIds)).response(completionHandler)
        return self
    }
}
