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
    var statusCode: Int = 0
    var feed:  Feed?    = nil
    var feeds: [Feed]   = []
    
    override func spec() {
        describe("fetchFeed") {
            beforeEach {
                self.feed = nil
                self.client.fetchFeed(self.feedId) {
                    guard let code = $0.response?.statusCode,
                          let feed = $0.result.value else { return }
                    self.statusCode = code
                    self.feed       = feed
                }
            }
            it ("fetches a specified feed") {
                expect(self.statusCode).toEventually(equal(200))
                expect(self.feed).toEventuallyNot(beNil())
            }
        }
        describe("fetchFeeds") {
            beforeEach {
                self.feeds = []
                self.client.fetchFeeds([self.feedId, self.feedId2]) {
                    guard let code  = $0.response?.statusCode,
                          let feeds = $0.result.value else { return }
                    self.statusCode = code
                    self.feeds      = feeds
                }
            }
            it ("fetches specified feeds") {
                expect(self.statusCode).toEventually(equal(200))
                expect(self.feeds.count).toEventually(equal(2))
            }
        }
    }
}