//
//  Feed.swift
//  MusicFav
//
//  Created by Hiroki Kumamoto on 1/4/15.
//  Copyright (c) 2015 Hiroki Kumamoto. All rights reserved.
//

import SwiftyJSON

public final class Feed: Equatable, Hashable,
                         Stream,
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

    public class func collection(#response: NSHTTPURLResponse, representation: AnyObject) -> [Feed] {
        let json = JSON(representation)
        return json.arrayValue.map({ Feed(json: $0) })
    }

    required public convenience init?(response: NSHTTPURLResponse, representation: AnyObject) {
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
    }

    public var hashValue: Int {
        get { return id.hashValue }
    }
}

public func ==(lhs: Feed, rhs: Feed) -> Bool {
    return lhs.id == rhs.id
}
