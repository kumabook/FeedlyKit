//
//  Subscription.swift
//  MusicFav
//
//  Created by Hiroki Kumamoto on 12/21/14.
//  Copyright (c) 2014 Hiroki Kumamoto. All rights reserved.
//

import SwiftyJSON

public class Subscription: Stream {
    public let id:         String
    public let title:      String
    public let categories: [Category]
    public let website:    String
    public let visualUrl:  String?
    public let sortId:     String?
    public let updated:    Int?
    public let added:      Int?

    public init(json: JSON) {
        self.id         = json["id"].stringValue
        self.title      = json["title"].stringValue
        self.website    = json["website"].stringValue
        self.categories = json["categories"].arrayValue.map({Category(json: $0)})
        self.visualUrl  = json["visualUrl"].string
        self.sortId     = json["sortid"].string
        self.updated    = json["updated"].int
        self.added      = json["added"].int
    }
}
