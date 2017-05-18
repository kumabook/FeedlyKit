//
//  Tag.swift
//  FeedlyKit
//
//  Created by Hiroki Kumamoto on 1/18/15.
//  Copyright (c) 2015 Hiroki Kumamoto. All rights reserved.
//

import Foundation
import SwiftyJSON

public final class Tag: Stream,
                        ResponseObjectSerializable, ResponseCollectionSerializable,
                        ParameterEncodable {
    public var id:          String
    public var label:       String
    public var description: String?

    public override var streamId: String {
        return id
    }
    public override var streamTitle: String {
        return label
    }

    public class func collection(_ response: HTTPURLResponse, representation: Any) -> [Tag]? {
        let json = JSON(representation)
        return json.arrayValue.map({ Tag(json: $0) })
    }

    public class func read(_ userId: String) -> Tag {
        return Tag(id: "user/\(userId)/tag/global.read", label: "Read")
    }

    public class func saved(_ userId: String) -> Tag {
        return Tag(id: "user/\(userId)/tag/global.saved", label: "Saved")
    }

    @objc required public convenience init?(response: HTTPURLResponse, representation: Any) {
        let json = JSON(representation)
        self.init(json: json)
    }

    public init(id: String, label: String, description: String? = nil) {
        self.id          = id
        self.label       = label
        self.description = description
    }

    public init(json: JSON) {
        self.id          = json["id"].stringValue
        self.label       = json["label"].stringValue
        self.description = json["description"].string
    }

    public init(label: String, profile: Profile, description: String? = nil) {
        self.id          = "user/\(profile.id)/tag/\(label)"
        self.label       = label
        self.description = description
    }

    public func toParameters() -> [String : Any] {
        return ["id":id, "label":label]
    }
}
