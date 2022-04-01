//
//  UserDetailItemCell.swift
//
//
//  Created by Haykaz Melikyan
//

import UIKit
import RxSwift

struct UserDetailItemViewModel {
    internal init(title: String, subtitle: String, actionButtonIcon: UIImage? = nil) {
        self.title = title
        self.subtitle = subtitle
        self.actionButtonIcon = actionButtonIcon
    }
    let title: String
    let subtitle: String
    let actionButtonIcon: UIImage?
}

final class UserDetailItemCell: UITableViewCell {
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var subtitleLabel: UILabel!
    @IBOutlet weak var actionButton: UIButton!
    var disposeBag = DisposeBag()
    func setCell(item: UserDetailItemViewModel) {
        titleLabel.text = item.title
        subtitleLabel.text = item.subtitle
        actionButton.setImage(item.actionButtonIcon, for: .normal)
        actionButton.isHidden = item.actionButtonIcon == nil
        titleLabel.textColor = UserDefaults.standard.userTheme.mainColor
    }
    override func prepareForReuse() {
        super.prepareForReuse()
         disposeBag = DisposeBag()
    }
}
