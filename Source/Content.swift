//
//  Content.swift
//  FeedlyKit
//
//  Created by Hiroki Kumamoto on 1/18/15.
//  Copyright (c) 2015 Hiroki Kumamoto. All rights reserved.
//

import SwiftyJSON

public class Content: ParameterEncodable {
    public let direction: String
    public let content: String

    public init(json: JSON) {
        self.direction = json["direction"].stringValue
        self.content   = json["content"].stringValue
    }

    func toParameters() -> [String : AnyObject] {
        return ["direction": direction,
                  "content": content]
    }
}
