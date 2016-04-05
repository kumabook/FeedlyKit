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
    public func fetchPreferences(completionHandler: (Response<Preferences, NSError>) -> Void) -> Request {
        return manager.request(Router.FetchPreferences(target)).validate().responseObject(completionHandler)
    }
    
    /**
     Update the preferences of the user
     POST /v3/preferences
     */
    public func updatePreferences(preferences: [String:String], completionHandler: (Response<Void, NSError>) -> Void) -> Request {
        return manager.request(Router.UpdatePreferences(target, preferences)).validate().response(completionHandler)
    }
}

