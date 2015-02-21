//
//  MarkersAPI.swift
//  FeedlyKit
//
//  Created by Hiroki Kumamoto on 1/23/15.
//  Copyright (c) 2015 Hiroki Kumamoto. All rights reserved.
//

import Alamofire
import SwiftyJSON

extension CloudAPIClient {
    /**
        Get the list of unread counts
        GET /v3/markers/counts
    */
    public func fetchUnreadCounts(info: (autorefresh: Bool?, newerThan: Int64?, streamId: String?),
                        completionHandler: (NSURLRequest, NSHTTPURLResponse?, UnreadCounts?, NSError?) -> Void) -> Request {
        return request(Router.FetchUnreadCounts(autorefresh: info.autorefresh,
                                                     newerThan: info.newerThan,
                                                      streamId: info.streamId))
                 .validate()
                 .responseObject(completionHandler)
    }

    /**
        Mark one or multiple articles as read
        POST /v3/markers
    */
    public func markEntriesAsRead(itemIds: [String], completionHandler: (NSURLRequest, NSHTTPURLResponse?, NSError?) -> Void) -> Request {
        let marker = MarkerParam(action: .MarkAsRead, itemType: .Entry, itemIds: itemIds)
        return request(Router.MarkAs(marker)).validate().response(completionHandler)
    }

    /**
        Keep one or multiple articles as unread
        POST /v3/markers
    */
    public func keepEntriesAsUnread(itemIds: [String], completionHandler: (NSURLRequest, NSHTTPURLResponse?, NSError?) -> Void) -> Request {
        let marker = MarkerParam(action: .KeepAsUnread, itemType: .Entry, itemIds: itemIds)
        return request(Router.MarkAs(marker)).validate().response(completionHandler)
    }

    /**
        Mark a feed as read
        POST /v3/markers
    */
    public func markFeedsAsRead(itemIds: [String], completionHandler: (NSURLRequest, NSHTTPURLResponse?, NSError?) -> Void) -> Request {
        let marker = MarkerParam(action: .MarkAsRead, itemType: .Feed, itemIds: itemIds)
        return request(Router.MarkAs(marker)).validate().response(completionHandler)
    }

    /**
        Mark a category as read
        POST /v3/markers
    */
    public func markCategoriesAsRead(itemIds: [String], completionHandler: (NSURLRequest, NSHTTPURLResponse?, NSError?) -> Void) -> Request {
        let marker = MarkerParam(action: .MarkAsRead, itemType: .Category, itemIds: itemIds)
        return request(Router.MarkAs(marker)).validate().response(completionHandler)
    }

    /**
        Undo mark as read
        POST /v3/markers
    */
    public func undoMarkAsRead(itemType: Marker.ItemType, itemIds: [String], completionHandler: (NSURLRequest, NSHTTPURLResponse?, NSError?) -> Void) -> Request {
        let marker = MarkerParam(action: .UndoMarkAsRead, itemType: itemType, itemIds: itemIds)
        return request(Router.MarkAs(marker)).validate().response(completionHandler)
    }

    /**
        Mark one or multiple articles as saved
        POST /v3/markers
    */
    public func markEntriesAsSaved(itemIds: [String], completionHandler: (NSURLRequest, NSHTTPURLResponse?, NSError?) -> Void) -> Request {
        let marker = MarkerParam(action: .MarkAsSaved, itemType: .Entry, itemIds: itemIds)
        return request(Router.MarkAs(marker)).validate().response(completionHandler)
    }

    /**
        Mark one or multiple articles as unsaved
        POST /v3/markers
    */
    public func markEntriesAsUnsaved(itemIds: [String], completionHandler: (NSURLRequest, NSHTTPURLResponse?, NSError?) -> Void) -> Request {
        let marker = MarkerParam(action: .MarkAsUnsaved, itemType: .Entry, itemIds: itemIds)
        return request(Router.MarkAs(marker)).validate().response(completionHandler)
    }

    /**
        Get the latest read operations (to sync local cache)
        GET /v3/markers/reads
    */
    public func fetchLatestReadOperations(newerThan: Int64?, completionHandler: (NSURLRequest, NSHTTPURLResponse?, ReadOperations?, NSError?) -> Void) -> Request {
        return request(Router.FetchLatestReadOperations(newerThan)).validate().responseObject(completionHandler)
    }

    /**
        Get the latest tagged entry ids
        GET /v3/markers/tags
    */
    public func fetchLatestTaggedEntryIds(newerThan: Int64?, completionHandler: (NSURLRequest, NSHTTPURLResponse?, TaggedEntryIds?, NSError?) -> Void) -> Request {
        return request(Router.FetchLatestTaggedEntryIds(newerThan)).validate().responseObject(completionHandler)
    }
}