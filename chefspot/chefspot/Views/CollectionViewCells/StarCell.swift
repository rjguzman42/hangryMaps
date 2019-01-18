//
//  StarCell.swift
//  chefspot
//
//  Created by Roberto Guzman on 7/12/18.
//  Copyright © 2018 Fortytwo Sports. All rights reserved.
//

import Foundation

class StarCell: UICollectionViewCell {
    
    let starImageView: UIImageView = {
        let view = UIImageView()
        view.backgroundColor = Theme.Colors.reallyWhite.color
        view.clipsToBounds = true
        view.isUserInteractionEnabled = true
        view.image = UIImage(named: "ic_star_empty")?.withRenderingMode(.alwaysTemplate)
        view.tintColor = Theme.Colors.primaryPurple.color
        view.layer.cornerRadius = Constants.Sizes.squareCornerRadius
        view.contentMode = .scaleAspectFill
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupSubViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("Init(coder:) has not been implemented")
    }
    
    deinit {
        reset()
        DebugLog.DLog("PlaceCell Deinited")
    }
    
    override func prepareForReuse() {
        reset()
    }
    
    
    //MARK: UI
    
    func setupSubViews() {
        
        //starImageView
        addSubview(starImageView)
        addConstraintsWithFormat(format: "H:|[v0]|", views: starImageView)
        addConstraintsWithFormat(format: "V:|[v0]|", views: starImageView)
    }
    
    func reset() {
        starImageView.image = nil
    }
    
}
