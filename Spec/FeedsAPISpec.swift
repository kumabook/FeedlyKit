//
//  FeedsAPISpec.swift
//  FeedlyKit
//
//  Created by Hiroki Kumamoto on 3/10/16.
//  Copyright © 2016 Hiroki Kumamoto. All rights reserved.
//

import Foundation
import FeedlyKit
import Quick
import Nimble

class FeedsAPISpec: QuickSpec {
    let feedId  = "feed/http://kumabook.github.io/feed.xml"
    let feedId2 = "feed/https://news.ycombinator.com/rss"
    let client: CloudAPIClient = CloudAPIClient(target: SpecHelper.target)
    
    override func spec() {
        beforeEach {
            sleep(1)
        }
        describe("fetchFeed") {
            var statusCode = 0
            var feed: Feed?
            beforeEach {
                self.client.fetchFeed(self.feedId) {
                    guard let code  = $0.response?.statusCode,
                          let _feed = $0.result.value else { return }
                    statusCode = code
                    feed       = _feed
                }
            }
            it ("fetches a specified feed") {
                expect(statusCode).toFinally(equal(200))
                expect(feed).toFinallyNot(beNil())
            }
        }
        describe("fetchFeeds") {
            var statusCode = 0
            var feeds: [Feed]?
            beforeEach {
                feeds = []
                self.client.fetchFeeds([self.feedId, self.feedId2]) {
                    guard let code   = $0.response?.statusCode,
                          let _feeds = $0.result.value else { return }
                    statusCode = code
                    feeds      = _feeds
                }
            }
            it ("fetches specified feeds") {
                expect(statusCode).toFinally(equal(200))
                expect(feeds).toFinallyNot(beNil())
                expect(feeds!.count).toFinally(equal(2))
            }
        }
    }
}