//
//  Content.swift
//  FeedlyKit
//
//  Created by Hiroki Kumamoto on 1/18/15.
//  Copyright (c) 2015 Hiroki Kumamoto. All rights reserved.
//

import SwiftyJSON

open class Content: ParameterEncodable {
    open var direction: String!
    open var content: String!

    public init(direction: String, content: String) {
        self.direction = direction
        self.content   = content
    }

    public init?(json: JSON) {
        if json == nil { return nil }
        self.direction = json["direction"].stringValue
        self.content   = json["content"].stringValue
    }

    open func toParameters() -> [String : Any] {
        return ["direction": direction,
                  "content": content]
    }
}
