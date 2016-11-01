//
//  Link.swift
//  FeedlyKit
//
//  Created by Hiroki Kumamoto on 1/18/15.
//  Copyright (c) 2015 Hiroki Kumamoto. All rights reserved.
//

import SwiftyJSON

open class Link: NSObject, ParameterEncodable {
    open let href:   String
    open let type:   String
    open let length: Int?
    
    public init(href: String, type: String, length: Int?) {
        self.href   = href
        self.type   = type
        self.length = length
    }

    public init(json:JSON) {
        self.href   = json["href"].stringValue
        self.type   = json["type"].stringValue
        self.length = json["length"].int
    }
    open func toParameters() -> [String : Any] {
        return ["href": href, "type": type]
    }
}
