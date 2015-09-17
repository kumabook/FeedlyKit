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
    public func fetchCategories(completionHandler: (NSURLRequest?, NSHTTPURLResponse?, Result<[Category]>) -> Void) -> Request {
        return manager.request(Router.FetchCategories(target)).validate().responseCollection(completionHandler)
    }
    
    /**
        Change the label of an existing category
        POST /v3/categories/:categoryId
        (Authorization is required)
    */
    public func updateCategory(categoryId: String, label: String, completionHandler:(NSURLRequest?, NSHTTPURLResponse?, Result<Void>) -> Void) -> Request {
        return manager.request(Router.UpdateCategory(target, categoryId, label)).validate().response(completionHandler)
    }
    
    /**
        Delete a category
        DELETE /v3/categories/:categoryId
        (Authorization is required)
    */
    public func deleteCategory(categoryId: String, completionHandler:(NSURLRequest?, NSHTTPURLResponse?, Result<Void>) -> Void) -> Request {
        return manager.request(Router.DeleteCategory(target, categoryId)).validate().response(completionHandler)
    }
}
