//
//  PreferencesAPI.swift
//  FeedlyKit
//
//  Created by Hiroki Kumamoto on 4/5/16.
//  Copyright © 2016 Hiroki Kumamoto. All rights reserved.
//


import Alamofire
import SwiftyJSON

extension CloudAPIClient {
    
    /**
     Get the preferences of the user
     GET /v3/preferences
     @param completionHandler handler function
     @return self
     */
    public func fetchPreferences(_ completionHandler: @escaping (DataResponse<Preferences>) -> Void) -> Request {
        return manager.request(Router.fetchPreferences(target)).validate().responseObject(completionHandler: completionHandler)
    }
    
    /**
     Update the preferences of the user
     POST /v3/preferences
     */
    public func updatePreferences(_ preferences: [String:String], completionHandler: @escaping (DefaultDataResponse) -> Void) -> Request {
        return manager.request(Router.updatePreferences(target, preferences)).validate().response(completionHandler: completionHandler)
    }
}

