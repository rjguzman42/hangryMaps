//
//  SearchTermCell.swift
//  chefspot
//
//  Created by Roberto Guzman on 7/16/18.
//  Copyright © 2018 Fortytwo Sports. All rights reserved.
//

import Foundation
import UIKit

class SearchTermCell: UICollectionViewCell {
    
    let termIcon: UIImageView = {
        let view = UIImageView(frame: CGRect(x: 0, y: 0, width: Constants.Sizes.termIconSmall.width, height: Constants.Sizes.termIconSmall.height))
        view.clipsToBounds = true
        view.contentMode = .scaleAspectFill
        return view
    }()
    let title: UILabel = {
        let label = UILabel()
        label.text = ""
        label.textColor = Theme.Colors.primaryText.color
        label.font = Theme.Fonts.primaryMedium.font
        label.lineBreakMode = NSLineBreakMode.byTruncatingTail
        label.textAlignment = .center
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("Init(coder:) has not been implemented")
    }
    
    override var isHighlighted: Bool {
        didSet {
            title.textColor = isHighlighted ? Theme.Colors.primaryText.color : Theme.Colors.primaryText.color
            title.font = isHighlighted ? Theme.Fonts.primaryMedium.font : Theme.Fonts.primaryMedium.font
        }
    }
    
    override var isSelected: Bool {
        didSet {
            title.textColor = isSelected ? Theme.Colors.primaryText.color : Theme.Colors.primaryText.color
            title.font = isSelected ? Theme.Fonts.primaryMedium.font : Theme.Fonts.primaryMedium.font
        }
    }
    
    override func prepareForReuse() {
        title.textColor = isHighlighted ? Theme.Colors.primaryText.color : Theme.Colors.primaryText.color
        title.font = isHighlighted ? Theme.Fonts.primaryMedium.font : Theme.Fonts.primaryMedium.font
    }
    
    
    //MARK: UI
    
    func setupViews() {
        backgroundColor = Theme.Colors.reallyWhite.color
        layer.borderColor = Theme.Colors.hintGray.color.cgColor
        layer.borderWidth = 1
        clipsToBounds = true
        layer.cornerRadius = 6
        
        //settingIcon
        addSubview(termIcon)
        addConstraintsWithFormat(format: "H:[v0(\(Constants.Sizes.termIconSmall.width))]", views: termIcon)
        addConstraintsWithFormat(format: "V:[v0(\(Constants.Sizes.termIconSmall.height))]", views: termIcon)
        addConstraint(NSLayoutConstraint(item: termIcon, attribute: .centerX, relatedBy: .equal, toItem: self, attribute: .centerX, multiplier: 1, constant: 0))
        addConstraint(NSLayoutConstraint(item: termIcon, attribute: .bottom, relatedBy: .equal, toItem: self, attribute: .centerY, multiplier: 1, constant: -10))
        
        //title
        addSubview(title)
        addConstraintsWithFormat(format: "H:|[v0]|", views: title)
        addConstraintsWithFormat(format: "V:[v0]", views: title)
        addConstraint(NSLayoutConstraint(item: title, attribute: .top, relatedBy: .equal, toItem: self, attribute: .centerY, multiplier: 1, constant: 10))
    }
    
}
