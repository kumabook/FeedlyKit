//
//  ProfileSpec.swift
//  FeedlyKit
//
//  Created by Hiroki Kumamoto on 1/16/15.
//  Copyright (c) 2015 Hiroki Kumamoto. All rights reserved.
//

import FeedlyKit
import Quick
import Nimble
import SwiftyJSON


class ProfileSpec: QuickSpec {
    override func spec() {
        describe("a profile") {
            it ("should be constructed with json") {
                let json = JSON(SpecHelper.fixtureJSONObject(fixtureNamed: "profile")!)
                let profile: Profile = Profile(json: json)
                expect(profile).notTo(beNil())

                expect(profile.id).notTo(beNil())
                expect(profile.email).notTo(beNil())
                expect(profile.reader).notTo(beNil())
                expect(profile.gender).notTo(beNil())
                expect(profile.wave).notTo(beNil())
                expect(profile.google).notTo(beNil())
                expect(profile.facebook).notTo(beNil())
                expect(profile.familyName).notTo(beNil())
                expect(profile.picture).notTo(beNil())
                expect(profile.twitter).notTo(beNil())
                expect(profile.givenName).notTo(beNil())
                expect(profile.locale).notTo(beNil())
            }
        }
    }
}

