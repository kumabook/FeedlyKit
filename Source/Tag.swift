//
//  Tag.swift
//  FeedlyKit
//
//  Created by Hiroki Kumamoto on 1/18/15.
//  Copyright (c) 2015 Hiroki Kumamoto. All rights reserved.
//

import SwiftyJSON

public class Tag {
    public let id:    String
    public let label: String
    
    public init(json: JSON) {
        self.id    = json["id"].stringValue
        self.label = json["label"].stringValue
    }
}
