//
//  Feed.swift
//  MusicFav
//
//  Created by Hiroki Kumamoto on 1/4/15.
//  Copyright (c) 2015 Hiroki Kumamoto. All rights reserved.
//

import SwiftyJSON

class Feed: Stream {
    let id:          String
    let subscribers: Int
    let title:       String
    let description: String?
    let language:    String?
    let velocity:    Double?
    let website:     String?
    let topics:      [String]?
    let status:      String?

    let curated:     Bool?
    let featured:    Bool?

    init(json: JSON) {
        if let fid = json["id"].string {
            id      = fid
        } else if let fid = json["feedId"].string {
            id      = fid
        } else {
            id      = "unknownId"
        }
        subscribers = json["subscribers"].int!
        title       = json["title"].string!
        description = json["description"].string?
        language    = json["language"].string?
        velocity    = json["velocity"].double
        website     = json["website"].string?
        topics      = json["topics"].array?.map({$0.string!})
        status      = json["status"].string

        curated     = json["curated"].bool?
        featured    = json["featured"].bool?
    }
}
