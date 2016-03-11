//
//  ProfileAPISpec.swift
//  FeedlyKit
//
//  Created by Hiroki Kumamoto on 3/11/16.
//  Copyright © 2016 Hiroki Kumamoto. All rights reserved.
//

import Foundation
import FeedlyKit
import Quick
import Nimble

class ProfileAPISpec: QuickSpec {
    let client: CloudAPIClient = CloudAPIClient(target: SpecHelper.target)
    override func spec() {
        beforeSuite {
            self.client.setAccessToken(SpecHelper.accessToken)
        }
        describe("fetchProfile") {
            if SpecHelper.accessToken == nil { return }
            var statusCode = 0
            var profile: Profile?
            beforeEach {
                self.client.fetchProfile {
                    guard let code = $0.response?.statusCode else { return }
                    statusCode = code
                    profile = $0.result.value
                }
            }
            it("fetches a profile") {
                expect(statusCode).toFinally(equal(200))
                expect(profile).toFinallyNot(beNil())
            }
        }

        describe("updateProfile") {
            if SpecHelper.accessToken == nil { return }
            var statusCode = 0
            var profile: Profile?
            let params: [String:AnyObject] = ["givenName": "hiroki", "gender": true]
            beforeEach {
                self.client.updateProfile(params) {
                    guard let code = $0.response?.statusCode else { return }
                    statusCode = code
                    profile = $0.result.value
                }
            }
            it("update a profile") {
                expect(statusCode).toFinally(equal(200))
                expect(profile).toFinallyNot(beNil())
            }
        }
    }
}