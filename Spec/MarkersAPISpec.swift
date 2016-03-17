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
            var statusCode = 0
            var unreadCounts: UnreadCounts?
            let params = UnreadCountsParams(autoRefresh: nil, newerThan: nil, streamId: self.feedId2)
            beforeEach {
                self.client.fetchUnreadCounts(params) {
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
            var statusCode = 0
            beforeEach {
                self.fetchLatestEntries() { _entries in
                    entries = _entries
                    self.client.markEntriesAsRead(entries!.map { $0.id }) {
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
            var statusCode = 0
            beforeEach {
                self.client.keepEntriesAsUnread(entries!.map { $0.id }) {
                    guard let code = $0.response?.statusCode else { return }
                    statusCode = code
                }
            }
            it ("keeps entries as unread") {
                expect(statusCode).toFinally(equal(200))
            }
        }

        describe("markFeedsAsRead") {
            var statusCode = 0
            beforeEach {
                self.client.markFeedsAsRead([self.feedId]) {
                    guard let code = $0.response?.statusCode else { return }
                    statusCode = code
                }
            }
            it ("keeps feeds as unread") {
                expect(statusCode).toFinally(equal(200))
            }
        }

        describe("markCategoriesAsRead") {
            var statusCode = 0
            beforeEach {
                self.fetchProfile() {
                    self.client.markCategoriesAsRead([self.profile!.category("test").id]) {
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
            var statusCode = 0
            beforeEach {
                self.client.undoMarkAsRead(Marker.ItemType.Feed, itemIds: [self.feedId]) {
                    guard let code = $0.response?.statusCode else { return }
                    statusCode = code
                }
            }
            it ("undo mark as read") {
                expect(statusCode).toFinally(equal(200))
            }
        }

        describe("markEntriesAsSaved") {
            var statusCode = 0
            beforeEach {
                self.client.markEntriesAsSaved(entries!.map { $0.id }) {
                    guard let code = $0.response?.statusCode else { return }
                    statusCode = code
                }
            }
            it ("marks entries as saved") {
                expect(statusCode).toFinally(equal(200))
            }
        }

        describe("markEntriesAsUnsaved") {
            var statusCode = 0
            beforeEach {
                self.client.markEntriesAsUnsaved(entries!.map { $0.id }) {
                    guard let code = $0.response?.statusCode else { return }
                    statusCode = code
                }
            }
            it ("marks entries as unsaved") {
                expect(statusCode).toFinally(equal(200))
            }
        }

        describe("fetchLatestReadOperations") {
            var statusCode = 0
            var operations: ReadOperations?
            beforeEach {
                self.client.fetchLatestReadOperations(nil) {
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
            var statusCode = 0
            var entryIds: TaggedEntryIds?
            beforeEach {
                self.client.fetchLatestTaggedEntryIds(nil) {
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
