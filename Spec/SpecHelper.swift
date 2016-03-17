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

public class SpecHelper {
    public static let perPage = 5
    public class func fixtureJSONObject(fixtureNamed fixtureNamed: String) -> AnyObject? {
        let bundle   = NSBundle(forClass: SpecHelper.self)
        let filePath = bundle.pathForResource(fixtureNamed, ofType: "json")
        let data     = NSData(contentsOfFile: filePath!)
        let jsonObject : AnyObject? = try! NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions.MutableContainers)
        return jsonObject
    }
    public class var target: CloudAPIClient.Target {
        let json = JSON(SpecHelper.fixtureJSONObject(fixtureNamed: "access_token")!)
        if json["target"].stringValue == "production" {
            return .Production
        } else {
            return .Sandbox
        }
    }
    public class var accessToken: String? {
        let json = JSON(SpecHelper.fixtureJSONObject(fixtureNamed: "access_token")!)
        return json["access_token"].string
    }
}

extension Expectation {
    public func toFinally<U where U : Matcher, U.ValueType == T>(matcher: U) {
        self.toEventually(matcher, timeout: 10)
    }

    public func toFinallyNot<U where U : Matcher, U.ValueType == T>(matcher: U) {
        self.toEventuallyNot(matcher, timeout: 10)
    }
}

