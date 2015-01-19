//
//  Subscription.swift
//  FeedlyKit
//
//  Created by Hiroki Kumamoto on 1/18/15.
//  Copyright (c) 2015 Hiroki Kumamoto. All rights reserved.
//

import SwiftyJSON


import FeedlyKit
import Quick
import Nimble
import SwiftyJSON

class SubscriptionSpec: QuickSpec {
    override func spec() {
        describe("a subscription") {
            it ("should be constructed with json") {
                let json = JSON(SpecHelper.fixtureJSONObject(fixtureNamed: "subscription")!)

                var feed: Subscription = Subscription(json: json)
                expect(feed).notTo(beNil())
                
                expect(feed.id).notTo(beNil())
                expect(feed.title).notTo(beNil())
                expect(feed.categories).notTo(beNil())

                expect(feed.categories.count).to(equal(3))
                for category in feed.categories {
                    expect(category.id).notTo(beNil())
                    expect(category.label).notTo(beNil())
                }
            }
        }
    }
}

