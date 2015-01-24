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
    public func fetchCategories(completionHandler: (NSURLRequest, NSHTTPURLResponse?, [Category]?, NSError?) -> Void) -> Self {
        Alamofire.request(Router.FetchCategories).responseCollection(completionHandler)
        return self
    }
    
    /**
        Change the label of an existing category
        POST /v3/categories/:categoryId
        (Authorization is required)
    */
    public func updateCategory(categoryId: String, label: String, completionHandler:(NSURLRequest, NSHTTPURLResponse?, NSError?) -> Void) -> Self {
        Alamofire.request(Router.UpdateCategory(categoryId, label)).response(completionHandler)
        return self
    }
    
    /**
        Delete a category
        DELETE /v3/categories/:categoryId
        (Authorization is required)
    */
    public func deleteCategory(categoryId: String, completionHandler:(NSURLRequest, NSHTTPURLResponse?, NSError?) -> Void) -> Self {
        Alamofire.request(Router.DeleteCategory(categoryId)).response(completionHandler)
        return self
    }
}
