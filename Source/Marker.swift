//
//  Marker.swift
//  FeedlyKit
//
//  Created by Hiroki Kumamoto on 1/18/15.
//  Copyright (c) 2015 Hiroki Kumamoto. All rights reserved.
//

import SwiftyJSON

open class Marker: ResponseObjectSerializable {
    public enum Action: String {
        case markAsRead     = "markAsRead"
        case keepAsUnread   = "keepUnread"
        case undoMarkAsRead = "undoMarkAsRead"
        case markAsSaved    = "markAsSaved"
        case markAsUnsaved  = "markAsUnsaved"
    }
    public enum ItemType {
        case entry
        case feed
        case category
        var type: String {
            switch self {
            case .entry:    return "entries"
            case .feed:     return "feeds"
            case .category: return "categories"
            }
        }
        var key: String {
            switch self {
            case .entry:     return "entryIds"
            case .feed:      return "feedIds"
            case .category:  return "categoryIds"
            }
        }
    }

    let asOf: Int64
    let id:   String

    public convenience  required init?(response: HTTPURLResponse, representation: Any) {
        let json = JSON(representation)
        self.init(json: json)
    }
    public init(json: JSON) {
        self.asOf = json["asOf"].int64Value
        self.id   = json["id"].stringValue
    }
}

open class MarkerParam: ParameterEncodable {
    let action:   Marker.Action
    let itemType: Marker.ItemType
    let itemIds:  [String]
    init(action: Marker.Action, itemType: Marker.ItemType, itemIds:[String]) {
        self.action   = action
        self.itemType = itemType
        self.itemIds  = itemIds
    }

    open func toParameters() -> [String : Any] {
        return ["type": itemType.type,
              "action": action.rawValue,
          itemType.key: itemIds]
    }
}

open class UnreadCounts: ResponseObjectSerializable {
    let value: [UnreadCount]
    public convenience required init?(response: HTTPURLResponse, representation: Any) {
        let json = JSON(representation)
        self.init(json: json)
    }
    public init(json: JSON) {
        value = json["unreadcounts"].arrayValue.map({ UnreadCount(json:$0) })
    }
    open subscript(index: Int) -> UnreadCount {
        get { return value[index] }
    }
}

open class UnreadCount {
    open let updated: Int64
    open let id:      String
    open let count:   Int
    public init(json: JSON) {
        self.updated = json["updated"].int64Value
        self.id      = json["id"].stringValue
        self.count   = json["count"].intValue
    }
}

open class ReadOperations: ResponseObjectSerializable {
    let feeds:   [Marker]
    let entries: [String]
    let unreads:  [String]
    public convenience required init?(response: HTTPURLResponse, representation: Any) {
        let json = JSON(representation)
        self.init(json: json)
    }
    public init(json: JSON) {
        feeds   = json["feeds"].arrayValue.map({ Marker(json: $0) })
        entries = json["entries"].arrayValue.map({ $0.stringValue })
        unreads = json["unreads"].arrayValue.map({ $0.stringValue })
    }
}

open class TaggedEntryIds: ResponseObjectSerializable {
    var value: [String: [String]]
    public convenience required init?(response: HTTPURLResponse, representation: Any) {
        let json = JSON(representation)
        self.init(json: json)
    }
    public init(json: JSON) {
        value = [:]
        if let dic = json["taggedEntries"].dictionary {
            for key in dic.keys {
                value[key] = dic[key]?.arrayValue.map( { $0.stringValue })
            }
        }
    }
    open subscript(key: String) -> [String]? {
        get { return value[key] }
    }
}
