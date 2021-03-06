//
//  Category.swift
//  MusicFav
//
//  Created by Hiroki Kumamoto on 1/10/15.
//  Copyright (c) 2015 Hiroki Kumamoto. All rights reserved.
//

import Foundation
import SwiftyJSON

public final class Category: Stream,
                             ResponseObjectSerializable, ResponseCollectionSerializable,
                             ParameterEncodable {
    public let id:          String
    public let label:       String
    public let description: String?

    public override var streamId: String {
        return id
    }
    public override var streamTitle: String {
        return label
    }

    public class func collection(_ response: HTTPURLResponse, representation: Any) -> [Category]? {
        let json = JSON(representation)
        return json.arrayValue.map({ Category(json: $0) })
    }

    public convenience init?(response: HTTPURLResponse, representation: Any) {
        let json = JSON(representation)
        self.init(json: json)
    }

    public class func must(_ userId: String) -> Category {
        return Category(id: "user/\(userId)/category/global.must", label: "Must")
    }

    public class func all(_ userId: String) -> Category {
        return Category(id: "user/\(userId)/category/global.all", label: "All")
    }

    public class func uncategorized(_ userId: String) -> Category {
        return Category(id: "user/\(userId)/category/global.uncategorized", label: "Uncategorized")
    }

    public init(json: JSON) {
        id          = json["id"].stringValue
        label       = json["label"].stringValue
        description = json["description"].string
    }

    public init(id: String, label: String, description: String? = nil) {
        self.id          = id
        self.label       = label
        self.description = description
    }

    public init(label: String, profile: Profile, description: String? = nil) {
        self.id          = "user/\(profile.id)/category/\(label)"
        self.label       = label
        self.description = description
    }

    public func toParameters() -> [String : Any] {
        return ["id": id, "label": label]
    }
}
