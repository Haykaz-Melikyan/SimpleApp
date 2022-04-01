//
//  UserCell.swift
//
//
//  Created by Haykaz Melikyan
//

import UIKit
import SDWebImage
import RxSwift

struct UserCellViewModel {
    internal init(fullNameAndGender: NSAttributedString, emailText: String, phoneNumberText: String, addressText: String, avatarImageUrl: URL?, uuid: String, favoriteButtonIcon: UIImage) {
        self.fullNameAndGender = fullNameAndGender
        self.emailText = emailText
        self.phoneNumberText = phoneNumberText
        self.addressText = addressText
        self.avatarImageUrl = avatarImageUrl
        self.uuid = uuid
        self.favoriteButtonIcon = favoriteButtonIcon
    }
    let fullNameAndGender: NSAttributedString
    let emailText: String
    let phoneNumberText: String
    let addressText: String
    let avatarImageUrl: URL?
    let uuid: String
    var favoriteButtonIcon: UIImage
}

final class UserCell: UITableViewCell {
    @IBOutlet private weak var avatarImageView: UIImageView! {
        didSet {
            avatarImageView.layer.cornerRadius = avatarImageView.frame.height / 2
        }
    }
    @IBOutlet weak var favoriteButton: UIButton!
    @IBOutlet private weak var fullNameLabel: UILabel!
    @IBOutlet private weak var emailAddressLabel: UILabel!
    @IBOutlet private weak var phoneLabel: UILabel!
    @IBOutlet private weak var addressLabel: UILabel!
    var disposeBag = DisposeBag()

    func setCell(item: UserCellViewModel) {
        fullNameLabel.attributedText = item.fullNameAndGender
        emailAddressLabel.text = item.emailText
        phoneLabel.text = item.phoneNumberText
        addressLabel.text = item.addressText
        avatarImageView.sd_setImage(with: item.avatarImageUrl, placeholderImage: UIImage(systemName: "person.circle"))
        favoriteButton.setImage(item.favoriteButtonIcon, for: .normal)
        favoriteButton.tintColor = UserDefaults.standard.userTheme.mainColor
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
         disposeBag = DisposeBag()
    }
}
