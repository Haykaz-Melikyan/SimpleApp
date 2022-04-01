//
//  SettingsViewModel.swift
//
//
//  Created by Haykaz Melikyan
//

import Foundation
import UIKit

class SettingsViewModel: BaseViewModel {
    var availableLanguages = Localize.availableLanguages(true)
    var currentLanguage = Localize.currentLanguage()
    let allStyles = OverridedUserInterfaceStyle.allCases
    var currentStyle: UIUserInterfaceStyle {
        return UserDefaults.standard.overridedUserInterfaceStyle
    }
    var appThemes = Theme.allCases
}
