//
//  NsObject+Extesnions.swift
//
//
//  Created by Haykaz Melikyan
//

import Foundation

extension NSObject {
    class var className: String {
        return String(describing: self.self)
    }
}
