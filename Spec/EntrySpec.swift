//
//  EntrySpec.swift
//  FeedlyKit
//
//  Created by Hiroki Kumamoto on 1/18/15.
//  Copyright (c) 2015 Hiroki Kumamoto. All rights reserved.
//

import FeedlyKit
import Quick
import Nimble
import SwiftyJSON

class EntrySpec: QuickSpec {
    override func spec() {
        describe("a entry") {
            it ("should be constructed with json") {
                let json = JSON(SpecHelper.fixtureJSONObject(fixtureNamed: "entry")!)

                let entry: Entry = Entry(json: json)
                expect(entry).notTo(beNil())
                
                expect(entry.id).notTo(beNil())
                expect(entry.title).notTo(beNil())
                expect(entry.content).notTo(beNil())
                expect(entry.summary).to(beNil())
                expect(entry.author).notTo(beNil())
                expect(entry.crawled).notTo(beNil())
                expect(entry.recrawled).notTo(beNil())
                expect(entry.published).notTo(beNil())
                expect(entry.updated).notTo(beNil())
                expect(entry.alternate).notTo(beNil())
                expect(entry.origin).notTo(beNil())
                expect(entry.keywords).notTo(beNil())
                expect(entry.visual).notTo(beNil())
                expect(entry.unread).notTo(beNil())
                expect(entry.categories).notTo(beNil())
                expect(entry.engagement).notTo(beNil())
                expect(entry.actionTimestamp).to(beNil())
                expect(entry.enclosure).to(beNil())
                expect(entry.fingerprint).to(beNil())
                expect(entry.originId).to(beNil())
                expect(entry.sid).to(beNil())
            }
        }
    }
}
