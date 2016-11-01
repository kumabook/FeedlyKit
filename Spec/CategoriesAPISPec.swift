//
//  CategoriesAPISPec.swift
//  FeedlyKit
//
//  Created by Hiroki Kumamoto on 3/12/16.
//  Copyright © 2016 Hiroki Kumamoto. All rights reserved.
//

import Foundation
import FeedlyKit
import Quick
import Nimble

class CategoriesAPISpec: CloudAPISpec {
    let feedId = "feed/https://news.ycombinator.com/rss"
    let categoryLabel = "test"
    func fetchCategories(callback: @escaping (Int, [FeedlyKit.Category]) -> ()) {
        let _ = self.client.fetchCategories {
            guard let code = $0.response?.statusCode,
                  let categories = $0.result.value else { return }
            callback(code, categories)
        }
    }

    func createCategory(callback: @escaping () -> ()) {
        let feed = Feed(id: feedId, title: "", description: "", subscribers: 0)
        let _ = self.client.subscribeTo(feed, categories: [self.profile!.category(categoryLabel)]) { _ in
            callback()
        }
    }

    override func spec() {
        beforeSuite {
            self.client.setAccessToken(SpecHelper.accessToken)
        }
        describe("fetchCategories") {
            if SpecHelper.accessToken == nil { return }
            var statusCode = 0
            var categories: [FeedlyKit.Category]? = nil
            beforeEach {
                self.fetchCategories {
                    statusCode = $0
                    categories = $1
                }
            }
            it("fetches categories") {
                expect(statusCode).toFinally(equal(200))
                expect(categories).toFinallyNot(beNil())
            }
        }
        
        describe("updateCategories") {
            if SpecHelper.accessToken == nil { return }
            var statusCode = 0
            var categories: [FeedlyKit.Category]? = nil
            var isFinish = false
            let label = "test"
            beforeEach {
                self.fetchProfile {
                    self.createCategory {
                        let _ = self.client.updateCategory(self.profile!.category(label).id, label: label) {
                            guard let code = $0.response?.statusCode else { return }
                            statusCode = code
                            self.fetchCategories {
                                categories = $1
                                isFinish = true
                            }
                        }
                    }
                }
            }
            it("updates categories") {
                expect(statusCode).toFinally(equal(200))
                expect(isFinish).toFinally(beTrue())
                expect(categories).toFinallyNot(beNil())
                expect(categories!.map { $0.label }).to(contain(label))
            }
        }

        describe("deleteCategory") {
            if SpecHelper.accessToken == nil { return }
            var statusCode = 0
            var categories: [FeedlyKit.Category]? = nil
            var isFinish = false
            var deletedCategory: FeedlyKit.Category? = nil
            beforeEach {
                self.fetchCategories { code, _categories in
                    if _categories.count == 0 { return }
                    deletedCategory = _categories[0]
                    let _ = self.client.deleteCategory(deletedCategory!.id) {
                        guard let code = $0.response?.statusCode else { return }
                        statusCode = code
                        self.fetchCategories {
                            categories = $1
                            isFinish = true
                        }
                    }
                }
            }
            it("deletes a categories") {
                expect(statusCode).toFinally(equal(200))
                expect(isFinish).toFinally(beTrue())
                expect(deletedCategory).notTo(beNil())
                expect(categories!.map { $0.id }).notTo(contain(deletedCategory!.id))
            }
        }
    }
}
