//
//  Router.swift
//
//
//  Created by Haykaz Melikyan
//

import Foundation

enum Method: String {
    case post = "POST"
    case get = "GET"
    case put = "PUT"
    case delete = "DELETE"
    case patch = "PATCH"
}

protocol Router {
    var baseUrl: String { get }
    var parameters: [String: Any]? { get }
    var resource: String { get }
    var method: Method { get }
    var headers: [String: String] { get }
    var isFormData: Bool { get }
}

extension Router {
    var baseUrl: String { return "https://randomuser.me"}
    var isFormData: Bool {return false}
    var parameters: [String: Any]? { return nil }
    var method: Method { return .get }
    var headers: [String: String] {
        return [:]
    }
}
