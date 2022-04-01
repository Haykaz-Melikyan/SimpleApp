//
//  UserDetailViewController.swift
// 
//
//  Created by Haykaz Melikyan
//

import UIKit
import MapKit

final class UserDetailViewController: UITableViewController, MKMapViewDelegate {
    var viewModel: UserDetailViewModel?
    @IBOutlet private weak var userImageView: UIImageView!
    @IBOutlet private weak var mapView: MKMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self, selector: #selector(languageChanged), name: LCLLanguageChangeNotification, object: nil)
        userImageView.sd_setImage(with: viewModel?.userAvatarUrl, completed: nil)
        languageChanged()
        setNavigationFavorite()
        mapView.delegate = self
    }
    
    private func setUserLocationOnMap() {
        if let coordinate = viewModel?.userCoordinate {
            let mapCamera = MKMapCamera(lookingAtCenter: coordinate,
                                        fromEyeCoordinate: coordinate,
                                        eyeAltitude: 50000)
            let annotation = MKPointAnnotation()
            annotation.coordinate = coordinate
            mapView.addAnnotation(annotation)
            mapView.setCamera(mapCamera, animated: true)
        }
    }

    override func tableView(_ tableView: UITableView,
                            willDisplay cell: UITableViewCell,
                            forRowAt indexPath: IndexPath) {
        guard let cell = cell as? UserDetailItemCell, let item = viewModel?.dataSource[indexPath.row] else {return}
        cell.actionButton.rx.tap.subscribe(onNext: {[weak self] _ in
            switch indexPath.row {
            case 2:
                self?.openMail()
            case 3:
                self?.call()
            default:
                break
            }
        }).disposed(by: cell.disposeBag)
        cell.setCell(item: item)
    }
    
    private func call() {
        guard let phone = viewModel?.userPhoneNumber else {return}
        guard let phoneUrl = URL(string: "tel://" + phone) else {return}
        openUrlIfCan(phoneUrl)
    }
    
    private func openMail() {
        guard let mail = viewModel?.userMail else {return}
        guard let urlEMail = URL(string: "mailto:" + mail) else {return}
        openUrlIfCan(urlEMail)
    }
    
    private func setNavigationFavorite() {
        let navigationFavoriteItem = UIBarButtonItem(image: viewModel?.favoriteButtonIcon,
                                                     style: .done,
                                                     target: self,
                                                     action: #selector(toggleIsFavorite))
        navigationItem.rightBarButtonItem = navigationFavoriteItem
    }
    
    @objc private func toggleIsFavorite() {
        viewModel?.user.toggleIsFavorite()
        setNavigationFavorite()
    }
    @objc private func languageChanged() {
        title = viewModel?.title
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        userImageView.layer.cornerRadius = userImageView.frame.height / 2
    }
  
    // MARK: MKMapViewDelegate
    func mapViewDidFinishLoadingMap(_ mapView: MKMapView) {
        setUserLocationOnMap()
    }
    
}
