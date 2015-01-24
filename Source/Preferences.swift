//
//  Preferences.swift
//  FeedlyKit
//
//  Created by Hiroki Kumamoto on 1/18/15.
//  Copyright (c) 2015 Hiroki Kumamoto. All rights reserved.
//

import SwiftyJSON

public class Prefereces: ResponseObjectSerializable {
    let values: [String:String]
    required public convenience init?(response: NSHTTPURLResponse, representation: AnyObject) {
        let json = JSON(representation)
        self.init(json: json)
    }
    init(json: JSON) {
        var dic: [String:String] = [:]
        for (key, val) in json.dictionaryValue {
            dic[key] = val.string!
        }
        values = dic
    }
}