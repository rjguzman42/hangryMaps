//
//  PlacePriceStarView.swift
//  chefspot
//
//  Created by Roberto Guzman on 7/12/18.
//  Copyright © 2018 Fortytwo Sports. All rights reserved.
//

import Foundation

class PlacePriceStarView: UIView {
    
    let nameLabel: UILabel = {
        let label = UILabel()
        label.text = ""
        label.textAlignment = .left
        label.font = Theme.Fonts.primaryMedium.font
        label.textColor = Theme.Colors.primaryText.color
        label.lineBreakMode = .byTruncatingTail
        return label
    }()
    let priceLabel: UILabel = {
        let label = UILabel()
        label.text = ""
        label.textAlignment = .left
        label.font = Theme.Fonts.primarySmall.font
        label.textColor = Theme.Colors.hintGray.color
        return label
    }()
    let starsView: StarsView = {
        let view = StarsView(frame: CGRect(x: 0, y: 0, width: Constants.Sizes.starsView.width, height: Constants.Sizes.starsView.height))
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
        backgroundColor = Theme.Colors.reallyWhite.color
        
        //nameLabel
        addSubview(nameLabel)
        addConstraintsWithFormat(format: "H:|[v0]|", views: nameLabel)
        addConstraintsWithFormat(format: "V:|[v0(\(Constants.Sizes.singleLineLabelHeight))]", views: nameLabel)
        
        //starsView
        addSubview(starsView)
        addConstraintsWithFormat(format: "H:|[v0(\(frame.size.width / 2))]", views: starsView)
        addConstraintsWithFormat(format: "V:[v1]-0-[v0(\(Constants.Sizes.starsView.height))]", views: starsView, nameLabel)
        
        //priceLabel
        addSubview(priceLabel)
        addConstraintsWithFormat(format: "H:[v1]-0-[v0(\(frame.size.width / 2))]|", views: priceLabel, starsView)
        addConstraintsWithFormat(format: "V:[v1]-0-[v0(\(Constants.Sizes.starsView.height))]", views: priceLabel, nameLabel)
        
    }
    
    func addPlaceInfo(place: GooglePlace) {
        if let rating = place.rating {
            starsView.averageReview = rating
            starsView.addPlaceInfo()
        }
        if let priceLevel = place.priceLevel {
            for _ in 0..<Int(priceLevel) {
                if let text = priceLabel.text {
                    priceLabel.text = text + "$"
                }
            }
        }
        if let name = place.name {
            nameLabel.text = name
        }
    }
    
    func reset() {
        priceLabel.text = ""
        nameLabel.text = ""
        starsView.reset()
    }
}
