//
//  Topic.swift
//  FeedlyKit
//
//  Created by Hiroki Kumamoto on 1/18/15.
//  Copyright (c) 2015 Hiroki Kumamoto. All rights reserved.
//

import SwiftyJSON

public class Topic {
    public let id: String
    public let interest: String
    public let created: Int
    public let updated: Int
    
    public init(json: JSON) {
        self.id       = json["id"].stringValue
        self.interest = json["interest"].stringValue
        self.created  = json["created"].intValue
        self.updated  = json["updated"].intValue
    }
}
