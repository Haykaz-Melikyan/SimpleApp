//
//  UserDetailViewModel.swift
//
//
//  Created by Haykaz Melikyan
//
import Foundation
import UIKit
import CoreLocation

final class UserDetailViewModel: BaseViewModel {
    init(uuid: String) {
        self.userId = uuid
        user = UserObject.getUser(by: uuid)
    }
    let user: UserObject
    private let userId: String
    var userAvatarUrl: URL? {
        return URL(string: user.picture!.large)
    }
    var title: String {
        "\(user.nameTitle) \(user.firstName) \(user.lastName)"
    }
    var favoriteButtonIcon: UIImage {
        return  UIImage(systemName: user.isFavorite ? "suit.heart.fill" : "suit.heart")!
    }
    private var userAddressString: String {
        guard let location = user.location else {
            return ""
        }
        let locationString = "\(location.country), \(location.state), \(location.city)"
        guard let street = location.street else {
            return locationString
        }
        return locationString + "\(street.name ), \(street.number)"
    }
    
    var userPhoneNumber: String {
        return user.phone
    }
    var userMail: String {
        return user.email
    }
    var dataSource: [UserDetailItemViewModel] {
        let dataSource  = [UserDetailItemViewModel(title: "age".localized.capitalized,
                                                   subtitle: String(user.dob?.age ?? 0)),
                           UserDetailItemViewModel(title: "gender".localized.capitalized,
                                                   subtitle: user.gender!),
                           UserDetailItemViewModel(title: "email".localized.capitalized,
                                                   subtitle: userMail, actionButtonIcon: UIImage(systemName: "arrowshape.turn.up.forward")!),
                           UserDetailItemViewModel(title: "phone number".localized.capitalized,
                                                   subtitle: userPhoneNumber, actionButtonIcon: UIImage(systemName: "phone")!),
                           UserDetailItemViewModel(title: "address".localized.capitalized,
                                                   subtitle: userAddressString)
                           
        ]
        return dataSource
    }
    
    var userCoordinate: CLLocationCoordinate2D? {
        guard let coordinate = user.location?.coordinates,
              let latitude = Double(coordinate.latitude),
              let longitude = Double(coordinate.longitude) else {
            return nil
        }
        return CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
    }
    
}
