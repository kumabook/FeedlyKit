//
//  Entry.swift
//  MusicFav
//
//  Created by Hiroki Kumamoto on 12/23/14.
//  Copyright (c) 2014 Hiroki Kumamoto. All rights reserved.
//

import SwiftyJSON

public class Entry: NSObject {
    public let id:              String
    public let title:           String?
    public let content:         Content?
    public let summary:         String?
    public let author:          String?
    public let crawled:         Int
    public let recrawled:       Int
    public let published:       Int
    public let updated:         Int?
    public let alternate:       [Link]?
    public let origin:          Origin?
    public let keywords:        [String]?
    public let visual:          Visual?
    public let unread:          Bool
    public let tags:            [Tag]?
    public let categories:      [Category]
    public let engagement:      Int?
    public let actionTimestamp: Int?
    public let enclosure:       [Link]?
    public let fingerprint:     String?
    public let originId:        String?
    public let sid:             String?

    public init(json: JSON) {
        self.id              = json["id"].stringValue
        self.title           = json["title"].string
        self.content         = Content(json: json["content"])
        self.summary         = json["summary"].string
        self.author          = json["author"].string
        self.crawled         = json["crawled"].intValue
        self.recrawled       = json["recrawled"].intValue
        self.published       = json["published"].intValue
        self.updated         = json["updated"].int
        self.origin          = Origin(json: json["origin"])
        self.keywords        = json["keywords"].array?.map({ $0.string! })
        self.visual          = Visual(json: json["dictionary"])
        self.unread          = json["unread"].boolValue
        self.tags            = json["tags"].array?.map({ Tag(json: $0) })
        self.categories      = json["categories"].arrayValue.map({ Category(json: $0) })
        self.engagement      = json["engagement"].int
        self.actionTimestamp = json["actionTimestamp"].int
        self.fingerprint     = json["fingerprint"].string
        self.originId        = json["originId"].string
        if let alternates = json["alternate"].array? {
            self.alternate   = alternates.map({ Link(json: $0) })
        }
        if let enclosures = json["enclosure"].array {
            self.enclosure   = enclosures.map({ Link(json: $0) })
        }
    }
}
