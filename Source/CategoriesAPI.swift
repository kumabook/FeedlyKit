//
//  CategoriesAPI.swift
//  FeedlyKit
//
//  Created by Hiroki Kumamoto on 1/20/15.
//  Copyright (c) 2015 Hiroki Kumamoto. All rights reserved.
//

import Alamofire
import SwiftyJSON


extension CloudAPIClient {
    /**
        Get the list of all categories
        GET /v3/categories
        (Authorization is required)
    */
    public func fetchCategories(_ completionHandler: @escaping (DataResponse<[Category]>) -> Void) -> Request {
        return manager.request(Router.fetchCategories(target)).validate().responseCollection(completionHandler: completionHandler)
    }
    
    /**
        Change the label of an existing category
        POST /v3/categories/:categoryId
        (Authorization is required)
    */
    public func updateCategory(_ categoryId: String, label: String, completionHandler: @escaping (DefaultDataResponse) -> Void) -> Request {
        return manager.request(Router.updateCategory(target, categoryId, label)).validate().response(completionHandler: completionHandler)
    }
    
    /**
        Delete a category
        DELETE /v3/categories/:categoryId
        (Authorization is required)
    */
    public func deleteCategory(_ categoryId: String, completionHandler: @escaping (DefaultDataResponse) -> Void) -> Request {
        return manager.request(Router.deleteCategory(target, categoryId)).validate().response(completionHandler: completionHandler)
    }
}
