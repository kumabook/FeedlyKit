//
//  SpecHelper.swift
//  FeedlyKit
//
//  Created by Hiroki Kumamoto on 1/17/15.
//  Copyright (c) 2015 Hiroki Kumamoto. All rights reserved.
//

import Foundation
import FeedlyKit
import Nimble

public class SpecHelper {
    public class func fixtureJSONObject(fixtureNamed fixtureNamed: String) -> AnyObject? {
        let bundle   = NSBundle(forClass: SpecHelper.self)
        let filePath = bundle.pathForResource(fixtureNamed, ofType: "json")
        let data     = NSData(contentsOfFile: filePath!)
        let jsonObject : AnyObject? = try! NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions.MutableContainers)
        return jsonObject
    }
    public class var target: CloudAPIClient.Target {
        return .Production
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

