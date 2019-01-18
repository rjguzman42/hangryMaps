//
//  PlaceHeaderView.swift
//  chefspot
//
//  Created by Roberto Guzman on 7/11/18.
//  Copyright © 2018 Fortytwo Sports. All rights reserved.
//

import Foundation

class PlaceHeaderView: UIView {
    
    let placeImageView: UIImageView = {
        let view = UIImageView()
        view.backgroundColor = Theme.Colors.backgroundBlack.color
        view.contentMode = .scaleToFill
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupSubViews()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    
    //MARK: UI
    
    func setupSubViews() {
        
        //placeImageView
        addSubview(placeImageView)
        addConstraintsWithFormat(format: "H:|[v0]|", views: placeImageView)
        addConstraintsWithFormat(format: "V:|[v0]|", views: placeImageView)
        
    }
}
