//
//  StringExtension.swift
//  FeedlyKit
//
//  Created by Hiroki Kumamoto on 3/3/16.
//  Copyright © 2016 Hiroki Kumamoto. All rights reserved.
//

import Foundation

internal extension String {
    internal func toURL() -> URL? {
        if let url = URL(string: self) {
            return url
        } else if let str = addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed) {
            return URL(string: str)
        }
        return nil
    }

    internal func contains(_ string: String) -> Bool {
        return range(of: string, options: [], range: nil, locale: Foundation.Locale.autoupdatingCurrent) != nil
    }
}
