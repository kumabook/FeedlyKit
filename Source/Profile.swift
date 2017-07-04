//
//  Profile.swift
//  MusicFav
//
//  Created by Hiroki Kumamoto on 1/4/15.
//  Copyright (c) 2015 Hiroki Kumamoto. All rights reserved.
//

import Foundation
import SwiftyJSON

open class Profile: NSObject, NSCoding, ResponseObjectSerializable {
    open var id:             String
    open var email:          String?
    open var givenName:      String?
    open var familyName:     String?
    open var fullName:       String?
    open var picture:        String?
    open var gender:         String?
    open var locale:         String?
    open var reader:         String?
    open var wave:           String?
    open var google:         String?
    open var facebook:       String?
    open var facebookUserId: String?
    open var twitter:        String?
    open var twitterUserId:  String?
    open var wordPressId:    String?
    open var windowsLiveId:  String?
    open var client:         String = ""
    open var source:         String = ""
    open var created:        Int64?

    required public convenience init?(response: HTTPURLResponse, representation: Any) {
        let json = JSON(representation)
        self.init(json: json)
    }

    public init(id: String) {
        self.id = id
    }

    public init(json: JSON) {
        id             = json["id"].stringValue
        email          = json["email"].string
        givenName      = json["givenName"].string
        familyName     = json["familyName"].string
        fullName       = json["fullName"].string
        picture        = json["picture"].string
        gender         = json["gender"].string
        locale         = json["locale"].string
        reader         = json["reader"].string
        wave           = json["wave"].string
        google         = json["google"].string
        facebook       = json["facebook"].string
        facebookUserId = json["facebookUserId"].string
        twitter        = json["twitter"].string
        twitterUserId  = json["twitterUserId"].string
        wordPressId    = json["wordPressId"].string
        windowsLiveId  = json["windowsLiveId"].string
        client         = json["client"].stringValue
        source         = json["source"].stringValue
        created        = json["created"].int64
    }
    required public init?(coder aDecoder: NSCoder) {
        id             = aDecoder.decodeObject(forKey: "id")             as? String ?? ""
        email          = aDecoder.decodeObject(forKey: "email")          as? String
        givenName      = aDecoder.decodeObject(forKey: "givenName")      as? String
        familyName     = aDecoder.decodeObject(forKey: "familyName")     as? String
        fullName       = aDecoder.decodeObject(forKey: "fullName")       as? String
        picture        = aDecoder.decodeObject(forKey: "picture")        as? String
        gender         = aDecoder.decodeObject(forKey: "gender")         as? String
        locale         = aDecoder.decodeObject(forKey: "locale")         as? String
        reader         = aDecoder.decodeObject(forKey: "reader")         as? String
        wave           = aDecoder.decodeObject(forKey: "wave")           as? String
        google         = aDecoder.decodeObject(forKey: "google")         as? String
        facebook       = aDecoder.decodeObject(forKey: "facebook")       as? String
        facebookUserId = aDecoder.decodeObject(forKey: "facebookUserId") as? String
        twitter        = aDecoder.decodeObject(forKey: "twitter")        as? String
        twitterUserId  = aDecoder.decodeObject(forKey: "twitterUserId")  as? String
        wordPressId    = aDecoder.decodeObject(forKey: "wordPressId")    as? String
        windowsLiveId  = aDecoder.decodeObject(forKey: "windowsLiveId")  as? String
        client         = aDecoder.decodeObject(forKey: "client")         as? String ?? ""
        source         = aDecoder.decodeObject(forKey: "source")         as? String ?? ""
        created        = aDecoder.decodeObject(forKey: "created")        as? Int64
    }

    open func encode(with aCoder: NSCoder) {
        aCoder.encode(id,             forKey: "id")
        aCoder.encode(email,          forKey: "email")
        aCoder.encode(givenName,      forKey: "givenName")
        aCoder.encode(familyName,     forKey: "familyName")
        aCoder.encode(fullName,       forKey: "fullName")
        aCoder.encode(picture,        forKey: "picture")
        aCoder.encode(gender,         forKey: "gender")
        aCoder.encode(locale,         forKey: "locale")
        aCoder.encode(reader,         forKey: "reader")
        aCoder.encode(wave,           forKey: "wave")
        aCoder.encode(google,         forKey: "google")
        aCoder.encode(facebook,       forKey: "facebook")
        aCoder.encode(facebookUserId, forKey: "facebookUserid")
        aCoder.encode(twitter,        forKey: "twitter")
        aCoder.encode(twitterUserId,  forKey: "twitterUserId")
        aCoder.encode(wordPressId,    forKey: "wordPressId")
        aCoder.encode(windowsLiveId,  forKey: "windowsLiveId")
        aCoder.encode(client,         forKey: "client")
        aCoder.encode(source,         forKey: "source")
        aCoder.encode(created,        forKey: "created")
    }

    enum GlobalResource {
        case must
        case all
        case uncategorized
        case read
        case saved
        static func values() -> [GlobalResource] { return [.must, .all, .uncategorized, .read, .saved] }

        var label: String {
            switch self {
            case .must:          return "must"
            case .all:           return "all"
            case .uncategorized: return "uncategorized"
            case .read:          return "read"
            case .saved:         return "saved"
            }
        }

        func asCategory(_ profile: Profile) -> Category {
            return FeedlyKit.Category(id: "user/\(profile.id)/category/global.\(label)", label: "global.\(label)")
        }

        func asTag(_ profile: Profile) -> Tag {
            return FeedlyKit.Tag(id: "user/\(profile.id)/tag/global.\(label)", label: "global.\(label)")
        }
    }

    open var mustCategory:          FeedlyKit.Category   { return GlobalResource.must.asCategory(self) }
    open var allCategory:           FeedlyKit.Category   { return GlobalResource.all.asCategory(self)  }
    open var uncategorizedCategory: FeedlyKit.Category   { return GlobalResource.uncategorized.asCategory(self) }
    open var readTag:               FeedlyKit.Tag        { return GlobalResource.read.asTag(self) }
    open var savedTag:              FeedlyKit.Tag        { return GlobalResource.saved.asTag(self) }

    open func category(_ label: String) -> Category {
        return FeedlyKit.Category(label: label, profile: self)
    }

    open func tag(_ label: String) -> Tag {
        return FeedlyKit.Tag(label: label, profile: self)
    }
}
