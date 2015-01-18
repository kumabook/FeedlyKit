//
//  FeedSpec.swift
//  FeedlyKit
//
//  Created by Hiroki Kumamoto on 1/18/15.
//  Copyright (c) 2015 Hiroki Kumamoto. All rights reserved.
//

import FeedlyKit
import Quick
import Nimble
import SwiftyJSON

class FeedSpec: QuickSpec {
    override func spec() {
        describe("a feed") {
            it ("should be constructed with json") {
                let json = JSON(SpecHelper.fixtureJSONObject(fixtureNamed: "feed")!)

                var feed: Feed = Feed(json: json)
                expect(feed).notTo(beNil())
            }
        }
    }
}
