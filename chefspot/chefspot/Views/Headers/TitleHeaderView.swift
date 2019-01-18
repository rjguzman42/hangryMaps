//
//  TitleHeaderView.swift
//  chefspot
//
//  Created by Roberto Guzman on 7/12/18.
//  Copyright © 2018 Fortytwo Sports. All rights reserved.
//

import Foundation

class TitleHeaderView: UIView {
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.text = ""
        label.font = Theme.Fonts.primaryLargeBold.font
        label.textColor = Theme.Colors.primaryText.color
        label.numberOfLines = 1
        label.contentMode = .left
        label.lineBreakMode = .byTruncatingTail
        label.textAlignment = .left
        return label
    }()
    let lineView: UIView = {
        let view = UIView(frame: CGRect(x: 0.0, y: 0.0, width: Constants.Sizes.lineView.width, height: Constants.Sizes.lineView.height))
        view.isHidden = true
        view.backgroundColor = UIColor.groupTableViewBackground
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupSubViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    //MARK: UI
    
    func setupSubViews() {
        
        //lineView
        addSubview(lineView)
        addConstraintsWithFormat(format: "H:|[v0]|", views: lineView)
        addConstraintsWithFormat(format: "V:|[v0(\(Constants.Sizes.lineView.height))]", views: lineView)
        
        //titleLabel
        addSubview(titleLabel)
        addConstraintsWithFormat(format: "H:|-10-[v0]-10-|", views: titleLabel)
        addConstraintsWithFormat(format: "V:[v1]-10-[v0(\(titleLabel.font.pointSize + 5))]-10-|", views: titleLabel, lineView)
    }
}
