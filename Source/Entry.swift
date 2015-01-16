//
//  Entry.swift
//  MusicFav
//
//  Created by Hiroki Kumamoto on 12/23/14.
//  Copyright (c) 2014 Hiroki Kumamoto. All rights reserved.
//

import SwiftyJSON

class Entry: NSObject {
    let id: String
    let published: Int
//    let updated: Int
    let crawled: Int
    let unread: Bool
//    let label: String
//    let type: String
//    let href: String
//    let engagement: Int
    let author: String
    let title: String
    let visualUrl: String?
//    let website: String
    //    let tags: String
    //    let categories: String
    let alternate: String?
    //    let origin
    //    let content

    init(json:JSON) {
        self.id         = json["id"].string!
        self.published  = json["published"].int!
//        self.updated    = json["updated"].int!
        self.crawled    = json["crawled"].int!
        self.unread     = json["unread"].bool!
//        self.label      = json["label"].string!
//        self.type       = json["type"].string!
//        self.href       = json["href"].string!
//        self.engagement = json["engagement"].int!
        self.author     = json["author"].string!
        self.title      = json["title"].string!
//        self.website    = json["website"].string!
        //        self.categories = json["categories"].string!
        self.visualUrl  = json["visual"]["url"].string
        self.alternate  = json["alternate"][0]["href"].string
    }
}
