//
//  RequestManager.swift
//
//
//  Created by Haykaz Melikyan
//

import Foundation

final class TrustedSessionManager: NSObject, URLSessionDelegate {
    lazy var session: URLSession = {[weak self] in
        let configuration = URLSessionConfiguration.default

        return URLSession(configuration: configuration,
                          delegate: self,
                          delegateQueue: OperationQueue.main)
    }()

    public func urlSession(_ session: URLSession,
                           didReceive challenge: URLAuthenticationChallenge,
                           completionHandler: @escaping (URLSession.AuthChallengeDisposition,
                                                         URLCredential?) -> Swift.Void) {
        let trust = challenge.protectionSpace.serverTrust
        completionHandler(URLSession.AuthChallengeDisposition.useCredential,
                          trust != nil ? URLCredential(trust: trust!) : nil)
    }
}

enum Response<T> {
    case error(ServerError)
    case success(T?)
}

final class ServerError: ExpressibleByStringLiteral, Error {
    typealias StringLiteralType = String
    let errorMessage: String
    var code: Int?

    public required init(stringLiteral value: StringLiteralType) {
        errorMessage = value
    }

    public init(error: Error, code: Int?) {
        self.errorMessage = error.localizedDescription
        self.code = code
    }

    public init(message: String, code: Int?) {
        self.errorMessage = message
        self.code = code
    }
}

final class RestApiManager {
    static let trustedSession = TrustedSessionManager().session

    public func makeRequest<T: Decodable>(parameters: Router, onCompletion: @escaping ((Response<T>) -> Void)) {
        let urlString = "\(parameters.baseUrl)\(parameters.resource)"
        guard let url = URL(string: urlString) else {
            onCompletion(Response.error(""))
            return
        }
        var request = URLRequest(url: url)
        if parameters.method.rawValue == Method.get.rawValue {
            var urlComponents = URLComponents(string: urlString)
            var queryItems = [URLQueryItem]()
            if let params = parameters.parameters {
                for (key, value) in params {
                    queryItems.append(URLQueryItem(name: key, value: "\(value)"))
                }
                urlComponents?.queryItems = queryItems
                request = URLRequest(url: (urlComponents?.url)!)
            }
        }
        request.httpMethod = parameters.method.rawValue
        if let params = parameters.parameters, parameters.method.rawValue != Method.get.rawValue {
            request.httpBody = try? JSONSerialization.data(withJSONObject: params, options: .prettyPrinted)
        }
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        parameters.headers.forEach {
            request.addValue($0.value, forHTTPHeaderField: $0.key)
        }
        print(request.url ?? "")
        let task = Self.trustedSession.dataTask(with: request, completionHandler: {data, response, error -> Void in
            guard error == nil else {
                onCompletion(Response.error(ServerError(error: error!, code: (error as NSError?)?.code)))
                return
            }
            guard let response = response as? HTTPURLResponse, let data = data, response.statusCode == 200 else {
                onCompletion(Response.error(ServerError(stringLiteral: "oops error")))
                return
            }
            if let json = try? JSONSerialization.jsonObject(with: data, options: .allowFragments) {
                print("response \(json)")
            }
            let responseObject: Response<T>
            do {
                responseObject = try .success(Parser.parsData(data: data))
            } catch {
                print("Parsing error \(error)")
                responseObject = .error(ServerError(error: error, code: 0))
            }
            onCompletion(responseObject)
        })
        task.resume()
    }
}

final class UserApiManager {
    private let apiManager = RestApiManager()
    public func getAllUsers(parameters: GetAllUsersRouter, onCompletion: @escaping ((Response<ResultsModel>) -> Void)) {
        apiManager.makeRequest(parameters: parameters) { (response: Response<ResultsModel>) in
           onCompletion(response)
       }
    }
}
