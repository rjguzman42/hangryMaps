//
//  GetStartedVC.swift
//  chefspot
//
//  Created by Roberto Guzman on 7/6/18.
//  Copyright © 2018 Fortytwo Sports. All rights reserved.
//

import Foundation
import UIKit

class GetStartedVC: UIViewController {
    
    let descriptionLabel: UILabel = {
        let label = UILabel()
        label.font = Theme.Fonts.primarySuperLargeBold.font
        label.textColor = Theme.Colors.primaryPurple.color
        label.numberOfLines = 0
        label.textAlignment = .center
        label.text = Constants.Strings.welcomeMessage
        return label
    }()
    let getStartedButton: FlatButton = {
        let button = FlatButton(frame: CGRect(x: UIScreen.main.bounds.size.width / 2, y: UIScreen.main.bounds.size.height, width: UIScreen.main.bounds.size.width, height: Constants.Sizes.flatButtonHeight))
        button.setTitle(Constants.Strings.getStarted, for: .normal)
        button.setLargeTheme()
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupSubViews()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.isHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.navigationBar.isHidden = true
    }
    
    
    //MARK: UI
    
    func setupSubViews() {
        view.backgroundColor = Theme.Colors.reallyWhite.color
        title = ""
        
        //getStartedButton
        view.addSubview(getStartedButton)
        view.addConstraintsWithFormat(format: "H:|-20-[v0]-20-|", views: getStartedButton)
        view.addConstraintsWithFormat(format: "V:[v0(\(Constants.Sizes.flatButtonHeight))]-20-|", views: getStartedButton)
        
        //descriptionLabel
        view.addSubview(descriptionLabel)
        view.addConstraintsWithFormat(format: "H:|-20-[v0]-20-|", views: descriptionLabel)
        view.addConstraintsWithFormat(format: "V:[v0]", views: descriptionLabel)
        view.addConstraint(NSLayoutConstraint(item: descriptionLabel, attribute: .bottom, relatedBy: .equal, toItem: view, attribute: .centerY, multiplier: 1, constant: 0))
        
        addGestures()
    }
    
    
    //MARK: Actions
    
    func addGestures() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleGetStartedTapped))
        getStartedButton.addGestureRecognizer(tapGesture)
    }
    
    @objc func handleGetStartedTapped() {
        let addSearchTermsVC = AddSearchTermsVC()
        navigationController?.pushViewController(addSearchTermsVC, animated: true)
    }
    
    
    
    
}
