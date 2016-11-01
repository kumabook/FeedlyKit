//
//  Origin.swift
//  FeedlyKit
//
//  Created by Hiroki Kumamoto on 1/18/15.
//  Copyright (c) 2015 Hiroki Kumamoto. All rights reserved.
//

import SwiftyJSON

open class Origin: ParameterEncodable {
    open var streamId: String!
    open var title:    String!
    open var htmlUrl:  String!

    public init(streamId: String, title: String, htmlUrl: String) {
        self.streamId = streamId
        self.title    = title
        self.htmlUrl  = htmlUrl
    }

    public init?(json: JSON) {
        if json == nil { return nil }
        self.streamId = json["streamId"].stringValue
        self.title    = json["title"].stringValue
        self.htmlUrl  = json["htmlUrl"].stringValue
    }
    open func toParameters() -> [String : Any] {
        return ["title": title, "htmlUrl": htmlUrl]
    }
}
