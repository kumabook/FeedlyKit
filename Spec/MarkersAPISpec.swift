//
//  MarkersAPISpec.swift
//  FeedlyKit
//
//  Created by Hiroki Kumamoto on 3/12/16.
//  Copyright © 2016 Hiroki Kumamoto. All rights reserved.
//

import Foundation
import FeedlyKit
import Quick
import Nimble

class MarkersAPISpec: CloudAPISpec {
    let feedId     = "feed/http://kumabook.github.io/feed.xml"
    let feedId2 = "feed/https://news.ycombinator.com/rss"
    override func spec() {
        beforeSuite {
            self.client.setAccessToken(SpecHelper.accessToken)
        }

        describe("fetchUnreadCounts") {
            if SpecHelper.accessToken == nil { return }
            var statusCode = 0
            var unreadCounts: UnreadCounts?
            let params = UnreadCountsParams(autoRefresh: nil, newerThan: nil, streamId: self.feedId2)
            beforeEach {
                let _ = self.client.fetchUnreadCounts(params) {
                    guard let code = $0.response?.statusCode,
                          let counts = $0.result.value else { return }
                    statusCode   = code
                    unreadCounts = counts
                }
            }
            it ("fetches unread counts") {
                expect(statusCode).toFinally(equal(200))
                expect(unreadCounts).toFinallyNot(beNil())
            }
        }

        var entries: [Entry]?
        describe("markEntriesAsRead") {
            if SpecHelper.accessToken == nil { return }
            var statusCode = 0
            beforeEach {
                self.fetchLatestEntries() { _entries in
                    entries = _entries
                    let _ = self.client.markEntriesAsRead(entries!.map { $0.id }) {
                        guard let code = $0.response?.statusCode else { return }
                        statusCode = code
                    }
                }
            }
            it ("marks entries as read") {
                expect(entries).toFinallyNot(beNil())
                expect(statusCode).toFinally(equal(200))
            }
        }

        describe("keepEntriesAsUnread") {
            if SpecHelper.accessToken == nil { return }
            var statusCode = 0
            beforeEach {
                let _ = self.client.keepEntriesAsUnread(entries!.map { $0.id }) {
                    guard let code = $0.response?.statusCode else { return }
                    statusCode = code
                }
            }
            it ("keeps entries as unread") {
                expect(statusCode).toFinally(equal(200))
            }
        }

        describe("markFeedsAsRead") {
            if SpecHelper.accessToken == nil { return }
            var statusCode = 0
            beforeEach {
                let _ = self.client.markFeedsAsRead([self.feedId]) {
                    guard let code = $0.response?.statusCode else { return }
                    statusCode = code
                }
            }
            it ("keeps feeds as unread") {
                expect(statusCode).toFinally(equal(200))
            }
        }

        describe("markCategoriesAsRead") {
            if SpecHelper.accessToken == nil { return }
            var statusCode = 0
            beforeEach {
                self.fetchProfile() {
                    let _ = self.client.markCategoriesAsRead([self.profile!.category("test").id]) {
                        guard let code = $0.response?.statusCode else { return }
                        statusCode = code
                    }
                }
            }
            it ("keeps categories as read") {
                expect(statusCode).toFinally(equal(200))
            }
        }

        describe("undoMarkAsRead") {
            if SpecHelper.accessToken == nil { return }
            var statusCode = 0
            beforeEach {
               let _ =  self.client.undoMarkAsRead(Marker.ItemType.feed, itemIds: [self.feedId]) {
                    guard let code = $0.response?.statusCode else { return }
                    statusCode = code
                }
            }
            it ("undo mark as read") {
                expect(statusCode).toFinally(equal(200))
            }
        }

        describe("markEntriesAsSaved") {
            if SpecHelper.accessToken == nil { return }
            var statusCode = 0
            beforeEach {
                let _ = self.client.markEntriesAsSaved(entries!.map { $0.id }) {
                    guard let code = $0.response?.statusCode else { return }
                    statusCode = code
                }
            }
            it ("marks entries as saved") {
                expect(statusCode).toFinally(equal(200))
            }
        }

        describe("markEntriesAsUnsaved") {
            if SpecHelper.accessToken == nil { return }
            var statusCode = 0
            beforeEach {
                let _ = self.client.markEntriesAsUnsaved(entries!.map { $0.id }) {
                    guard let code = $0.response?.statusCode else { return }
                    statusCode = code
                }
            }
            it ("marks entries as unsaved") {
                expect(statusCode).toFinally(equal(200))
            }
        }

        describe("fetchLatestReadOperations") {
            if SpecHelper.accessToken == nil { return }
            var statusCode = 0
            var operations: ReadOperations?
            beforeEach {
                let _ = self.client.fetchLatestReadOperations(nil) {
                    guard let code = $0.response?.statusCode,
                          let items = $0.result.value else { return }
                    statusCode = code
                    operations = items
                }
            }
            it ("fetches latest read operations") {
                expect(statusCode).toFinally(equal(200))
                expect(operations).toFinallyNot(beNil())
            }
        }

        describe("fetchLatestTaggedEntryIds") {
            if SpecHelper.accessToken == nil { return }
            var statusCode = 0
            var entryIds: TaggedEntryIds?
            beforeEach {
                let _ = self.client.fetchLatestTaggedEntryIds(nil) {
                    guard let code = $0.response?.statusCode,
                        let ids = $0.result.value else { return }
                    statusCode = code
                    entryIds = ids
                }
            }
            it ("fetches latest tagged entries") {
                expect(statusCode).toFinally(equal(200))
                expect(entryIds).toFinallyNot(beNil())
            }
        }
    }
}
