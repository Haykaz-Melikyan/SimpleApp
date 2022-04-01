//
//  Theme.swift
//
//
//  Created by Haykaz Melikyan
//

import UIKit

enum Theme: Int, CaseIterable {
    case yellow = 0
    case purple
    case blue
    
    var mainColor: UIColor {
        switch self {
        case .yellow:
            return Colors.CSYellow
        case .purple:
            return Colors.CSPurple
        case .blue:
            return Colors.CSBlue
        }
    }
}
