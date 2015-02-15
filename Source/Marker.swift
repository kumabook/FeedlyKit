//
//  MarkersCount.swift
//  FeedlyKit
//
//  Created by Hiroki Kumamoto on 1/18/15.
//  Copyright (c) 2015 Hiroki Kumamoto. All rights reserved.
//

import SwiftyJSON

public class Marker {
    public enum Action: String {
        case MarkAsRead     = "markAsRead"
        case KeepAsUnread   = "keepUnread"
        case UndoMarkAsRead = "undoMarkAsRead"
        case MarkAsSaved    = "markAsSaved"
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
}

public final class UnreadCount: ResponseObjectSerializable, ResponseCollectionSerializable {
    let id:      String
    let updated: Int64
    let count:   Int
    
    public class func collection(#response: NSHTTPURLResponse, representation: AnyObject) -> [UnreadCount] {
        let json = JSON(representation)

        return json.arrayValue.map({ UnreadCount(json: $0) })
    }

    required public convenience init?(response: NSHTTPURLResponse, representation: AnyObject) {
        let json = JSON(representation)
        self.init(json: json)
    }
    
    public init(json: JSON) {
        id      = json["id"].stringValue
        updated = json["updated"].int64Value
        count   = json["count"].intValue
    }
}

