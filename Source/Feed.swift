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
    public let id:          String
    public let subscribers: Int
    public let title:       String
    public let description: String?
    public let language:    String?
    public let velocity:    Float?
    public let website:     String?
    public let topics:      [String]?
    public let status:      String?
    public let curated:     Bool?
    public let featured:    Bool?
    public let lastUpdated: Int64?

    public let visualUrl:   String?
    public let iconUrl:     String?
    public let coverUrl:    String?

    public let facebookUsername:    String?
    public let facebookLikes:       Int?
    public let twitterScreenName:   String?
    public let twitterFollowers:    String?
    public let contentType:         String?
    public let coverColor:          String?
    public let partial:             Bool?
    public let hint:                String?
    public let score:               Float?
    public let scheme:              String?
    public let estimatedEngagement: Int?
    public let websiteTitle:        String?

    public let deliciousTags:       [String]?

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
