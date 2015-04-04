//
//  Tag.swift
//  FeedlyKit
//
//  Created by Hiroki Kumamoto on 1/18/15.
//  Copyright (c) 2015 Hiroki Kumamoto. All rights reserved.
//

import SwiftyJSON

public final class Tag: Stream,
                        ResponseObjectSerializable, ResponseCollectionSerializable {
    public let id:    String
    public let label: String

    public override var streamId: String {
        return id
    }
    public override var streamTitle: String {
        return label
    }

    public class func collection(#response: NSHTTPURLResponse, representation: AnyObject) -> [Tag] {
        let json = JSON(representation)
        return json.arrayValue.map({ Tag(json: $0) })
    }

    public class func Read(userId: String) -> Category {
        return Category(id: "user/\(userId)/tag/global.read", label: "Read")
    }

    public class func Saved(userId: String) -> Category {
        return Category(id: "user/\(userId)/tag/global.saved", label: "Saved")
    }

    required public convenience init?(response: NSHTTPURLResponse, representation: AnyObject) {
        let json = JSON(representation)
        self.init(json: json)
    }

    public init(json: JSON) {
        self.id    = json["id"].stringValue
        self.label = json["label"].stringValue
    }
}
