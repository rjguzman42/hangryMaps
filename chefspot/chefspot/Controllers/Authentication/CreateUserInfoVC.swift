//
//  CreateUserInfoVC.swift
//  chefspot
//
//  Created by Roberto Guzman on 7/16/18.
//  Copyright © 2018 Fortytwo Sports. All rights reserved.
//

import Foundation
import UIKit
import MapKit

class CreateUserInfoVC: UIViewController, CLLocationManagerDelegate {
    
    let doneButton: FlatButton = {
        let button = FlatButton(frame: CGRect(x: UIScreen.main.bounds.size.width / 2, y: UIScreen.main.bounds.size.height, width: UIScreen.main.bounds.size.width, height: Constants.Sizes.flatButtonHeight))
        button.setTitle(Constants.Strings.done, for: .normal)
        button.setLargeTheme()
        return button
    }()
    let userEditView: UserEditView = {
        let view = UserEditView(frame: CGRect(x: 0, y: 0, width: Constants.Sizes.userEditView.width, height: Constants.Sizes.userEditView.height))
        return view
    }()
    lazy var skipButton: UIBarButtonItem = {
        let button = UIBarButtonItem(title: Constants.Strings.skip, style: .done, target: self, action: #selector(handleSkipButtonTapped))
        return button
    }()
    let utility = AppUtility.sharedInstance
    let userManager = UserManager.sharedInstance
    private let locationManager = CLLocationManager()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.isHidden = false
        setupSubViews()
        requestUserLocation()
    }
    
    
    //MARK: UI
    
    func setupSubViews() {
        view.backgroundColor = Theme.Colors.reallyWhite.color
        title = ""
        navigationItem.hidesBackButton = true
        navigationItem.rightBarButtonItem = skipButton
        
        //doneButton
        view.addSubview(doneButton)
        view.addConstraintsWithFormat(format: "H:|-20-[v0]-20-|", views: doneButton)
        view.addConstraintsWithFormat(format: "V:[v0(\(Constants.Sizes.flatButtonHeight))]-20-|", views: doneButton)
        
        //userEditView
        view.addSubview(userEditView)
        view.addConstraintsWithFormat(format: "H:|[v0]|", views: userEditView)
        view.addConstraintsWithFormat(format: "V:|-45-[v0(\(Constants.Sizes.userEditView.height))]", views: userEditView)
        
        addGestures()
    }
    
    
    //MARK: Actions
    
    func addGestures() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleDoneButtonTapped))
        doneButton.addGestureRecognizer(tapGesture)
        
        let swipeDown = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipeViewGesture(_:)))
        swipeDown.direction = UISwipeGestureRecognizerDirection.down
        view.addGestureRecognizer(swipeDown)
    }
    
    @objc func handleDoneButtonTapped() {
        let checkedCredentials = utility.checkAuthCredentials(nameInput: userEditView.userNameEdit, profileImageView: userEditView.profileImageView)
        if checkedCredentials {
            authenticate()
        }
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
    
    @objc func handleSkipButtonTapped() {
        userEditView.userNameEdit.text = Constants.Strings.defaultUserName
        userEditView.profileImageView.image = UIImage(named: "default_user_pic")
        handleDoneButtonTapped()
    }
    
    func requestUserLocation() {
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
    }
    
    
    //MARK: Authentication
    
    func authenticate() {
        if let name = userEditView.userNameEdit.text, let image = userEditView.profileImageView.image {
            userManager.authenticate(name: name, profileImage: image, completion: { [weak self] in
                if self != nil {
                    let appDelegate = UIApplication.shared.delegate as! AppDelegate
                    appDelegate.updateRootVC()
                }
            })
        }
    }
    
    
}
