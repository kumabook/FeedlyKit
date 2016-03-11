//
//  Feed.swift
//  MusicFav
//
//  Created by Hiroki Kumamoto on 1/4/15.
//  Copyright (c) 2015 Hiroki Kumamoto. All rights reserved.
//

import SwiftyJSON

public final class Feed: Stream,
                         ResponseObjectSerializable, ResponseCollectionSerializable  {
    public var id:          String
    public var subscribers: Int
    public var title:       String
    public var description: String?
    public var language:    String?
    public var velocity:    Float?
    public var website:     String?
    public var topics:      [String]?
    public var status:      String?
    public var curated:     Bool?
    public var featured:    Bool?
    public var lastUpdated: Int64?

    public var visualUrl:   String?
    public var iconUrl:     String?
    public var coverUrl:    String?

    public var facebookUsername:    String?
    public var facebookLikes:       Int?
    public var twitterScreenName:   String?
    public var twitterFollowers:    String?
    public var contentType:         String?
    public var coverColor:          String?
    public var partial:             Bool?
    public var hint:                String?
    public var score:               Float?
    public var scheme:              String?
    public var estimatedEngagement: Int?
    public var websiteTitle:        String?

    public var deliciousTags:       [String]?

    public override var streamId: String {
        return id
    }
    public override var streamTitle: String {
        return title
    }

    public class func collection(response response: NSHTTPURLResponse, representation: AnyObject) -> [Feed]? {
        let json = JSON(representation)
        return json.arrayValue.map({ Feed(json: $0) })
    }

    @objc required public convenience init?(response: NSHTTPURLResponse, representation: AnyObject) {
        let json = JSON(representation)
        self.init(json: json)
    }

    public init(id: String, title: String, description: String, subscribers: Int) {
        self.id          = id
        self.title       = title
        self.description = description
        self.subscribers = subscribers
    }

    public init(json: JSON) {
        if let fid = json["id"].string {
            id      = fid
        } else if let fid = json["feedId"].string {
            id      = fid
        } else {
            id      = "unknownId"
        }
        subscribers = json["subscribers"].intValue
        title       = json["title"].stringValue
        description = json["description"].string
        language    = json["language"].string
        velocity    = json["velocity"].float
        website     = json["website"].string
        topics      = json["topics"].array?.map({ $0.stringValue })
        status      = json["status"].string

        curated     = json["curated"].bool
        featured    = json["featured"].bool
        lastUpdated = json["lastUpdated"].int64

        visualUrl   = json["visualUrl"].string
        iconUrl     = json["iconUrl"].string
        coverUrl    = json["coverUrl"].string

        facebookUsername    = json["facebookUsername"].string
        facebookLikes       = json["facebookLikes"].int

        twitterScreenName   = json["twitterScreenName"].string
        twitterFollowers    = json["twitterFollowers"].string

        contentType         = json["contentType"].string
        coverColor          = json["coverColor"].string
        partial             = json["partial"].bool
        hint                = json["hint"].string
        score               = json["score"].float
        scheme              = json["scheme"].string
        estimatedEngagement = json["estimatedEngagement"].int
        websiteTitle        = json["websiteTitle"].string
        deliciousTags       = json["deliciousTags"].array?.map({ $0.stringValue })
    }

    public override var thumbnailURL: NSURL? {
             if let url = visualUrl { return NSURL(string: url) }
        else if let url = coverUrl  { return NSURL(string: url) }
        else if let url = iconUrl   { return NSURL(string: url) }
        else                        { return nil }
    }
}
