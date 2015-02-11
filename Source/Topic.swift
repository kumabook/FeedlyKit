//
//  Topic.swift
//  FeedlyKit
//
//  Created by Hiroki Kumamoto on 1/18/15.
//  Copyright (c) 2015 Hiroki Kumamoto. All rights reserved.
//

import SwiftyJSON

public final class Topic: Equatable, Hashable,
                          ResponseObjectSerializable, ResponseCollectionSerializable {
    public let id:       String
    public let interest: String
    public let created:  Int
    public let updated:  Int

    public class func collection(#response: NSHTTPURLResponse, representation: AnyObject) -> [Topic] {
        let json = JSON(representation)
        return json.arrayValue.map({ Topic(json: $0) })
    }

    required public convenience init?(response: NSHTTPURLResponse, representation: AnyObject) {
        let json = JSON(representation)
        self.init(json: json)
    }
    
    public init(json: JSON) {
        self.id       = json["id"].stringValue
        self.interest = json["interest"].stringValue
        self.created  = json["created"].intValue
        self.updated  = json["updated"].intValue
    }

    public var hashValue: Int {
        get { return id.hashValue }
    }
}

public func ==(lhs: Topic, rhs: Topic) -> Bool {
    return lhs.id == rhs.id
}

