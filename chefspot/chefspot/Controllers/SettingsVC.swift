//
//  SettingsVC.swift
//  chefspot
//
//  Created by Roberto Guzman on 7/11/18.
//  Copyright © 2018 Fortytwo Sports. All rights reserved.
//

import Foundation
import StoreKit
import UIKit

class SettingsVC: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
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
    let userEditView: UserEditView = {
        let view = UserEditView(frame: CGRect(x: 0, y: 0, width: Constants.Sizes.userEditView.width, height: Constants.Sizes.userEditView.height))
        return view
    }()
    lazy var saveButton: UIBarButtonItem = {
        let button = UIBarButtonItem(title: Constants.Strings.save, style: .done, target: self, action: #selector(handleSaveButtonTapped))
        return button
    }()
    lazy var backButton: UIBarButtonItem = {
        let button = UIBarButtonItem(barButtonSystemItem: .stop, target: self, action: #selector(backAction))
        return button
    }()
    var sections = [SettingItem.SettingCategory.sideView]
    var items = [SettingItem]()
    var settingItems: [SettingItem.SettingCategory :[SettingItem]] = {
        let utility = AppUtility.sharedInstance
        let items: [SettingItem] = [SettingItem(category: .sideView, title: Constants.Strings.rateApp, imageName: "ic_star_full", placeholder: nil, userInputText: nil),
                                    SettingItem(category: .sideView, title: Constants.Strings.shareApp, imageName: "ic_share", placeholder: nil, userInputText: nil),
                                    SettingItem(category: .sideView, title: Constants.Strings.logout, imageName: "ic_logout", placeholder: nil, userInputText: nil)]
        return utility.groupBy(items) { $0.category}
    }()
    let utility = AppUtility.sharedInstance
    let userManager = UserManager.sharedInstance
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupSubViews()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        utility.hideStatusBar(false)
    }
    
    
    //MARK: UI
    
    func setupSubViews() {
        title = Constants.Strings.settings
        view.backgroundColor = Theme.Colors.reallyWhite.color
        
        //navigationBar
        navigationItem.rightBarButtonItem = saveButton
        navigationItem.leftBarButtonItem = backButton
        
        //tableView
        view.addSubview(tableView)
        view.addConstraintsWithFormat(format: "H:|[v0]|", views: tableView)
        view.addConstraintsWithFormat(format: "V:|[v0]|", views: tableView)
        tableView.register(SettingCell.self, forCellReuseIdentifier: Constants.Cells.settingCellId)
        
        tableView.tableFooterView = UIView(frame: CGRect.zero)
        tableView.estimatedRowHeight = CGFloat(400)
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.scrollsToTop = true
        tableView.tableHeaderView = userEditView
        
        addGestures()
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
                self.rateApp()
                break
            case 1:
                self.shareApp()
                break
            case 2:
                self.logOut()
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
    
    func addGestures() {
        let swipeDown = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipeViewGesture(_:)))
        swipeDown.direction = UISwipeGestureRecognizerDirection.down
        view.addGestureRecognizer(swipeDown)
    }
    
    @objc func handleSwipeViewGesture(_ gesture: UISwipeGestureRecognizer) {
        switch gesture.direction {
        case UISwipeGestureRecognizerDirection.right:
            break
        case UISwipeGestureRecognizerDirection.down:
            //hide keyboards
            userEditView.userNameEdit.resignFirstResponder()
            break
        case UISwipeGestureRecognizerDirection.left:
            break
        case UISwipeGestureRecognizerDirection.up:
            break
        default:
            break
        }
    }
    
    @objc func backAction() {
        self.dismiss(animated: true, completion: nil)
    }
    
    func rateApp() {
        if #available( iOS 10.3,*){
            SKStoreReviewController.requestReview()
        }
    }
    
    func shareApp() {
        guard let tableViewCell = tableView.cellForRow(at: IndexPath(item: 1, section: 0)) else {
            return
        }
        
        let shareText = Constants.Strings.inviteFriendsMessage
        let objectsToShare = [shareText] //Add items here with a comma if you want to share more (such as URL)
        let activityVC = UIActivityViewController(activityItems: objectsToShare, applicationActivities: nil)
        
        //Excluded Activities Code
        activityVC.excludedActivityTypes = [UIActivityType.airDrop, UIActivityType.addToReadingList]
        
        //presenter for ipad
        if let presenter = activityVC.popoverPresentationController {
            presenter.sourceView = tableViewCell
            presenter.sourceRect = tableViewCell.bounds
        }
        
        self.present(activityVC, animated: true, completion: nil)
    }
    
    func logOut() {
        guard let tableView = tableView.cellForRow(at: IndexPath(item: 2, section: 0)) else {
            return
        }
        let alertController = UIAlertController(title: Constants.Alerts.logOutTitle, message: Constants.Alerts.logOutMessage, preferredStyle: UIAlertControllerStyle.actionSheet)
        
        //adding actions to alert controller
        alertController.addAction(UIAlertAction(title: Constants.Strings.cancel, style: .cancel, handler: nil))
        alertController.addAction(UIAlertAction(title: Constants.Strings.logout, style: .default, handler:{ [weak self] action in
            
            self?.userManager.logOut()
            
        }))
        
        if let presenter = alertController.popoverPresentationController {
            presenter.sourceView = tableView
            presenter.sourceRect = tableView.bounds
        }
        present(alertController, animated: true, completion: nil)
    }
    
    @objc func handleSaveButtonTapped() {
        guard userEditView.nameWasEdited || userEditView.imageWasEdited else {
            backAction()
            return
        }
        
        let checkedCredentials = utility.checkAuthCredentials(nameInput: userEditView.userNameEdit, profileImageView: userEditView.profileImageView)
        if checkedCredentials {
            if let name = userEditView.userNameEdit.text, let profileImage = userEditView.profileImageView.image {
                userManager.updateLocalUser(name: name, profileImage: profileImage, completion: {[weak self] result in
                    if self != nil {
                        switch result {
                        case .success(let _):
                            self?.backAction()
                            break
                        default:
                            break
                        }
                    }
                })
            }
        }
    }
}
