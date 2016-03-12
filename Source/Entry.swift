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
    public var id:              String
    public var title:           String?
    public var content:         Content?
    public var summary:         Content?
    public var author:          String?
    public var crawled:         Int64 = 0
    public var recrawled:       Int64 = 0
    public var published:       Int64 = 0
    public var updated:         Int64?
    public var alternate:       [Link]?
    public var origin:          Origin?
    public var keywords:        [String]?
    public var visual:          Visual?
    public var unread:          Bool = true
    public var tags:            [Tag]?
    public var categories:      [Category] = []
    public var engagement:      Int?
    public var actionTimestamp: Int64?
    public var enclosure:       [Link]?
    public var fingerprint:     String?
    public var originId:        String?
    public var sid:             String?

    public class func collection(response response: NSHTTPURLResponse, representation: AnyObject) -> [Entry]? {
        let json = JSON(representation)
        return json.arrayValue.map({ Entry(json: $0) })
    }

    @objc required public convenience init?(response: NSHTTPURLResponse, representation: AnyObject) {
        let json = JSON(representation)
        self.init(json: json)
    }

    public init(id: String) {
        self.id = id
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

    public func toParameters() -> [String : AnyObject] {
        var params: [String: AnyObject] = ["published": NSNumber(longLong: published)]
        if let _title     = title     { params["title"]     = _title }
        if let _content   = content   { params["content"]   = _content.toParameters() }
        if let _summary   = summary   { params["summary"]   = _summary.toParameters() }
        if let _author    = author    { params["author"]    = _author }
        if let _enclosure = enclosure { params["enclosure"] = _enclosure.map({ $0.toParameters() }) }
        if let _alternate = alternate { params["alternate"] = _alternate.map({ $0.toParameters() }) }
        if let _keywords  = keywords  { params["keywords"]  = _keywords }
        if let _tags      = tags      { params["tags"]      = _tags.map { $0.toParameters() }}
        if let _origin    = origin    { params["origin"]    = _origin.toParameters() }

        return params
    }

    public var thumbnailURL: NSURL? {
        if let v = visual, url = v.url.toURL() {
            return url
        }
        if let links = enclosure {
            for link in links {
                if let url = link.href.toURL() {
                    if link.type.contains("image") { return url }
                }
            }
        }
        if let url = extractImgSrc() {
            return url
        }
        return nil
    }

    func extractImgSrc() -> NSURL? {
        if let html = content?.content {
            let regex = try? NSRegularExpression(pattern: "<img.*src\\s*=\\s*[\"\'](.*?)[\"\'].*>",
                options: NSRegularExpressionOptions())
            if let r = regex {
                if let result  = r.firstMatchInString(html, options: NSMatchingOptions(), range: NSMakeRange(0, html.characters.count)) {
                    for i in 0...result.numberOfRanges - 1 {
                        let range = result.rangeAtIndex(i)
                        let str = html as NSString
                        if let url = str.substringWithRange(range).toURL() {
                            return url
                        }
                    }
                }
            }
        }
        return nil
    }
}

public func ==(lhs: Entry, rhs: Entry) -> Bool {
    return lhs.id == rhs.id
}
