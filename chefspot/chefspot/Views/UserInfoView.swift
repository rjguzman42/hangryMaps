//
//  UserInfoView.swift
//  chefspot
//
//  Created by Roberto Guzman on 7/11/18.
//  Copyright © 2018 Fortytwo Sports. All rights reserved.
//

import Foundation
import UIKit

class UserInfoView: UIView {
    
    let profileImageView: UIImageView = {
        let view = UIImageView()
        view.frame = CGRect(x: 0, y: 0, width: Constants.Sizes.profileImageLarge.width, height: Constants.Sizes.profileImageLarge.height)
        view.clipsToBounds = true
        view.layer.cornerRadius = view.bounds.size.width / 2
        view.backgroundColor = Theme.Colors.reallyWhite.color
        return view
    }()
    let userNameLabel: UILabel = {
        let label = UILabel()
        label.text = "Name"
        label.font = Theme.Fonts.primaryDemiBold.font
        label.textColor = Theme.Colors.primaryText.color
        label.numberOfLines = 1
        label.contentMode = .center
        label.textAlignment = .center
        return label
    }()
    let userManager = UserManager.sharedInstance
    let libraryAPI = LibraryAPI.sharedInstance
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupSubViews()
        addUserInfo()
        subscribeToNotifications()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    deinit {
        unsubscribeToNotifications()
    }
    
    
    //MARK: UI
    
    func setupSubViews() {
        backgroundColor = Theme.Colors.reallyWhite.color
        
        //profileImageView
        addSubview(profileImageView)
        addConstraintsWithFormat(format: "H:[v0(\(Constants.Sizes.profileImageLarge.width))]", views: profileImageView)
        addConstraintsWithFormat(format: "V:|-20-[v0(\(Constants.Sizes.profileImageLarge.height))]", views: profileImageView)
        addConstraint(NSLayoutConstraint(item: profileImageView, attribute: .centerX, relatedBy: .equal, toItem: self, attribute: .centerX, multiplier: 1, constant: 0))
        
        //userNameLabel
        addSubview(userNameLabel)
        addConstraintsWithFormat(format: "H:[v0]", views: userNameLabel)
        addConstraintsWithFormat(format: "V:[v1]-10-[v0]", views: userNameLabel, profileImageView)
        addConstraint(NSLayoutConstraint(item: userNameLabel, attribute: .centerX, relatedBy: .equal, toItem: profileImageView, attribute: .centerX, multiplier: 1, constant: 0))
    }
    
    func addUserInfo() {
        if let name = userManager.localUser?.name {
            userNameLabel.text = name
        }
        if let profileImageData = userManager.localUser?.profileImageData {
            profileImageView.image = UIImage(data: profileImageData)
        } else if let profileImagePath = userManager.localUser?.profileImagePath {
            libraryAPI.downloadImageWithPath(path: profileImagePath, completion: { [weak self] image, data in
                if image != nil {
                    self?.profileImageView.image = image
                }
            })
        }
    }
    
    
    //MARK: Notifications
    
    func subscribeToNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(handleUserUpdated(_:)), name: .userUpdated, object: nil)
    }
    
    func unsubscribeToNotifications() {
        NotificationCenter.default.removeObserver(self)
    }
    
    @objc func handleUserUpdated(_ notification: Notification) {
        addUserInfo()
    }
    
    
}
