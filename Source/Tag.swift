//
//  Tag.swift
//  FeedlyKit
//
//  Created by Hiroki Kumamoto on 1/18/15.
//  Copyright (c) 2015 Hiroki Kumamoto. All rights reserved.
//

import SwiftyJSON

public final class Tag: Equatable, Hashable,
                        ResponseObjectSerializable, ResponseCollectionSerializable {
    public let id:    String
    public let label: String

    public class func collection(#response: NSHTTPURLResponse, representation: AnyObject) -> [Tag] {
        let json = JSON(representation)
        return json.arrayValue.map({ Tag(json: $0) })
    }

    required public convenience init?(response: NSHTTPURLResponse, representation: AnyObject) {
        let json = JSON(representation)
        self.init(json: json)
    }

    public var hashValue: Int {
        get { return id.hashValue }
    }

    public init(json: JSON) {
        self.id    = json["id"].stringValue
        self.label = json["label"].stringValue
    }
}

public func ==(lhs: Tag, rhs: Tag) -> Bool {
    return lhs.id == rhs.id
}
