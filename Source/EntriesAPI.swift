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
//    public func fetchEntry(entryId: String, completionHandler: (NSURLRequest?, NSHTTPURLResponse?, Result<Entry, NSError>) -> Void) -> Request {
    public func fetchEntry(_ entryId: String, completionHandler: @escaping (DataResponse<Entry>) -> Void) -> Request {
        return manager.request(Router.fetchEntry(target, entryId)).responseObject(completionHandler: completionHandler)
    }
    
    /**
        Get the content for a dynamic list of entries
        POST /v3/entries/.mget
        (Authorization is optional)
    */
    public func fetchEntries(_ entryIds: [String], completionHandler: @escaping (DataResponse<[Entry]>) -> Void) -> Request {
        return manager.request(Router.fetchEntries(target, entryIds)).validate().responseCollection(completionHandler: completionHandler)
    }
    
    /**
        Create and tag an entry
        POST /v3/entries/
        (Authorization is required)
    */
    public func createEntry(_ entry: Entry, completionHandler: @escaping (DataResponse<[String]>) -> Void) -> Request {
        return manager.request(Router.createEntry(target, entry)).validate().responseJSON {
            var result: Result<[String]>
            switch $0.result {
            case .success:
                var json: JSON = JSON($0.result.value!)
                result = Result.success(Array(1..<json.count).map { json[$0].stringValue })
            case .failure:
                result = Result.failure($0.result.error!)
            }
            completionHandler(DataResponse(request: $0.request, response: $0.response, data: $0.data, result: result))
        }
    }
}
