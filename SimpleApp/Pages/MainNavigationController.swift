//
//  MainNavigationController.swift
//
//
//  Created by Haykaz Melikyan
//

import UIKit

final class MainNavigationController: UINavigationController {
    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self, selector: #selector(appThemeChanged), name: appThemeChangeNotification, object: nil)
        delegate = self
        appThemeChanged()
    }
    
    @objc private func appThemeChanged() {
        navigationBar.tintColor = UserDefaults.standard.userTheme.mainColor
    }
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
}

extension MainNavigationController: UINavigationControllerDelegate {
    func navigationController(_ navigationController: UINavigationController, willShow viewController: UIViewController, animated: Bool) {
        viewController.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
    }
}
