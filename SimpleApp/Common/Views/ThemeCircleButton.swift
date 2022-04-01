//
//  ThemeCircleButton.swift
//
//
//  Created by Haykaz Melikyan
//

import UIKit

final class ThemeCircleButton: UIButton {
    
    var theme: Theme = Theme.yellow {
        didSet {
            layoutIfNeeded()
        }
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        layer.cornerRadius = frame.height / 2
        layer.borderWidth = 3.0
        layer.borderColor = theme.mainColor.cgColor
    }
    
    override var isSelected: Bool {
        didSet {
            backgroundColor = isSelected ? theme.mainColor : .clear
        }
    }
}
