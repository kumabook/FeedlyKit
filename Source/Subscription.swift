//
//  Subscription.swift
//  MusicFav
//
//  Created by Hiroki Kumamoto on 12/21/14.
//  Copyright (c) 2014 Hiroki Kumamoto. All rights reserved.
//

import SwiftyJSON

class Subscription: Stream {
    let id:         String
    let title:      String
    let categories: [Category]
    let website:    String
    let visualUrl:  String?
    let sortId:     String?
    let updated:    Int
    let added:      Int?

    init(json:JSON) {
        self.id         = json["id"].string!
        self.title      = json["title"].string!
        self.website    = json["website"].string!
        self.categories = json["categories"].array!.map({Category(json: $0)})
        self.visualUrl  = json["visualUrl"].string?
        self.sortId     = json["sortid"].string?
        self.updated    = json["updated"].int!
        self.added      = json["added"].int?
    }
}
