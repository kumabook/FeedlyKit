//
//  CloudAPISpec.swift
//  FeedlyKit
//
//  Created by Hiroki Kumamoto on 1/17/15.
//  Copyright (c) 2015 Hiroki Kumamoto. All rights reserved.
//

import Foundation

import FeedlyKit
import Quick
import Nimble

class CloudAPISpec: QuickSpec {
    override func spec() {
        describe("a profile") {
            var profile: Profile? = nil
            expect(profile).to(beNil())
        }
    }
}

