//
//  Profile.swift
//  MusicFav
//
//  Created by Hiroki Kumamoto on 1/4/15.
//  Copyright (c) 2015 Hiroki Kumamoto. All rights reserved.
//

import SwiftyJSON

public class Profile: NSObject, NSCoding {
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

    public init (json: JSON) {
        id         = json["id"].string!
        email      = json["email"].string?
        reader     = json["reader"].string?
        gender     = json["gender"].string?
        wave       = json["wave"].string?
        google     = json["google"].string?
        facebook   = json["facebook"].string?
        familyName = json["familyName"].string?
        picture    = json["picture"].string?
        twitter    = json["twitter"].string?
        givenName  = json["givenName"].string?
        locale     = json["locale"].string?
    }
    required public init(coder aDecoder: NSCoder) {
        id         = aDecoder.decodeObjectForKey("id")         as String
        email      = aDecoder.decodeObjectForKey("email")      as String?
        reader     = aDecoder.decodeObjectForKey("reader")     as String?
        gender     = aDecoder.decodeObjectForKey("gender")     as String?
        wave       = aDecoder.decodeObjectForKey("wave")       as String?
        google     = aDecoder.decodeObjectForKey("google")     as String?
        facebook   = aDecoder.decodeObjectForKey("facebook")   as String?
        familyName = aDecoder.decodeObjectForKey("familyName") as String?
        picture    = aDecoder.decodeObjectForKey("picture")    as String?
        twitter    = aDecoder.decodeObjectForKey("twitter")    as String?
        givenName  = aDecoder.decodeObjectForKey("givenName")  as String?
        locale     = aDecoder.decodeObjectForKey("locale")     as String?
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
}
