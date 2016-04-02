//
//  Marker.swift
//  FeedlyKit
//
//  Created by Hiroki Kumamoto on 1/18/15.
//  Copyright (c) 2015 Hiroki Kumamoto. All rights reserved.
//

import SwiftyJSON

public class Marker: ResponseObjectSerializable {
    public enum Action: String {
        case MarkAsRead     = "markAsRead"
        case KeepAsUnread   = "keepUnread"
        case UndoMarkAsRead = "undoMarkAsRead"
        case MarkAsSaved    = "markAsSaved"
        case MarkAsUnsaved  = "markAsUnsaved"
    }
    public enum ItemType {
        case Entry
        case Feed
        case Category
        var type: String {
            switch self {
            case Entry:    return "entries"
            case Feed:     return "feeds"
            case Category: return "categories"
            }
        }
        var key: String {
            switch self {
            case Entry:     return "entryIds"
            case Feed:      return "feedIds"
            case Category:  return "categoryIds"
            }
        }
    }

    let asOf: Int64
    let id:   String

    @objc required public convenience  init?(response: NSHTTPURLResponse, representation: AnyObject) {
        let json = JSON(representation)
        self.init(json: json)
    }
    public init(json: JSON) {
        self.asOf = json["asOf"].int64Value
        self.id   = json["id"].stringValue
    }
}

public class MarkerParam: ParameterEncodable {
    let action:   Marker.Action
    let itemType: Marker.ItemType
    let itemIds:  [String]
    init(action: Marker.Action, itemType: Marker.ItemType, itemIds:[String]) {
        self.action   = action
        self.itemType = itemType
        self.itemIds  = itemIds
    }

    public func toParameters() -> [String : AnyObject] {
        return ["type": itemType.type,
              "action": action.rawValue,
          itemType.key: itemIds]
    }
}

public class UnreadCounts: ResponseObjectSerializable {
    let value: [UnreadCount]
    @objc required public convenience init?(response: NSHTTPURLResponse, representation: AnyObject) {
        let json = JSON(representation)
        self.init(json: json)
    }
    public init(json: JSON) {
        value = json["unreadcounts"].arrayValue.map({ UnreadCount(json:$0) })
    }
    public subscript(index: Int) -> UnreadCount {
        get { return value[index] }
    }
}

public class UnreadCount {
    public let updated: Int64
    public let id:      String
    public let count:   Int
    public init(json: JSON) {
        self.updated = json["updated"].int64Value
        self.id      = json["id"].stringValue
        self.count   = json["count"].intValue
    }
}

public class ReadOperations: ResponseObjectSerializable {
    let feeds:   [Marker]
    let entries: [String]
    let unreads:  [String]
    @objc required public convenience init?(response: NSHTTPURLResponse, representation: AnyObject) {
        let json = JSON(representation)
        self.init(json: json)
    }
    public init(json: JSON) {
        feeds   = json["feeds"].arrayValue.map({ Marker(json: $0) })
        entries = json["entries"].arrayValue.map({ $0.stringValue })
        unreads = json["unreads"].arrayValue.map({ $0.stringValue })
    }
}

public class TaggedEntryIds: ResponseObjectSerializable {
    var value: [String: [String]]
    @objc required public convenience init?(response: NSHTTPURLResponse, representation: AnyObject) {
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
    public subscript(key: String) -> [String]? {
        get { return value[key] }
    }
}
