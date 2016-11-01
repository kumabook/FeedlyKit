//
//  PreferencesAPISpec.swift
//  FeedlyKit
//
//  Created by Hiroki Kumamoto on 4/6/16.
//  Copyright © 2016 Hiroki Kumamoto. All rights reserved.
//

import Foundation
import FeedlyKit
import Quick
import Nimble

class PreferencesAPISpec: QuickSpec {
    let client: CloudAPIClient = CloudAPIClient(target: SpecHelper.target)

    override func spec() {
        beforeSuite {
            self.client.setAccessToken(SpecHelper.accessToken)
        }
        describe("fetchPrefernce") {
            if SpecHelper.accessToken == nil { return }
            var statusCode = 0
            var preferences: Preferences?
            beforeEach {
                let _ = self.client.fetchPreferences {
                    guard let code = $0.response?.statusCode else { return }
                    statusCode = code
                    preferences = $0.result.value!
                }
            }
            it("fetches preferences") {
                expect(statusCode).toFinally(equal(200))
                expect(preferences).toFinallyNot(beNil())
            }
        }
        
        describe("updatePreferences") {
            if SpecHelper.accessToken == nil { return }
            var statusCode1 = 0
            var statusCode2 = 0
            var statusCode3 = 0
            var statusCode4 = 0
            
            var preferences1: Preferences?
            var preferences2: Preferences?
            let params1: [String:String] = ["key1": "xxxxxx", "key2": "value2"]
            let params2: [String:String] = ["key1": "value1", "key2": "==DELETE=="]
            beforeEach {
                let _ = self.client.updatePreferences(params1) {
                    guard let code = $0.response?.statusCode else { return }
                    statusCode1 = code
                }
                sleep(1)
                let _ = self.client.fetchPreferences {
                    guard let code = $0.response?.statusCode else { return }
                    statusCode2  = code
                    preferences1 = $0.result.value!
                }
                sleep(1)
                let _ = self.client.updatePreferences(params2 ) {
                    guard let code = $0.response?.statusCode else { return }
                    statusCode3 = code
                }
                sleep(1)
                let _ = self.client.fetchPreferences {
                    guard let code = $0.response?.statusCode else { return }
                    statusCode4  = code
                    preferences2 = $0.result.value!
                }
            }
            it("update a preferences") {
                expect(statusCode1).toFinally(equal(200))
                expect(statusCode2).toFinally(equal(200))
                expect(preferences1).toFinallyNot(beNil())
                expect(preferences1!.values["key1"]).toFinally(equal("xxxxxx"))
                expect(preferences1!.values["key2"]).toFinally(equal("value2"))
                expect(statusCode3).toFinally(equal(200))
                expect(statusCode4).toFinally(equal(200))
                expect(preferences2).toFinallyNot(beNil())
                expect(preferences2!.values["key1"]).toFinally(equal("value1"))
                expect(preferences2!.values["key2"]).toFinally(beNil())
            }
        }
    }
}
