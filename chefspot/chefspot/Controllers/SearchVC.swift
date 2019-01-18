//
//  SearchVC.swift
//  chefspot
//
//  Created by Roberto Guzman on 7/9/18.
//  Copyright © 2018 Fortytwo Sports. All rights reserved.
//

import Foundation
import UIKit

class SearchVC: UIViewController {
    
    lazy var searchController: UISearchController = {
        let sc = UISearchController(searchResultsController: nil)
        sc.delegate = self
        sc.hidesNavigationBarDuringPresentation = true
        sc.dimsBackgroundDuringPresentation = false
        let scb = sc.searchBar
        scb.tintColor = Theme.Colors.primaryText.color
        scb.barTintColor = Theme.Colors.primaryText.color
        scb.delegate = self
        return sc
    }()
    var searchTextField: UITextField?
    lazy var cancelButton: UIBarButtonItem = {
        let button = UIBarButtonItem(title: Constants.Strings.cancel, style: .done, target: self, action: #selector(handleCancelButtonTapped))
        return button
    }()
    lazy var tableView: UITableView = {
        let tv = UITableView(frame: view.frame, style: .grouped)
        tv.backgroundColor = .white
        tv.bounces = false
        tv.separatorStyle = .none
        tv.separatorColor = .clear
        tv.separatorInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        tv.allowsSelection = true
        tv.dataSource = self
        tv.delegate = self
        return tv
    }()
    let dataManager = DataManager.sharedInstance
    
    override func viewDidLoad() {
        super.viewDidLoad()
        changeBarStyle(willAppear: true)
        setupSubViews()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        changeBarStyle(willAppear: false)
    }
    
    
    //MARK: UI
    
    func setupSubViews() {
        
        //navigationBar
        view.backgroundColor = Theme.Colors.reallyWhite.color
        title = Constants.Strings.search
        navigationItem.hidesBackButton = true
        navigationItem.rightBarButtonItem = cancelButton
        
        //searchBar
        initializeSearchBar()
        
        //tableView
        view.addSubview(tableView)
        view.addConstraintsWithFormat(format: "H:|[v0]|", views: tableView)
        view.addConstraintsWithFormat(format: "V:|[v0]|", views: tableView)
        tableView.register(SettingCell.self, forCellReuseIdentifier: Constants.Cells.settingCellId)
        
        tableView.tableFooterView = UIView(frame: CGRect.zero)
        tableView.estimatedRowHeight = CGFloat(400)
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.scrollsToTop = true
    }
    
    func initializeSearchBar() {
        if #available(iOS 11.0, *) {
            //searchBar
            let scb = searchController.searchBar
            scb.backgroundColor = Theme.Colors.reallyWhite.color
            
            //textField
            if let textfield = scb.value(forKey: "searchField") as? UITextField {
                searchTextField = textfield
                textfield.textColor = Theme.Colors.primaryText.color
                if let backgroundview = textfield.subviews.first {
                    // Background color
                    backgroundview.backgroundColor = Theme.Colors.reallyWhite.color
                }
            }
            
            navigationItem.searchController = searchController
            navigationItem.hidesSearchBarWhenScrolling = false
        }
        
    }
    
    func changeBarStyle(willAppear: Bool) {
        if willAppear {
            navigationController?.navigationBar.isHidden = false
            navigationController?.navigationBar.prefersLargeTitles = true
        } else {
            navigationController?.navigationBar.isHidden = true
            navigationController?.navigationBar.prefersLargeTitles = false
        }
    }
    
    
    //MARK: Content
    
    func searchTerm(_ term: String, imageName: String?, fromType: SearchTermType?) {
        if fromType != .recent {
            dataManager.saveSearchTerm(term, imageName: imageName, type: SearchTermType.recent, order: 100)
        }
        dataManager.saveSearchTerm(term, imageName: imageName, type: SearchTermType.temp, order: 100)
        NotificationCenter.default.post(name: .searchTerm, object: self, userInfo: ["term" : term])
        exitVC()
    }
    
