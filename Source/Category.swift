//
//  Category.swift
//  MusicFav
//
//  Created by Hiroki Kumamoto on 1/10/15.
//  Copyright (c) 2015 Hiroki Kumamoto. All rights reserved.
//

import SwiftyJSON

public class Category {
    public let id:    String
    public let label: String
    init(json: JSON) {
        id    = json["id"].stringValue
        label = json["label"].stringValue
    }
}
