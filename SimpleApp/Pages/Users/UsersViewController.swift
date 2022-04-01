//
//  UsersViewController.swift
// 
//
//  Created by Haykaz Melikyan
//

import UIKit

final class UsersViewController: BaseViewController<UsersViewModel>, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate {

    lazy private var searchBar: UISearchBar = {
        let bar = UISearchBar()
        bar.delegate = self
        bar.translatesAutoresizingMaskIntoConstraints = false
        return bar
    }()
    
    lazy private var tableView: UITableView = {
        let tableView = UITableView()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = 110
        tableView.estimatedRowHeight = 110
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.separatorStyle = .none
        return tableView
    }()
        
    private func configureViews() {
        view.addSubview(searchBar)
        NSLayoutConstraint.activate([ searchBar.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
                                      searchBar.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
                                      searchBar.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor)
        
        ])
        view.addSubview(tableView)
        NSLayoutConstraint.activate([ tableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
                                      tableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
                                      tableView.topAnchor.constraint(equalTo: searchBar.bottomAnchor),
                                      tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureViews()
        tableView.register(UINib(nibName: UserCell.className, bundle: nil), forCellReuseIdentifier: UserCell.className)
        bindViewModel()
        viewModel.fetch()
        searchBar.delegate = self
        view.backgroundColor = .white
        languageChanged()
    }
    
    override func bindViewModel() {
        super.bindViewModel()
        viewModel.filteredDataSource.asDriver().drive(onNext: {[unowned self] data in
            guard data != nil else {
                return
            }
            tableView.reloadData()
        }).disposed(by: disposeBag)
    }
    
    override func languageChanged() {
        title = viewModel.title
    }
    
    override func appThemeChanged() {
        tableView.reloadData()
    }
    
    // MARK: UISearchBarDelegate
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        viewModel.search(by: searchText)
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.endEditing(true)
    }
    
    // MARK: UITableViewDelegate and dataSource
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.filteredDataSource.value?.count ?? 0
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: UserCell.className, for: indexPath) as? UserCell,
              let item = viewModel.filteredDataSource.value?[indexPath.row] else {
            return UITableViewCell()
        }
        cell.favoriteButton.rx.tap.subscribe(onNext: {[weak self] _ in
            self?.viewModel.toggleIsFavorite(for: indexPath.row)
        }).disposed(by: cell.disposeBag)
        cell.setCell(item: item)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let uuid = viewModel.filteredDataSource.value?[indexPath.row].uuid else {
            return
        }
        guard let userDetailViewController = UIStoryboard.init(name: "Main",
                                                               bundle: nil).instantiateViewController(identifier: UserDetailViewController.className) as? UserDetailViewController else {
            assertionFailure("can't load UserDetailViewController")
            return
        }
        userDetailViewController.viewModel = UserDetailViewModel(uuid: uuid)
        navigationController?.pushViewController(userDetailViewController, animated: true)
    }
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        searchBar.endEditing(true)
    }
}
