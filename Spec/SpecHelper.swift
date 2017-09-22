//
//  SpecHelper.swift
//  FeedlyKit
//
//  Created by Hiroki Kumamoto on 1/17/15.
//  Copyright (c) 2015 Hiroki Kumamoto. All rights reserved.
//

import Foundation
import FeedlyKit
import Quick
import Nimble
import SwiftyJSON

open class SpecHelper {
    open static let perPage = 5
    open class func fixtureJSONObject(fixtureNamed: String) -> AnyObject? {
        let bundle   = Bundle(for: SpecHelper.self)
        let filePath = bundle.path(forResource: fixtureNamed, ofType: "json")
        let data     = try? Data(contentsOf: URL(fileURLWithPath: filePath!))
        let jsonObject : AnyObject? = try! JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.mutableContainers) as AnyObject?
        return jsonObject
    }
    open class var target: CloudAPIClient.Target {
        let json = JSON(SpecHelper.fixtureJSONObject(fixtureNamed: "access_token")!)
        if json["target"].stringValue == "production" {
            return .production
        } else {
            return .sandbox
        }
    }
    open class var accessToken: String? {
        let json = JSON(SpecHelper.fixtureJSONObject(fixtureNamed: "access_token")!)
        return json["access_token"].string
    }
}

extension Expectation {
    public func toFinally(_ predicate: Nimble.Predicate<T>) {
        self.toEventually(predicate, timeout: 10)
    }

    public func toFinallyNot(_ predicate: Nimble.Predicate<T>) {
        self.toEventuallyNot(predicate, timeout: 10)
    }
}

