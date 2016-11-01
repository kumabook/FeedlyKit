//
//  MarkersAPI.swift
//  FeedlyKit
//
//  Created by Hiroki Kumamoto on 1/23/15.
//  Copyright (c) 2015 Hiroki Kumamoto. All rights reserved.
//

import Alamofire
import SwiftyJSON

open class UnreadCountsParams: ParameterEncodable {
    open var autoRefresh: Bool?
    open var newerThan: Int64?
    open var streamId: String?
    public init(autoRefresh: Bool?, newerThan: Int64?, streamId: String?) {
        self.autoRefresh = autoRefresh
        self.newerThan   = newerThan
        self.streamId    = streamId
    }
    open func toParameters() -> [String: Any] {
        var params: [String:Any] = [:]
        if let autoRefresh = autoRefresh { params["autoRefresh"] = autoRefresh ? "true" : "false" }
        if let newerThan   = newerThan   { params["newerThan"]   = NSNumber(value: newerThan as Int64) }
        if let streamId    = streamId    { params["streamId"]    = streamId as Any }
        return params
    }
}

extension CloudAPIClient {
    /**
        Get the list of unread counts
        GET /v3/markers/counts
    */
    public func fetchUnreadCounts(_ params: UnreadCountsParams, completionHandler: @escaping (DataResponse<UnreadCounts>) -> Void) -> Request {
        return manager.request(Router.fetchUnreadCounts(target, params))
                      .validate()
                      .responseObject(completionHandler: completionHandler)
    }

    /**
        Mark one or multiple articles as read
        POST /v3/markers
    */
    public func markEntriesAsRead(_ itemIds: [String], completionHandler: @escaping (DefaultDataResponse) -> Void) -> Request {
        let marker = MarkerParam(action: .markAsRead, itemType: .entry, itemIds: itemIds)
        return manager.request(Router.markAs(target, marker)).validate().response(completionHandler: completionHandler)
    }

    /**
        Keep one or multiple articles as unread
        POST /v3/markers
    */
    public func keepEntriesAsUnread(_ itemIds: [String], completionHandler: @escaping (DefaultDataResponse) -> Void) -> Request {
        let marker = MarkerParam(action: .keepAsUnread, itemType: .entry, itemIds: itemIds)
        return manager.request(Router.markAs(target, marker)).validate().response(completionHandler: completionHandler)
    }

    /**
        Mark a feed as read
        POST /v3/markers
    */
    public func markFeedsAsRead(_ itemIds: [String], completionHandler: @escaping (DefaultDataResponse) -> Void) -> Request {
        let marker = MarkerParam(action: .markAsRead, itemType: .feed, itemIds: itemIds)
        return manager.request(Router.markAs(target, marker)).validate().response(completionHandler: completionHandler)
    }

    /**
        Mark a category as read
        POST /v3/markers
    */
    public func markCategoriesAsRead(_ itemIds: [String], completionHandler: @escaping (DefaultDataResponse) -> Void) -> Request {
        let marker = MarkerParam(action: .markAsRead, itemType: .category, itemIds: itemIds)
        return manager.request(Router.markAs(target, marker)).validate().response(completionHandler: completionHandler)
    }

    /**
        Undo mark as read
        POST /v3/markers
    */
    public func undoMarkAsRead(_ itemType: Marker.ItemType, itemIds: [String], completionHandler: @escaping (DefaultDataResponse) -> Void) -> Request {
        let marker = MarkerParam(action: .undoMarkAsRead, itemType: itemType, itemIds: itemIds)
        return manager.request(Router.markAs(target, marker)).validate().response(completionHandler: completionHandler)
    }

    /**
        Mark one or multiple articles as saved
        POST /v3/markers
    */
    public func markEntriesAsSaved(_ itemIds: [String], completionHandler: @escaping (DefaultDataResponse) -> Void) -> Request {
        let marker = MarkerParam(action: .markAsSaved, itemType: .entry, itemIds: itemIds)
        return manager.request(Router.markAs(target, marker)).validate().response(completionHandler: completionHandler)
    }

    /**
        Mark one or multiple articles as unsaved
        POST /v3/markers
    */
    public func markEntriesAsUnsaved(_ itemIds: [String], completionHandler: @escaping (DefaultDataResponse) -> Void) -> Request {
        let marker = MarkerParam(action: .markAsUnsaved, itemType: .entry, itemIds: itemIds)
        return manager.request(Router.markAs(target, marker)).validate().response(completionHandler: completionHandler)
    }

    /**
        Get the latest read operations (to sync local cache)
        GET /v3/markers/reads
    */
    public func fetchLatestReadOperations(_ newerThan: Int64?, completionHandler: @escaping (DataResponse<ReadOperations>) -> Void) -> Request {
        return manager.request(Router.fetchLatestReadOperations(target, newerThan)).validate().responseObject(completionHandler: completionHandler)
    }

    /**
        Get the latest tagged entry ids
        GET /v3/markers/tags
    */
    public func fetchLatestTaggedEntryIds(_ newerThan: Int64?, completionHandler: @escaping (DataResponse<TaggedEntryIds>) -> Void) -> Request {
        return manager.request(Router.fetchLatestTaggedEntryIds(target, newerThan)).validate().responseObject(completionHandler: completionHandler)
    }
}
