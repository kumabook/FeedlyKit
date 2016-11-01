//
//  SubscriptionsAPISpec.swift
//  FeedlyKit
//
//  Created by Hiroki Kumamoto on 3/11/16.
//  Copyright © 2016 Hiroki Kumamoto. All rights reserved.
//

import Foundation
import FeedlyKit
import Quick
import Nimble

class SubscriptionAPISpec: QuickSpec {
    let feedId  = "feed/http://kumabook.github.io/feed.xml"
    let feedId2 = "feed/https://news.ycombinator.com/rss"
    let client: CloudAPIClient = CloudAPIClient(target: SpecHelper.target)
    var feed:  Feed!    = nil
    var subscriptions: [Subscription] = []

    func fetchSubscriptions(callback: @escaping (Int, [Subscription]) -> ()) {
        let _ = self.client.fetchSubscriptions {
            guard let code = $0.response?.statusCode,
                let subscriptions = $0.result.value else { return }
                callback(code, subscriptions)
        }
    }

    override func spec() {
        beforeSuite {
            self.feed = Feed(id: self.feedId, title: "", description: "", subscribers: 0)
            self.client.setAccessToken(SpecHelper.accessToken)
        }
        describe("fetchSubscriptions") {
            if SpecHelper.accessToken == nil { return }
            var statusCode = 0
            beforeEach {
                self.fetchSubscriptions {
                    statusCode         = $0
                    self.subscriptions = $1
                }
            }
            it ("fetches a specified feed") {
                expect(statusCode).toFinally(equal(200))
            }
        }
        describe("subscribeTo") {
            if SpecHelper.accessToken == nil { return }
            var isFinish = false
            var statusCode = 0
            beforeEach {
                self.fetchSubscriptions { _, _ in
                    let _ = self.client.subscribeTo(self.feed, categories: []) {
                        guard let code = $0.response?.statusCode else { return }
                        statusCode = code
                        self.fetchSubscriptions {
                            self.subscriptions = $1
                            isFinish = true
                        }
                    }
                }
            }
            it ("subscribes to a feed") {
                expect(statusCode).toFinally(equal(200))
                expect(isFinish).toFinally(beTrue())
                expect(self.subscriptions.map { $0.id }).to(contain(self.feed.id))
            }
        }

        describe("updateSubscription") {
            if SpecHelper.accessToken == nil { return }
            let s = Subscription(id: self.feedId, title: "kumabook_test", categories: [])
            var statusCode = 0
            beforeEach {
                let _ = self.client.updateSubscription(s) {
                    guard let code = $0.response?.statusCode else { return }
                    statusCode = code
                }
            }
            it ("update a subscription") {
                expect(statusCode).toFinally(equal(200))
            }
        }

        describe("unsubscribeTo") {
            if SpecHelper.accessToken == nil { return }
            var isFinish = false
            var statusCode = 0
            beforeEach {
                let _ = self.client.unsubscribeTo(self.feedId) {
                    guard let code = $0.response?.statusCode else { return }
                    statusCode = code
                    self.fetchSubscriptions {
                        self.subscriptions = $1
                        isFinish = true
                    }
                }
            }
            it ("unsubscribes to a feed") {
                expect(statusCode).toFinally(equal(200))
                expect(isFinish).toFinally(beTrue())
                expect(self.subscriptions.map { $0.id }).notTo(contain(self.feed.id))
            }
        }
    }
}
