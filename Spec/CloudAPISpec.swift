//
//  CloudAPISpec.swift
//  FeedlyKit
//
//  Created by Hiroki Kumamoto on 1/17/15.
//  Copyright (c) 2015 Hiroki Kumamoto. All rights reserved.
//

import Foundation

import FeedlyKit
import Quick
import Nimble

class CloudAPISpec: QuickSpec {
    internal let client: CloudAPIClient = CloudAPIClient(target: SpecHelper.target)
    var profile: Profile?

    func fetchProfile(callback: () -> ()) {
        self.client.fetchProfile {
            guard let _ = $0.response?.statusCode,
                  let profile = $0.result.value else { return }
            self.profile = profile
            callback()
        }
    }
}

