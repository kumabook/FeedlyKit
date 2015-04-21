//
//  Entry.swift
//  MusicFav
//
//  Created by Hiroki Kumamoto on 12/23/14.
//  Copyright (c) 2014 Hiroki Kumamoto. All rights reserved.
//

import SwiftyJSON

public final class Entry: Equatable, Hashable,
                          ResponseObjectSerializable, ResponseCollectionSerializable,
                          ParameterEncodable {
    public let id:              String
    public let title:           String?
    public let content:         Content?
    public let summary:         Content?
    public let author:          String?
    public let crawled:         Int64
    public let recrawled:       Int64
    public let published:       Int64
    public let updated:         Int64?
    public let alternate:       [Link]?
    public let origin:          Origin?
    public let keywords:        [String]?
    public let visual:          Visual?
    public let unread:          Bool
    public let tags:            [Tag]?
    public let categories:      [Category]
    public let engagement:      Int?
    public let actionTimestamp: Int64?
    public let enclosure:       [Link]?
    public let fingerprint:     String?
    public let originId:        String?
    public let sid:             String?

    @objc public class func collection(#response: NSHTTPURLResponse, representation: AnyObject) -> [Entry] {
        let json = JSON(representation)
        return json.arrayValue.map({ Entry(json: $0) })
    }

    @objc required public convenience init?(response: NSHTTPURLResponse, representation: AnyObject) {
        let json = JSON(representation)
        self.init(json: json)
    }

    public init(json: JSON) {
        self.id              = json["id"].stringValue
        self.title           = json["title"].string
        self.content         = Content(json: json["content"])
        self.summary         = Content(json: json["summary"])
        self.author          = json["author"].string
        self.crawled         = json["crawled"].int64Value
        self.recrawled       = json["recrawled"].int64Value
        self.published       = json["published"].int64Value
        self.updated         = json["updated"].int64
        self.origin          = Origin(json: json["origin"])
        self.keywords        = json["keywords"].array?.map({ $0.string! })
        self.visual          = Visual(json: json["visual"])
        self.unread          = json["unread"].boolValue
        self.tags            = json["tags"].array?.map({ Tag(json: $0) })
        self.categories      = json["categories"].arrayValue.map({ Category(json: $0) })
        self.engagement      = json["engagement"].int
        self.actionTimestamp = json["actionTimestamp"].int64
        self.fingerprint     = json["fingerprint"].string
        self.originId        = json["originId"].string
        self.sid             = json["sid"].string
        if let alternates = json["alternate"].array {
            self.alternate   = alternates.map({ Link(json: $0) })
        } else {
            self.alternate   = nil
        }
        if let enclosures = json["enclosure"].array {
            self.enclosure   = enclosures.map({ Link(json: $0) })
        } else {
            self.enclosure   = nil
        }
    }

    public var hashValue: Int {
        get { return id.hashValue }
    }

    func toParameters() -> [String : AnyObject] {
        var params: [String: AnyObject] = ["published": NSNumber(longLong: published)]
        if let _title     = title     { params["title"]     = _title }
        if let _content   = content   { params["content"]   = _content.toParameters() }
        if let _summary   = summary   { params["summary"]   = _summary }
        if let _author    = author    { params["author"]    = _author }
        if let _enclosure = enclosure { params["enclosure"] = _enclosure.map({ $0.toParameters() }) }
        if let _alternate = alternate { params["alternate"] = _alternate.map({ $0.toParameters() }) }
        if let _keywords  = keywords  { params["keywords"]  = _keywords }
        if let _tags      = tags      { params["tags"]      = _tags }
        if let _origin    = origin    { params["origin"]    = _origin.toParameters() }

        return params
    }
}

public func ==(lhs: Entry, rhs: Entry) -> Bool {
    return lhs.id == rhs.id
}
