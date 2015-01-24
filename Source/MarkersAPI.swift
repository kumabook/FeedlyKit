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
                        completionHandler: (NSURLRequest, NSHTTPURLResponse?, Feed?, NSError?) -> Void) -> Self {
        Alamofire.request(Router.FetchUnreadCounts(autorefresh: info.autorefresh,
                                                     newerThan: info.newerThan,
                                                      streamId: info.streamId)).responseObject(completionHandler)
        return self
    }

}