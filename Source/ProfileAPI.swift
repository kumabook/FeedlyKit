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
    public func fetchProfile(_ completionHandler: @escaping (DataResponse<Profile>) -> Void) -> Request {
        return manager.request(Router.fetchProfile(target)).validate().responseObject(completionHandler: completionHandler)
    }


    /**
        Update the profile of the user
        POST /v3/profile
    */
    public func updateProfile(_ params: [String:Any], completionHandler: @escaping (DataResponse<Profile>) -> Void) -> Request {
        return manager.request(Router.updateProfile(target, params)).validate().responseObject(completionHandler: completionHandler)
    }
}
