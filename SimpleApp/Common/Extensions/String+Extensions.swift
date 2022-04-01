//
//  String+Extensions.swift
//
//
//  Created by Haykaz Melikyan
//

import Foundation
import UIKit
extension String {

    var localized: String {
        return String.localizedString(for: self, replaceValue: "")
    }

    static func localizedString(for key: String, replaceValue comment: String) -> String {
        let currentLanguage = Localize.currentLanguage()
        let path = Bundle.main.path(forResource: currentLanguage, ofType: "lproj")
        let bundle = Bundle(path: path!)
        let fallbackString = bundle!.localizedString(forKey: key, value: comment, table: nil)
        return fallbackString
    }
}
