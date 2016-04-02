//
//  MarkersAPI.swift
//  FeedlyKit
//
//  Created by Hiroki Kumamoto on 1/23/15.
//  Copyright (c) 2015 Hiroki Kumamoto. All rights reserved.
//

import Alamofire
import SwiftyJSON

public class UnreadCountsParams: ParameterEncodable {
    public var autoRefresh: Bool?
    public var newerThan: Int64?
    public var streamId: String?
    public init(autoRefresh: Bool?, newerThan: Int64?, streamId: String?) {
        self.autoRefresh = autoRefresh
        self.newerThan   = newerThan
        self.streamId    = streamId
    }
    public func toParameters() -> [String: AnyObject] {
        var params: [String:AnyObject] = [:]
        if autoRefresh != nil { params["autorefresh"] = autoRefresh! ? "true" : "false" }
        if newerThan   != nil { params["newerThan"]   = NSNumber(longLong: newerThan!) }
        if streamId    != nil { params["streamId"]    = streamId }
        return params
    }
}

extension CloudAPIClient {
    /**
        Get the list of unread counts
        GET /v3/markers/counts
    */
    public func fetchUnreadCounts(params: UnreadCountsParams, completionHandler: (Response<UnreadCounts, NSError>) -> Void) -> Request {
        return manager.request(Router.FetchUnreadCounts(target, params))
                      .validate()
                      .responseObject(completionHandler)
    }

    /**
        Mark one or multiple articles as read
        POST /v3/markers
    */
    public func markEntriesAsRead(itemIds: [String], completionHandler: (Response<Void, NSError>) -> Void) -> Request {
        let marker = MarkerParam(action: .MarkAsRead, itemType: .Entry, itemIds: itemIds)
        return manager.request(Router.MarkAs(target, marker)).validate().response(completionHandler)
    }

    /**
        Keep one or multiple articles as unread
        POST /v3/markers
    */
    public func keepEntriesAsUnread(itemIds: [String], completionHandler: (Response<Void, NSError>) -> Void) -> Request {
        let marker = MarkerParam(action: .KeepAsUnread, itemType: .Entry, itemIds: itemIds)
        return manager.request(Router.MarkAs(target, marker)).validate().response(completionHandler)
    }

    /**
        Mark a feed as read
        POST /v3/markers
    */
    public func markFeedsAsRead(itemIds: [String], completionHandler: (Response<Void, NSError>) -> Void) -> Request {
        let marker = MarkerParam(action: .MarkAsRead, itemType: .Feed, itemIds: itemIds)
        return manager.request(Router.MarkAs(target, marker)).validate().response(completionHandler)
    }

    /**
        Mark a category as read
        POST /v3/markers
    */
    public func markCategoriesAsRead(itemIds: [String], completionHandler: (Response<Void, NSError>) -> Void) -> Request {
        let marker = MarkerParam(action: .MarkAsRead, itemType: .Category, itemIds: itemIds)
        return manager.request(Router.MarkAs(target, marker)).validate().response(completionHandler)
    }

    /**
        Undo mark as read
        POST /v3/markers
    */
    public func undoMarkAsRead(itemType: Marker.ItemType, itemIds: [String], completionHandler: (Response<Void, NSError>) -> Void) -> Request {
        let marker = MarkerParam(action: .UndoMarkAsRead, itemType: itemType, itemIds: itemIds)
        return manager.request(Router.MarkAs(target, marker)).validate().response(completionHandler)
    }

    /**
        Mark one or multiple articles as saved
        POST /v3/markers
    */
    public func markEntriesAsSaved(itemIds: [String], completionHandler: (Response<Void, NSError>) -> Void) -> Request {
        let marker = MarkerParam(action: .MarkAsSaved, itemType: .Entry, itemIds: itemIds)
        return manager.request(Router.MarkAs(target, marker)).validate().response(completionHandler)
    }

    /**
        Mark one or multiple articles as unsaved
        POST /v3/markers
    */
    public func markEntriesAsUnsaved(itemIds: [String], completionHandler: (Response<Void, NSError>) -> Void) -> Request {
        let marker = MarkerParam(action: .MarkAsUnsaved, itemType: .Entry, itemIds: itemIds)
        return manager.request(Router.MarkAs(target, marker)).validate().response(completionHandler)
    }

    /**
        Get the latest read operations (to sync local cache)
        GET /v3/markers/reads
    */
    public func fetchLatestReadOperations(newerThan: Int64?, completionHandler: (Response<ReadOperations, NSError>) -> Void) -> Request {
        return manager.request(Router.FetchLatestReadOperations(target, newerThan)).validate().responseObject(completionHandler)
    }

    /**
        Get the latest tagged entry ids
        GET /v3/markers/tags
    */
    public func fetchLatestTaggedEntryIds(newerThan: Int64?, completionHandler: (Response<TaggedEntryIds, NSError>) -> Void) -> Request {
        return manager.request(Router.FetchLatestTaggedEntryIds(target, newerThan)).validate().responseObject(completionHandler)
    }
}