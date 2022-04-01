//
//  UserDefaults+Extesnisions.swift
//
//
//  Created by Haykaz Melikyan
//

import Foundation
import UIKit

extension UserDefaults {
    var overridedUserInterfaceStyle: UIUserInterfaceStyle {
        get {
            UIUserInterfaceStyle(rawValue: integer(forKey: #function)) ?? .unspecified
        }
        set {
            set(newValue.rawValue, forKey: #function)
            for window in UIApplication.shared.windows {
                window.overrideUserInterfaceStyle = UserDefaults.standard.overridedUserInterfaceStyle
            }
        }
    }
    var userTheme: Theme {
        get {
            Theme(rawValue: integer(forKey: #function)) ?? .yellow
        }
        set {
            set(newValue.rawValue, forKey: #function)
            NotificationCenter.default.post(Notification(name: appThemeChangeNotification))
        }
    }
}
