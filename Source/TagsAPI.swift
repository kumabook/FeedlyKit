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
    public func fetchTags(_ completionHandler: @escaping (DataResponse<[Tag]>) -> Void) -> Request {
        return manager.request(Router.fetchTags(target)).validate().responseCollection(completionHandler: completionHandler)
    }
    /**
        Tag an existing entry
        PUT /v3/tags/:tagId1,:tagId2
        (Authorization is required)
    */
    public func tagEntry(_ tagIds: [String], entryId: String, completionHandler: @escaping (DefaultDataResponse) -> Void) -> Request {
        return manager.request(Router.tagEntry(target, tagIds, entryId)).validate().response(completionHandler: completionHandler)
    }
    
    /**
        Tag multiple entries
        PUT /v3/tags/:tagId1,:tagId2
    */
    public func tagEntries(_ tagIds: [String], entryIds: [String], completionHandler: @escaping (DefaultDataResponse) -> Void) -> Request {
        return manager.request(Router.tagEntries(target, tagIds, entryIds)).validate().response(completionHandler: completionHandler)
    }
    
    /**
        Change a tag label
        POST /v3/tags/:tagId
    */
    public func changeTagLabel(_ tagId: String, label: String, completionHandler: @escaping (DefaultDataResponse) -> Void) -> Request {
        return manager.request(Router.changeTagLabel(target, tagId, label)).validate().response(completionHandler: completionHandler)
    }
    /**
        Untag multiple entries
        DELETE /v3/tags/:tagId1,tagId2/:entryId1,entryId2
        (Authorization is required)
    */
    public func untagEntries(_ tagIds: [String], entryIds: [String], completionHandler: @escaping (DefaultDataResponse) -> Void) -> Request {
        return manager.request(Router.untagEntries(target, tagIds, entryIds)).validate().response(completionHandler: completionHandler)
    }
    
    /**
        Delete tags
        DELETE /v3/tags/:tagId1,:tagId2
        (Authorization is required)
    */
    public func deleteTags(_ tagIds: [String], completionHandler: @escaping (DefaultDataResponse) -> Void) -> Request {
        return manager.request(Router.deleteTags(target, tagIds)).validate().response(completionHandler: completionHandler)
    }
}
