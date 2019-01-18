//
//  SideView.swift
//  chefspot
//
//  Created by Roberto Guzman on 7/9/18.
//  Copyright © 2018 Fortytwo Sports. All rights reserved.
//

import Foundation
import UIKit

class SideView: UIView, UITableViewDelegate, UITableViewDataSource {
    
    lazy var tableView: UITableView = {
        let tv = UITableView(frame: frame, style: .grouped)
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
    let userInfoView: UserInfoView = {
        let view = UserInfoView(frame: CGRect(x: 0, y: 0, width: Constants.Sizes.sideView.width, height: Constants.Sizes.userInfoView.height))
        return view
    }()
    var sections = [SettingItem.SettingCategory.sideView]
    var items = [SettingItem]()
    var settingItems: [SettingItem.SettingCategory :[SettingItem]] = {
        let utility = AppUtility.sharedInstance
        let items: [SettingItem] = [SettingItem(category: .sideView, title: Constants.Strings.visitHistory, imageName: "ic_near_me", placeholder: nil, userInputText: nil),
                                    SettingItem(category: .sideView, title: Constants.Strings.favoritePlaces, imageName: "ic_heart_full", placeholder: nil, userInputText: nil),
                                    SettingItem(category: .sideView, title: Constants.Strings.savedFoodItems, imageName: "small_ic_utensil", placeholder: nil, userInputText: nil),
                                    SettingItem(category: .sideView, title: Constants.Strings.settings, imageName: "ic_settings", placeholder: nil, userInputText: nil)]
        return utility.groupBy(items) { $0.category}
    }()
    let userManager = UserManager.sharedInstance
    lazy var currentViewController = utility.getCurrentViewController()
    let utility = AppUtility.sharedInstance
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupSubViews()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    
    //MARK: UI
    
    func setupSubViews() {
        backgroundColor = Theme.Colors.reallyWhite.color
        
        //tableView
        addSubview(tableView)
        addConstraintsWithFormat(format: "H:|[v0]|", views: tableView)
        addConstraintsWithFormat(format: "V:|[v0]|", views: tableView)
        tableView.register(SettingCell.self, forCellReuseIdentifier: Constants.Cells.settingCellId)
        
        tableView.tableFooterView = UIView(frame: CGRect.zero)
        tableView.estimatedRowHeight = CGFloat(400)
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.scrollsToTop = true
        tableView.tableHeaderView = userInfoView
        
    }
    
    
    //MARK: TableView DataSource
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return sections.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let category = sections[section]
        return settingItems[category]?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return settingWithImageCellForRowAtIndexPath(indexPath)
    }
    
    func settingWithImageCellForRowAtIndexPath(_ indexPath: IndexPath) -> SettingCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: Constants.Cells.settingCellId) as! SettingCell
        let category = sections[indexPath.section]
        let setting: SettingItem = settingItems[category]![indexPath.row]
        cell.settingTitle.text = setting.title
        if let imageName = setting.imageName {
            cell.settingIcon.image = UIImage(named: imageName)?.withRenderingMode(.alwaysTemplate)
            cell.settingIcon.tintColor = Theme.Colors.buttonTint.color
            cell.settingIcon.isHidden = false
        }
        
        return cell
    }
    
    
    //MARK: TableView Delegate
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return CGFloat.leastNormalMagnitude
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForHeaderInSection section: Int) -> CGFloat {
        return CGFloat.leastNormalMagnitude
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.section {
        case 0:
            switch indexPath.row {
            case 0:
                self.presentYourOrders()
                break
            case 1:
                self.presentFavorites()
                break
            case 2:
                self.presentSavedFoodItems()
                break
            case 3:
                self.presentSettings()
                break
            default:
                break
            }
        default:
            break
        }
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    
    //MARK: Actions
    
    func presentYourOrders() {
        let nvc = UINavigationController()
        let visitHistoryVC = VisitHistoryVC()
        nvc.viewControllers = [visitHistoryVC]
        currentViewController?.present(nvc, animated: true, completion: nil)
    }
    
    func presentFavorites() {
        let nvc = UINavigationController()
        let favoritePlacesVC = FavoritePlacesVC()
        nvc.viewControllers = [favoritePlacesVC]
        currentViewController?.present(nvc, animated: true, completion: nil)
    }
    
    func presentSavedFoodItems() {
        let nvc = UINavigationController()
        nvc.isNavigationBarHidden = true
        let addSearchTermsVC = AddSearchTermsVC()
        addSearchTermsVC.setDone = true
        nvc.viewControllers = [addSearchTermsVC]
        currentViewController?.present(nvc, animated: true, completion: nil)
    }
    
    func presentSettings() {
        let nvc = UINavigationController()
        let settingsVC = SettingsVC()
        nvc.viewControllers = [settingsVC]
        currentViewController?.present(nvc, animated: true, completion: nil)
    }
    
}
