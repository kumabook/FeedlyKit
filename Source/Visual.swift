//
//  Visual.swift
//  FeedlyKit
//
//  Created by Hiroki Kumamoto on 1/18/15.
//  Copyright (c) 2015 Hiroki Kumamoto. All rights reserved.
//

import SwiftyJSON

open class Visual {
    open let url:         String
    open let width:       Int
    open let height:      Int
    open let contentType: String

    public init(url: String, width: Int, height: Int, contentType: String) {
        self.url         = url
        self.width       = width
        self.height      = height
        self.contentType = contentType
    }
    
    public init(json: JSON) {
        self.url         = json["url"].stringValue
        self.width       = json["width"].intValue
        self.height      = json["height"].intValue
        self.contentType = json["contentType"].stringValue
    }
}
