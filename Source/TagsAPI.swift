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
    public func fetchTags(completionHandler: (NSURLRequest, NSHTTPURLResponse?, [Tag]?, NSError?) -> Void) -> Request {
        return manager.request(Router.FetchTags).validate().responseCollection(completionHandler)
    }
    /**
        Tag an existing entry
        PUT /v3/tags/:tagId1,:tagId2
        (Authorization is required)
    */
    public func tagEntry(tagIds: [String], entryId: String, completionHandler:(NSURLRequest, NSHTTPURLResponse?, NSError?) -> Void) -> Request {
        return manager.request(Router.TagEntry(tagIds, entryId)).validate().response(completionHandler)
    }
    
    /**
        Tag multiple entries
        PUT /v3/tags/:tagId1,:tagId2
    */
    public func tagEntries(tagIds: [String], entryIds: [String], completionHandler:(NSURLRequest, NSHTTPURLResponse?, NSError?) -> Void) -> Request {
        return manager.request(Router.TagEntries(tagIds, entryIds)).validate().response(completionHandler)
    }
    
    /**
        Change a tag label
        POST /v3/tags/:tagId
    */
    public func changeTagLabel(tagId: String, label: String, completionHandler:(NSURLRequest, NSHTTPURLResponse?, NSError?) -> Void) -> Request {
        return manager.request(Router.ChangeTagLabel(tagId, label)).validate().response(completionHandler)
    }
    /**
        Untag multiple entries
        DELETE /v3/tags/:tagId1,tagId2/:entryId1,entryId2
        (Authorization is required)
    */
    public func untagEntries(tagIds: [String], entryIds: [String], completionHandler:(NSURLRequest, NSHTTPURLResponse?, NSError?) -> Void) -> Request {
        return manager.request(Router.UntagEntries(tagIds, entryIds)).validate().response(completionHandler)
    }
    
    /**
        Delete tags
        DELETE /v3/tags/:tagId1,:tagId2
        (Authorization is required)
    */
    public func deleteTags(tagIds: [String], completionHandler:(NSURLRequest, NSHTTPURLResponse?, NSError?) -> Void) -> Request {
        return manager.request(Router.DeleteTags(tagIds)).validate().response(completionHandler)
    }
}
