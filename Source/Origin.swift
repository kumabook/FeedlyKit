//
//  Origin.swift
//  FeedlyKit
//
//  Created by Hiroki Kumamoto on 1/18/15.
//  Copyright (c) 2015 Hiroki Kumamoto. All rights reserved.
//

import SwiftyJSON

public class Origin: ParameterEncodable {
    public let streamId: String
    public let title:    String
    public let htmlUrl:  String

    public init(json: JSON) {
        self.streamId = json["streamId"].stringValue
        self.title    = json["title"].stringValue
        self.htmlUrl  = json["htmlUrl"].stringValue
    }
    func toParameters() -> [String : AnyObject] {
        return ["title": title, "htmlUrl": htmlUrl]
    }
}