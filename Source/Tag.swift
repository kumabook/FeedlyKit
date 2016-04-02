//
//  Tag.swift
//  FeedlyKit
//
//  Created by Hiroki Kumamoto on 1/18/15.
//  Copyright (c) 2015 Hiroki Kumamoto. All rights reserved.
//

import SwiftyJSON

public final class Tag: Stream,
                        ResponseObjectSerializable, ResponseCollectionSerializable,
                        ParameterEncodable {
    public let id:    String
    public let label: String

    public override var streamId: String {
        return id
    }
    public override var streamTitle: String {
        return label
    }

    public class func collection(response response: NSHTTPURLResponse, representation: AnyObject) -> [Tag]? {
        let json = JSON(representation)
        return json.arrayValue.map({ Tag(json: $0) })
    }

    public class func Read(userId: String) -> Tag {
        return Tag(id: "user/\(userId)/tag/global.read", label: "Read")
    }

    public class func Saved(userId: String) -> Tag {
        return Tag(id: "user/\(userId)/tag/global.saved", label: "Saved")
    }

    @objc required public convenience init?(response: NSHTTPURLResponse, representation: AnyObject) {
        let json = JSON(representation)
        self.init(json: json)
    }

    public init(id: String, label: String) {
        self.id    = id
        self.label = label
    }

    public init(json: JSON) {
        self.id    = json["id"].stringValue
        self.label = json["label"].stringValue
    }

    public init(label: String, profile: Profile) {
        self.id    = "user/\(profile.id)/tag/\(label)"
        self.label = label
    }

    public func toParameters() -> [String : AnyObject] {
        return ["id":id, "label":label]
    }
}
