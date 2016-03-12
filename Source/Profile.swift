//
//  Profile.swift
//  MusicFav
//
//  Created by Hiroki Kumamoto on 1/4/15.
//  Copyright (c) 2015 Hiroki Kumamoto. All rights reserved.
//

import SwiftyJSON

public class Profile: NSObject, NSCoding, ResponseObjectSerializable {
    public let id:         String
    public let email:      String?
    public let reader:     String?
    public let gender:     String?
    public let wave:       String?
    public let google:     String?
    public let facebook:   String?
    public let familyName: String?
    public let picture:    String?
    public let twitter:    String?
    public let givenName:  String?
    public let locale:     String?

    required public convenience init?(response: NSHTTPURLResponse, representation: AnyObject) {
        let json = JSON(representation)
        self.init(json: json)
    }

    public init(json: JSON) {
        id         = json["id"].stringValue
        email      = json["email"].string
        reader     = json["reader"].string
        gender     = json["gender"].string
        wave       = json["wave"].string
        google     = json["google"].string
        facebook   = json["facebook"].string
        familyName = json["familyName"].string
        picture    = json["picture"].string
        twitter    = json["twitter"].string
        givenName  = json["givenName"].string
        locale     = json["locale"].string
    }
    required public init?(coder aDecoder: NSCoder) {
        id         = aDecoder.decodeObjectForKey("id")         as! String
        email      = aDecoder.decodeObjectForKey("email")      as! String?
        reader     = aDecoder.decodeObjectForKey("reader")     as! String?
        gender     = aDecoder.decodeObjectForKey("gender")     as! String?
        wave       = aDecoder.decodeObjectForKey("wave")       as! String?
        google     = aDecoder.decodeObjectForKey("google")     as! String?
        facebook   = aDecoder.decodeObjectForKey("facebook")   as! String?
        familyName = aDecoder.decodeObjectForKey("familyName") as! String?
        picture    = aDecoder.decodeObjectForKey("picture")    as! String?
        twitter    = aDecoder.decodeObjectForKey("twitter")    as! String?
        givenName  = aDecoder.decodeObjectForKey("givenName")  as! String?
        locale     = aDecoder.decodeObjectForKey("locale")     as! String?
    }
    
    public func encodeWithCoder(aCoder: NSCoder) {
        aCoder.encodeObject(id,         forKey: "id")
        aCoder.encodeObject(email,      forKey: "email")
        aCoder.encodeObject(reader,     forKey: "reader")
        aCoder.encodeObject(gender,     forKey: "gender")
        aCoder.encodeObject(wave,       forKey: "wave")
        aCoder.encodeObject(google,     forKey: "google")
        aCoder.encodeObject(facebook,   forKey: "facebook")
        aCoder.encodeObject(familyName, forKey: "familyName")
        aCoder.encodeObject(picture,    forKey: "picture")
        aCoder.encodeObject(twitter,    forKey: "twitter")
        aCoder.encodeObject(givenName,  forKey: "givenName")
        aCoder.encodeObject(locale,     forKey: "locale")
    }

    enum GlobalResource {
        case Must
        case All
        case Uncategorized
        case Read
        case Saved
        static func values() -> [GlobalResource] { return [.Must, .All, .Uncategorized, .Read, .Saved] }

        var label: String {
            switch self {
            case Must:          return "must"
            case All:           return "all"
            case Uncategorized: return "uncategorized"
            case Read:          return "read"
            case Saved:         return "saved"
            }
        }

        func asCategory(profile: Profile) -> Category {
            return FeedlyKit.Category(id: "user/\(profile.id)/category/global.\(label)", label: "global.\(label)")
        }

        func asTag(profile: Profile) -> Tag {
            return FeedlyKit.Tag(id: "user/\(profile.id)/tag/global.\(label)", label: "global.\(label)")
        }
    }

    public var mustCategory:          FeedlyKit.Category   { return GlobalResource.Must.asCategory(self) }
    public var allCategory:           FeedlyKit.Category   { return GlobalResource.All.asCategory(self)  }
    public var uncategorizedCategory: FeedlyKit.Category   { return GlobalResource.Uncategorized.asCategory(self) }
    public var readTag:               FeedlyKit.Tag        { return GlobalResource.Read.asTag(self) }
    public var savedTag:              FeedlyKit.Tag        { return GlobalResource.Saved.asTag(self) }

    public func category(label: String) -> Category {
        return FeedlyKit.Category(label: label, profile: self)
    }

    public func tag(label: String) -> Tag {
        return FeedlyKit.Tag(label: label, profile: self)
    }
}
