//
//  ProfileAPI.swift
//  FeedlyKit
//
//  Created by Hiroki Kumamoto on 1/20/15.
//  Copyright (c) 2015 Hiroki Kumamoto. All rights reserved.
//

import Alamofire
import SwiftyJSON

extension CloudAPIClient {
    /**
        Get the profile of the user
        GET /v3/profile
    */
    public func fetchProfile(completionHandler: (Response<Profile, NSError>) -> Void) -> Request {
        return manager.request(Router.FetchProfile(target)).validate().responseObject(completionHandler)
    }


    /**
        Update the profile of the user
        POST /v3/profile
    */
    public func updateProfile(params: [String:AnyObject], completionHandler: (Response<Profile, NSError>) -> Void) -> Request {
        return manager.request(Router.UpdateProfile(target, params)).validate().responseObject(completionHandler)
    }
}