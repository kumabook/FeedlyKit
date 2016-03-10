//
//  EntriesAPISpec.swift
//  FeedlyKit
//
//  Created by Hiroki Kumamoto on 3/11/16.
//  Copyright © 2016 Hiroki Kumamoto. All rights reserved.
//

import Foundation
import FeedlyKit
import Quick
import Nimble

class EntriesAPISpec: QuickSpec {
    let perPage = 5
    let feedId  = "feed/http://kumabook.github.io/feed.xml"
    let client: CloudAPIClient = CloudAPIClient(target: SpecHelper.target)
    
    func fetchEntryIds(callback: ([String]) -> ()) {
        let params = PaginationParams()
        params.count = self.perPage
        self.client.fetchEntryIds(self.feedId, paginationParams: params) {
            guard let val  = $0.result.value else {
                return
            }
            callback(val.ids)
        }

    }
    
    override func spec() {
        describe("fetchEntry") {
            var statusCode = 0
            var entry: Entry?
            beforeEach {
                self.fetchEntryIds { entryIds in
                    self.client.fetchEntry(entryIds[0]) {
                        guard let code   = $0.response?.statusCode,
                              let _entry = $0.result.value else { return }
                        statusCode = code
                        entry      = _entry
                    }
                }
            }

            it ("fetches the content of an entry") {
                expect(statusCode).toFinally(equal(200))
                expect(entry).toFinallyNot(beNil())
            }
        }
        describe("fetchEntries") {
            var statusCode = 0
            var entries: [Entry]?
            beforeEach {
                self.fetchEntryIds { entryIds in
                    self.client.fetchEntries(entryIds) {
                        guard let code  = $0.response?.statusCode,
                              let items = $0.result.value else { return }
                        statusCode = code
                        entries    = items
                    }
                }
            }

            it ("fetches the contents of entries") {
                expect(statusCode).toEventually(equal(200))
                expect(entries).toEventuallyNot(beNil())
                expect(entries!.count).toEventually(equal(self.perPage))
            }
        }
    }
}
