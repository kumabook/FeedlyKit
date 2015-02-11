//
//  Subscription.swift
//  MusicFav
//
//  Created by Hiroki Kumamoto on 12/21/14.
//  Copyright (c) 2014 Hiroki Kumamoto. All rights reserved.
//

import SwiftyJSON

public final class Subscription: Equatable, Hashable,
                                 Stream,
                                 ResponseObjectSerializable, ResponseCollectionSerializable,
                                 ParameterEncodable {
    public let id:         String
    public let title:      String
    public let categories: [Category]
    public let website:    String
    public let visualUrl:  String?
    public let sortId:     String?
    public let updated:    Int?
    public let added:      Int?

    public class func collection(#response: NSHTTPURLResponse, representation: AnyObject) -> [Subscription] {
        let json = JSON(representation)
        return json.arrayValue.map({ Subscription(json: $0) })
    }

    required public convenience init?(response: NSHTTPURLResponse, representation: AnyObject) {
        let json = JSON(representation)
        self.init(json: json)
    }

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

    public var hashValue: Int {
        get { return id.hashValue }
    }

    func toParameters() -> [String : AnyObject] {
        return [
                 "title": title,
                    "id": id,
            "categories": categories.map( { $0.toParameters() })
            ]
    }
}

public func ==(lhs: Subscription, rhs: Subscription) -> Bool {
    return lhs.id == rhs.id
}