    func deleteTermForIndexPath(_ indexPath: IndexPath) {
        if indexPath.section == 0 && self.dataManager.recentSearchTerms.count - 1 >= indexPath.row {
            let term = dataManager.recentSearchTerms[indexPath.row]
            dataManager.removeSearchTerm(term)
        } else if indexPath.section == 1 &&  self.dataManager.popularSearchTerms.count - 1 >= indexPath.row {
            let term = dataManager.popularSearchTerms[indexPath.row]
            dataManager.removeSearchTerm(term)
        }
        tableView.reloadData()
    }
    
    
    //MARK: Actions
    
    @objc func handleCancelButtonTapped() {
        exitVC()
    }
    
    func exitVC() {
        navigationController?.popViewController(animated: true)
    }
}


//MARK: SearchDelegate

extension SearchVC: UISearchResultsUpdating, UISearchBarDelegate, UISearchControllerDelegate {
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
    }
    
    func searchBarSearchButtonClicked( _ searchBar: UISearchBar) {
        if let text = searchTextField?.text {
            searchTerm(text, imageName: nil, fromType: nil)
        }
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
    }
    
    func updateSearchResults(for searchController: UISearchController) {
    }
}


//MARK: TableView Delegate-DataSource

extension SearchVC: UITableViewDelegate, UITableViewDataSource {
    
    //MARK: TableView DataSource
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return dataManager.recentSearchTerms.count
        }
        return dataManager.popularSearchTerms.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return getSettingCell(indexPath)
    }
    
    func getSettingCell(_ indexPath: IndexPath) -> SettingCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Constants.Cells.settingCellId) as! SettingCell
        if indexPath.section == 0 {
            //recent searches
            if dataManager.recentSearchTerms.count - 1 >= indexPath.row {
                cell.settingTitle.text = dataManager.recentSearchTerms[indexPath.row].name
                if let imageName = dataManager.recentSearchTerms[indexPath.row].imageName {
                    let size = Constants.Strings.foodItemSizeSmall
                    let sizedName = size + imageName
                    cell.settingIcon.image = UIImage(named: sizedName)
                    cell.settingIcon.isHidden = false
                } else {
                    cell.settingIcon.image = UIImage(named: "small_ic_utensil")
                }
                cell.settingIcon.isHidden = false
            }
        } else {
            //popular searches
            if dataManager.popularSearchTerms.count - 1 >= indexPath.row {
                cell.settingTitle.text = dataManager.popularSearchTerms[indexPath.row].name
                if let imageName = dataManager.popularSearchTerms[indexPath.row].imageName {
                    let size = Constants.Strings.foodItemSizeSmall
                    let sizedName = size + imageName
                    cell.settingIcon.image = UIImage(named: sizedName)
                    cell.settingIcon.isHidden = false
                }
            }
        }
        return cell
    }
    
    
    //MARK: TableView Delegate
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = TitleHeaderView()
        switch section {
        case 0:
            headerView.titleLabel.text = Constants.Strings.recentSearches
            break
        case 1:
            headerView.titleLabel.text = Constants.Strings.popularSearches
            break
        default:
            break
        }
        return headerView
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 0 && dataManager.recentSearchTerms.count > 0 {
            return UITableViewAutomaticDimension
        } else if section == 1 && dataManager.popularSearchTerms.count > 0 {
            return UITableViewAutomaticDimension
        }
        return CGFloat.leastNormalMagnitude
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForHeaderInSection section: Int) -> CGFloat {
        return CGFloat.leastNormalMagnitude
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.section {
        case 0:
            if dataManager.recentSearchTerms.count - 1 >= indexPath.row {
                if let termName = dataManager.recentSearchTerms[indexPath.row].name {
                    searchTerm(termName, imageName: dataManager.recentSearchTerms[indexPath.row].imageName, fromType: SearchTermType.recent)
                }
            }
            break
        case 1:
            if dataManager.popularSearchTerms.count - 1 >= indexPath.row {
                if let termName = dataManager.popularSearchTerms[indexPath.row].name {
                    searchTerm(termName, imageName: dataManager.popularSearchTerms[indexPath.row].imageName, fromType: SearchTermType.popular)
                }
            }
            break
        default:
            break
        }
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    @available(iOS 11.0, *)
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let deleteAction = UIContextualAction(style: .destructive, title: Constants.Strings.delete, handler: { (action, view, handler) in
            self.deleteTermForIndexPath(indexPath)
        })
        let config = UISwipeActionsConfiguration(actions: [deleteAction])
        config.performsFirstActionWithFullSwipe = true
        return config
    }
    
}
