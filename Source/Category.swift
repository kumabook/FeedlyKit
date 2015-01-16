//
//  Category.swift
//  MusicFav
//
//  Created by Hiroki Kumamoto on 1/10/15.
//  Copyright (c) 2015 Hiroki Kumamoto. All rights reserved.
//

import SwiftyJSON

class Category {
    let id:    String
    let label: String
    init(json: JSON) {
        id    = json["id"].string!
        label = json["label"].string!
    }
}
