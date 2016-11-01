//
//  Profile.swift
//  MusicFav
//
//  Created by Hiroki Kumamoto on 1/4/15.
//  Copyright (c) 2015 Hiroki Kumamoto. All rights reserved.
//

import SwiftyJSON

open class Profile: NSObject, NSCoding, ResponseObjectSerializable {
    open var id:         String
    open var email:      String?
    open var reader:     String?
    open var gender:     String?
    open var wave:       String?
    open var google:     String?
    open var facebook:   String?
    open var familyName: String?
    open var picture:    String?
    open var twitter:    String?
    open var givenName:  String?
    open var locale:     String?

    required public convenience init?(response: HTTPURLResponse, representation: Any) {
        let json = JSON(representation)
        self.init(json: json)
    }

    public init(id: String) {
        self.id = id
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
        id         = aDecoder.decodeObject(forKey: "id")         as! String
        email      = aDecoder.decodeObject(forKey: "email")      as! String?
        reader     = aDecoder.decodeObject(forKey: "reader")     as! String?
        gender     = aDecoder.decodeObject(forKey: "gender")     as! String?
        wave       = aDecoder.decodeObject(forKey: "wave")       as! String?
        google     = aDecoder.decodeObject(forKey: "google")     as! String?
        facebook   = aDecoder.decodeObject(forKey: "facebook")   as! String?
        familyName = aDecoder.decodeObject(forKey: "familyName") as! String?
        picture    = aDecoder.decodeObject(forKey: "picture")    as! String?
        twitter    = aDecoder.decodeObject(forKey: "twitter")    as! String?
        givenName  = aDecoder.decodeObject(forKey: "givenName")  as! String?
        locale     = aDecoder.decodeObject(forKey: "locale")     as! String?
    }
    
    open func encode(with aCoder: NSCoder) {
        aCoder.encode(id,         forKey: "id")
        aCoder.encode(email,      forKey: "email")
        aCoder.encode(reader,     forKey: "reader")
        aCoder.encode(gender,     forKey: "gender")
        aCoder.encode(wave,       forKey: "wave")
        aCoder.encode(google,     forKey: "google")
        aCoder.encode(facebook,   forKey: "facebook")
        aCoder.encode(familyName, forKey: "familyName")
        aCoder.encode(picture,    forKey: "picture")
        aCoder.encode(twitter,    forKey: "twitter")
        aCoder.encode(givenName,  forKey: "givenName")
        aCoder.encode(locale,     forKey: "locale")
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
