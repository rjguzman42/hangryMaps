//
//  SettingCell.swift
//  chefspot
//
//  Created by Roberto Guzman on 7/11/18.
//  Copyright © 2018 Fortytwo Sports. All rights reserved.
//

import Foundation

class SettingCell: UITableViewCell {
    
    let settingIcon: UIImageView = {
        let view = UIImageView(frame: CGRect(x: 0, y: 0, width: Constants.Sizes.settingIcon.width, height: Constants.Sizes.settingIcon.height))
        view.clipsToBounds = true
        view.isHidden = true
        view.contentMode = .scaleAspectFill
        return view
    }()
    let settingTitle: UILabel = {
        let label = UILabel()
        label.text = ""
        label.font = Theme.Fonts.primaryMedium.font
        label.textColor = Theme.Colors.primaryText.color
        label.numberOfLines = 1
        label.contentMode = .center
        label.lineBreakMode = .byTruncatingTail
        label.textAlignment = .center
        return label
    }()
    let lineView: UIView = {
        let view = UIView(frame: CGRect(x: 0.0, y: 0.0, width: Constants.Sizes.lineView.width, height: Constants.Sizes.lineView.height))
        view.isHidden = true
        view.backgroundColor = UIColor.groupTableViewBackground
        return view
    }()
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupSubViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        reset()
    }
    
    deinit {
        DebugLog.DLog("Setting Cell Deinited")
    }
    
    func reset() {
        settingTitle.text = ""
        settingIcon.image = nil
        settingIcon.isHidden = true
        lineView.isHidden = true
    }
    
    
    //MARK: UI
    
    func setupSubViews() {
        
        //lineView
        addSubview(lineView)
        addConstraintsWithFormat(format: "H:|[v0]|", views: lineView)
        addConstraintsWithFormat(format: "V:|[v0(\(Constants.Sizes.lineView.height))]", views: lineView)
        
        //settingIcon
        addSubview(settingIcon)
        addConstraintsWithFormat(format: "H:|-12-[v0(\(Constants.Sizes.settingIcon.width))]", views: settingIcon)
        addConstraintsWithFormat(format: "V:[v0(\(Constants.Sizes.settingIcon.height))]", views: settingIcon)
        addConstraint(NSLayoutConstraint(item: settingIcon, attribute: .centerY, relatedBy: .equal, toItem: self, attribute: .centerY, multiplier: 1, constant: 0))
        
        //settingTitle
        addSubview(settingTitle)
        addConstraintsWithFormat(format: "H:[v1]-12-[v0]", views: settingTitle, settingIcon)
        addConstraintsWithFormat(format: "V:[v0(\(Constants.Sizes.singleLineLabelHeight))]-10-|", views: settingTitle)
        addConstraint(NSLayoutConstraint(item: settingTitle, attribute: .centerY, relatedBy: .equal, toItem: self, attribute: .centerY, multiplier: 1, constant: 0))
    }
}

