//
//  Link.swift
//  FeedlyKit
//
//  Created by Hiroki Kumamoto on 1/18/15.
//  Copyright (c) 2015 Hiroki Kumamoto. All rights reserved.
//

import SwiftyJSON

public class Link: NSObject, ParameterEncodable {
    public let href:   String
    public let type:   String
    public let length: Int?
    
    init(json:JSON) {
        self.href   = json["href"].stringValue
        self.type   = json["type"].stringValue
        self.length = json["length"].int?
    }
    func toParameters() -> [String : AnyObject] {
        return ["href": href, "type": type]
    }
}