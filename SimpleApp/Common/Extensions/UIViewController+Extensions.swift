//
//  UIViewController+Extensions.swift
//
//
//  Created by Haykaz Melikyan
//

import Foundation
import UIKit

protocol ActivityLoading: AnyObject {
    var activityIndicator: UIView? { get set }
    var indicatorContainerView: UIView? { get }
}

extension ActivityLoading where Self: UIViewController {
    func showLoader() {
        if activityIndicator == nil {
            let backgroundView = UIView()
            backgroundView.translatesAutoresizingMaskIntoConstraints = false
            let container = indicatorContainerView == nil ? self.view : indicatorContainerView
            guard let containerView = container else { return }
            containerView.insertSubview(backgroundView, at: 1000)
            backgroundView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor).isActive = true
            backgroundView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor).isActive = true
            backgroundView.topAnchor.constraint(equalTo: containerView.topAnchor).isActive = true
            backgroundView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor).isActive = true
            let activity = UIActivityIndicatorView()
            activity.startAnimating()
            activity.style = .large
            activity.color = .white
            activity.translatesAutoresizingMaskIntoConstraints = false
            backgroundView.addSubview(activity)
            activity.centerXAnchor.constraint(equalTo: backgroundView.centerXAnchor).isActive = true
            activity.centerYAnchor.constraint(equalTo: backgroundView.centerYAnchor).isActive = true
            activity.heightAnchor.constraint(equalToConstant: 100).isActive = true
            activity.widthAnchor.constraint(equalToConstant: 100).isActive = true
            self.activityIndicator = backgroundView
            activityIndicator?.backgroundColor = #colorLiteral(red: 0.1333333333, green: 0.1529411765, blue: 0.2392156863, alpha: 0.7015480917)
        }
        activityIndicator?.isHidden = false
    }
}
extension UIViewController {
    func openUrlIfCan(_ url: URL) {
        if UIApplication.shared.canOpenURL(url) {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        }
    }
}
