//
//  BaseViewModel.swift
// 
//
//  Created by Haykaz Melikyan
//

import Foundation
import RxRelay

class BaseViewModel {
    
    let isLoading = BehaviorRelay<Bool>(value: false)
    let showError = BehaviorRelay<ServerError?>(value: nil)

    func responseHandler<T>(response: Response<T>) -> T? {
       switch response {
       case .error(let error):
           showError.accept(error)
       case .success(let data):
           showError.accept(nil)
           return data
       }
       return nil
    }
    
    func fetch() {
        showLoading(true)
    }
    
    func showLoading(_ show: Bool) {
        isLoading.accept(show)
    }
}
