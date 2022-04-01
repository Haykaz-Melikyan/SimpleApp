//
//  OverridedUserInterfaceStyle.swift
//  
//
//  Created by Haykaz Melikyan
//

import Foundation

enum OverridedUserInterfaceStyle: Int, CaseIterable {
    case auto = 0
    case light
    case dark
    
    var displayName: String {
        switch self {
        case .auto:
            return "auto".localized.capitalized
        case .dark:
            return "dark".localized.capitalized
        case .light:
            return "light".localized.capitalized
        }
    }
}
