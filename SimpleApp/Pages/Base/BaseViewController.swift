//
//  BaseViewController.swift
//
//
//  Created by Haykaz Melikyan
//

import UIKit
import RxSwift
import RxCocoa

public let appThemeChangeNotification = NSNotification.Name(rawValue: "appThemeChangeNotification")

class BaseViewController<T: BaseViewModel>: UIViewController, ActivityLoading {
    var activityIndicator: UIView?
    var indicatorContainerView: UIView?
    var viewModel: T!
    let disposeBag = DisposeBag()
 
    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self, selector: #selector(languageChanged), name: LCLLanguageChangeNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(appThemeChanged), name: appThemeChangeNotification, object: nil)
    }
    
    @objc func appThemeChanged() {}
    @objc func languageChanged() {}
    
    public func bindViewModel() {
        bindLoader()
        bindError()
    }
    
    private func bindLoader() {
        viewModel.isLoading.asDriver()
            .drive(onNext: {[weak self] isLoading in
                isLoading ? self?.showLoader() : self?.hideLoader()
            }).disposed(by: disposeBag)
    }
    
    private func bindError() {
        viewModel.showError.asDriver()
            .drive(onNext: {[weak self] error in
                self?.viewModel.isLoading.accept(false)
                guard let error = error else {
                    return
                }
                if let code = error.code {
                    switch URLError.Code(rawValue: code) {
                    case .notConnectedToInternet:
                        return
                    default: break
                    }
                }
                let alert = UIAlertController(title: "oops_error".localized, message: error.errorMessage, preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "cancel".localized.uppercased(), style: .cancel) { _ in
                    
                })
                self?.present(alert, animated: true, completion: nil)
            }).disposed(by: disposeBag)
    }
    
    func hideLoader() {
        activityIndicator?.isHidden = true
        activityIndicator?.removeFromSuperview()
        activityIndicator = nil
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
}
