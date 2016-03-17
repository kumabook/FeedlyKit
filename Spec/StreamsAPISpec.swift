//
//  StreamsAPISpec.swift
//  FeedlyKit
//
//  Created by Hiroki Kumamoto on 3/10/16.
//  Copyright © 2016 Hiroki Kumamoto. All rights reserved.
//

import Foundation

import FeedlyKit
import Quick
import Nimble

class StreamsAPISpec: QuickSpec {
    let perPage = 5
    let feedId  = "feed/http://kumabook.github.io/feed.xml"

    let client: CloudAPIClient = CloudAPIClient(target: SpecHelper.target)
    var entryIds:   [String] = []
    var entries:    [Entry]  = []

    override func spec() {
        describe("fetchIds") {
            var statusCode = 0
            beforeEach {
                let params = PaginationParams()
                params.count = self.perPage
                self.client.fetchEntryIds(self.feedId, paginationParams: params) {
                    guard let code = $0.response?.statusCode,
                          let val  = $0.result.value else { return }
                    statusCode    = code
                    self.entryIds = val.ids
                }
            }
            it ("fetch entries ids") {
                expect(statusCode).toFinally(equal(200))
                expect(self.entryIds.count).toFinally(equal(self.perPage))
            }
        }

        describe("fetchContents") {
            var statusCode = 0
            beforeEach {
                let params = PaginationParams()
                params.count = self.perPage
                self.client.fetchContents(self.feedId, paginationParams: params) {
                    guard let code = $0.response?.statusCode,
                          let val  = $0.result.value else { return }
                    statusCode   = code
                    self.entries = val.items
                }
            }
            it ("fetches entries contents") {
                expect(statusCode).toFinally(equal(200))
                expect(self.entries.count).toFinally(equal(self.perPage))
            }
        }

        describe("Pagination") {
            let params = PaginationParams()
            params.count = self.perPage
            params.continuation = ""
            var statusCode = 0
            func clear() {
                self.entryIds       = []
                params.continuation = ""
            }
            func fetchIds(params: PaginationParams, times: Int) {
                if times == 0 { return }
                sleep(1);
                self.client.fetchEntryIds(self.feedId, paginationParams: params) {
                    guard let code = $0.response?.statusCode,
                          let val  = $0.result.value else { return }
                    statusCode     = code
                    self.entryIds.appendContentsOf(val.ids)
                    params.continuation = val.continuation
                    if times > 0 && params.continuation != nil {
                        fetchIds(params, times: times - 1)
                    }
                }
            }
            context("first page") {
                statusCode = 0
                beforeEach {
                    clear()
                    fetchIds(params, times: 1)
                }
                it ("fetches first page") {
                    expect(statusCode).toFinally(equal(200))
                    expect(self.entryIds.count).toFinally(equal(self.perPage))
                }
            }
            context("second page") {
                statusCode = 0
                beforeEach {
                    clear()
                    fetchIds(params, times: 2)
                }
                it ("fetches second page") {
                    expect(statusCode).toFinally(equal(200))
                    expect(self.entryIds.count).toFinally(equal(self.perPage * 2))
                }
            }
/*            context("last page") {
                statusCode = 0
                beforeEach {
                    clear()
                    fetchIds(params, times: Int.max)
                }
                it ("eventually fetches last page") {
                    expect(params.continuation).toEventually(beNil())
                }
            }*/
        }
    }
}

