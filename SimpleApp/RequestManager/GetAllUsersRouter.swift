//
//  GetAllUsersRouter.swift
//
//
//  Created by Haykaz Melikyan
//

import Foundation
class GetAllUsersRouter: Router {
    internal init(results: Int, page: Int) {
        self.results = results
        self.page = page
    }
    let results: Int
    let page: Int
    var resource: String {
        return "/api"
    }
    var parameters: [String: Any]? {
        var params = [String: Any]()
        params["results"] = results
        params["page"] = page
        return params
    }
}
