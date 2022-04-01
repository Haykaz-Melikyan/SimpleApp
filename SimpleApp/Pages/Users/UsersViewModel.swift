//
//  UsersViewModel.swift
//
//
//  Created by Haykaz Melikyan
//

import Foundation
import RxCocoa
import RealmSwift
import UIKit

final class UsersViewModel: BaseViewModel {
    
    init(isFavoriteModel: Bool) {
        self.isFavoriteModel = isFavoriteModel
        super.init()
        fetchUsersFromDb()
    }
    private let isFavoriteModel: Bool
    private let api = UserApiManager()
    var filteredDataSource = BehaviorRelay<[UserCellViewModel]?>(value: nil)
    var dataSource: Results<UserObject>?
    
    var notificationToken: NotificationToken?
    var title: String {
        let string = isFavoriteModel ? "saved users" : "users"
        return string.localized.capitalized
    }
    private func fetchUsersFromDb() {
        dataSource = UserObject.getAllUsers(onlyFavorite: isFavoriteModel)
        notificationToken = dataSource?.observe {[weak self] (_) in
            guard let data = self?.dataSource else {return}
            self?.filteredDataSource.accept(self?.createViewModels(from: Array(data)))
        }
    }
    
    override func fetch() {
        super.fetch()
        guard let dataSource = dataSource, dataSource.isEmpty, !isFavoriteModel else {
            showLoading(false)
            return
        }
        let router = GetAllUsersRouter(results: 50, page: 1)
        api.getAllUsers(parameters: router) { [weak self] response in
            if let data = self?.responseHandler(response: response) {
                UserObject.save(users: data.results)
            }
        }
    }
    
    func search(by searchText: String) {
        guard let dataSource = dataSource else {return}
        guard !searchText.isEmpty else {
            filteredDataSource.accept(createViewModels(from: Array(dataSource)))
            return
        }
        let lowercasedSearchText = searchText.lowercased()
        let newArray = dataSource.compactMap({$0}).filter { user in
            let matched = user.firstName.lowercased().contains(lowercasedSearchText)
                || user.email.lowercased().contains(lowercasedSearchText)
                || user.phone.lowercased().contains(lowercasedSearchText)
            if let location = user.location {
                let locationMatches =  location.city.lowercased().contains(lowercasedSearchText)
                    || location.state.lowercased().contains(lowercasedSearchText)
                    || location.country.lowercased().contains(lowercasedSearchText)
                return matched || locationMatches
            }
            return matched
        }
        filteredDataSource.accept(createViewModels(from: Array(newArray)))
    }
    
    private func createViewModels(from usersList: [UserObject]?) -> [UserCellViewModel] {
        guard let usersList = usersList else {return []}
        var viewModels = [UserCellViewModel]()
        usersList.forEach { user in
            let fullName = user.firstName + " " + user.lastName
            let attributedString =  NSMutableAttributedString(string: fullName,
                                                              attributes: [.font: UIFont.systemFont(ofSize: 17,
                                                                                                    weight: .bold)])
            let genderImageAttachment = NSTextAttachment()
            let genderIcon: UIImage = user.gender == Gender.male.rawValue ? #imageLiteral(resourceName: "male") : #imageLiteral(resourceName: "female")
            genderImageAttachment.image = genderIcon
            let genderString = NSAttributedString(attachment: genderImageAttachment)
            attributedString.append(genderString)
            let county = user.location?.country ?? ""
            let state = user.location?.state ?? ""
            let city = user.location?.city ?? ""
            let addressText = "\(county), \(state), \(city)"
            let avatarUrl = URL(string: user.picture?.medium ?? "")
            
            let favoriteIcon = user.isFavorite ? UIImage(systemName: "suit.heart.fill")!  : UIImage(systemName: "suit.heart")!
            let viewModel = UserCellViewModel(fullNameAndGender: attributedString,
                                              emailText: user.email,
                                              phoneNumberText: user.phone,
                                              addressText: addressText,
                                              avatarImageUrl: avatarUrl,
                                              uuid: user.uuid, favoriteButtonIcon: favoriteIcon)
            viewModels.append(viewModel)
        }
        return viewModels
    }
    
    func toggleIsFavorite(for index: Int) {
        guard let uuid = filteredDataSource.value?[index].uuid else {return}
        UserObject.toggleIsFavoriteForUser(with: uuid)
    }
    
    deinit {
        notificationToken = nil
    }
}
