//
//  SettingsViewController.swift
//
//
//  Created by Haykaz Melikyan
//

import UIKit

final class SettingsViewController: BaseViewController<SettingsViewModel> {
    @IBOutlet private weak var languagesSegment: UISegmentedControl!
    @IBOutlet private weak var appColorsStackView: UIStackView!
    @IBOutlet private weak var appearanceSegment: UISegmentedControl!
    @IBOutlet private weak var languageLabel: UILabel!
    @IBOutlet private weak var appearanceLabel: UILabel!
    @IBOutlet private weak var mainColorLabel: UILabel!
    private var colorButtons = [ThemeCircleButton]()
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel = SettingsViewModel()
        languageChanged()
        configureLanguagesSegment()
        setRx()
        setColors()
    }
    
    private func setColors() {
        appColorsStackView.arrangedSubviews.forEach({$0.removeFromSuperview()})
        for theme in viewModel.appThemes {
            let button = ThemeCircleButton()
            button.translatesAutoresizingMaskIntoConstraints = false
            button.widthAnchor.constraint(equalToConstant: 30).isActive = true
            button.heightAnchor.constraint(equalTo: button.widthAnchor).isActive = true
            button.theme = theme
            button.addTarget(self, action: #selector(colorButtonDidTap(_:)), for: .touchUpInside)
            appColorsStackView.addArrangedSubview(button)
            colorButtons.append(button)
            if theme == UserDefaults.standard.userTheme {
                button.isSelected = true
            }
        }
    }
    
    @objc private func colorButtonDidTap(_ sender: ThemeCircleButton) {
        colorButtons.forEach({$0.isSelected = false})
        sender.isSelected = true
        UserDefaults.standard.userTheme = sender.theme
    }
    
    private func setRx() {
        appearanceSegment.rx.selectedSegmentIndex.subscribe(onNext: {  index in
            UserDefaults.standard.overridedUserInterfaceStyle = UIUserInterfaceStyle(rawValue: index)!
        }).disposed(by: disposeBag)
        languagesSegment.rx.selectedSegmentIndex.subscribe( onNext: { [unowned self] index in
            Localize.setCurrentLanguage(viewModel.availableLanguages[index])
        }).disposed(by: disposeBag)
    }
    
    private func configureAppearanceSegment() {
        appearanceSegment.removeAllSegments()
        for (index, style) in viewModel.allStyles.enumerated() {
            appearanceSegment.insertSegment(withTitle: style.displayName, at: index, animated: false)
            if viewModel.currentStyle.rawValue == style.rawValue {
                self.appearanceSegment.selectedSegmentIndex = index
            }
        }
    }
    
    private func configureLanguagesSegment() {
        languagesSegment.removeAllSegments()
        for (index, language) in viewModel.availableLanguages.enumerated() {
            languagesSegment.insertSegment(withTitle: Localize.displayNameForLanguage(language),
                                           at: index,
                                           animated: false)
            if viewModel.currentLanguage == language {
                languagesSegment.selectedSegmentIndex = index
            }
        }
    }

    override func languageChanged() {
        configureAppearanceSegment()
        title = "settings".localized.capitalized
        languageLabel.text = "language".localized.capitalized
        appearanceLabel.text = "appearance".localized.capitalized
        mainColorLabel.text = "main color".localized.capitalized
    }

}
