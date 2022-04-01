//
//  MainTabBarViewController.swift
//
//
//  Created by Haykaz Melikyan
//

import Foundation
import UIKit

final class MainTabBarViewController: UITabBarController {
    lazy var allUsersViewController: UIViewController = {
        let usersViewController = UsersViewController()
        usersViewController.viewModel = UsersViewModel(isFavoriteModel: false)
        let barItem = UITabBarItem(title: nil,
                                   image: UIImage(systemName: "person.2"),
                                   selectedImage: UIImage(systemName: "person.2.fill"))
        usersViewController.tabBarItem = barItem
        let navigation = MainNavigationController(rootViewController: usersViewController)
        return navigation
    }()
    
    lazy var favoriteUsersViewController: UIViewController = {
        let usersViewController = UsersViewController()
        usersViewController.viewModel = UsersViewModel(isFavoriteModel: true)
        let barItem = UITabBarItem(title: nil,
                                   image: UIImage(systemName: "heart"),
                                   selectedImage: UIImage(systemName: "heart.fill"))
        usersViewController.tabBarItem = barItem
        let navigation = MainNavigationController(rootViewController: usersViewController)
        return navigation
    }()
    
    lazy var settingsViewController: UIViewController = {
        guard let settingsViewController = storyboard?.instantiateViewController(identifier: "SettingsViewController") else {
            assertionFailure("can't load SettingsViewController")
            return UIViewController()
        }
        let barItem = UITabBarItem(title: nil,
                                   image: UIImage(systemName: "square.grid.3x1.below.line.grid.1x2"),
                                   selectedImage: UIImage(systemName: "square.grid.3x1.fill.below.line.grid.1x2"))
        settingsViewController.tabBarItem = barItem
        let navigation = MainNavigationController(rootViewController: settingsViewController)
        return navigation
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let controllers = [allUsersViewController, favoriteUsersViewController, settingsViewController]
        self.viewControllers = controllers
        NotificationCenter.default.addObserver(self, selector: #selector(languageChanged),
                                               name: LCLLanguageChangeNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(appThemeChanged),
                                               name: appThemeChangeNotification, object: nil)
        languageChanged()
        appThemeChanged()
    }
    
    @objc private func appThemeChanged() {
        tabBar.tintColor = UserDefaults.standard.userTheme.mainColor
    }
    
    @objc private func languageChanged() {
        viewControllers?[0].tabBarItem.title =  "users".localized.capitalized
        viewControllers?[1].tabBarItem.title =  "saved".localized.capitalized
        viewControllers?[2].tabBarItem.title =  "settings".localized.capitalized
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
}
