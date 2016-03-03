//
//  StringExtension.swift
//  FeedlyKit
//
//  Created by Hiroki Kumamoto on 3/3/16.
//  Copyright © 2016 Hiroki Kumamoto. All rights reserved.
//

import Foundation

internal extension String {
    internal func toURL() -> NSURL? {
        if let url = NSURL(string: self) {
            return url
        } else if let str = stringByAddingPercentEncodingWithAllowedCharacters(NSCharacterSet.URLQueryAllowedCharacterSet()) {
            return NSURL(string: str)
        }
        return nil
    }

    internal func contains(string: String) -> Bool {
        return rangeOfString(string, options: [], range: nil, locale: NSLocale.autoupdatingCurrentLocale()) != nil
    }
}