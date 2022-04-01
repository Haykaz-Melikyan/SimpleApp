//
//  Parser.swift
//
//
//  Created by Haykaz Melikyan
//

import Foundation
 struct Parser {
    static func parsData<T: Decodable>(data: Data) throws -> T {
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601
        return try decoder.decode(T.self, from: data)
    }
}
