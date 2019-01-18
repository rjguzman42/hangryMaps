//
//  PlaceMarkerView.swift
//  Hangry Maps
//
//  Created by Roberto Guzman on 7/24/18.
//  Copyright © 2018 Fortytwo Sports. All rights reserved.
//

import Foundation
import UIKit

class PlaceMarkerView: UIView {
    
    let contentView: UIView = {
        let view = UIView(frame: CGRect(x: 0, y: 0, width: Constants.Sizes.placeMarkerView.width, height: Constants.Sizes.placeMarkerView.height))
        view.backgroundColor = Theme.Colors.reallyWhite.color
        view.clipsToBounds = true
        view.layer.cornerRadius = Constants.Sizes.placeMarkerCornerRadius
        return view
    }()
    lazy var placePriceStarView: PlacePriceStarView = {
        let view = PlacePriceStarView(frame: CGRect(x: 0, y: 0, width: frame.size.width, height: Constants.Sizes.placePriceStarView.height))
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
        contentView.backgroundColor = Theme.Colors.reallyWhite.color
        contentView.clipsToBounds = true
        contentView.layer.cornerRadius = Constants.Sizes.placeMarkerCornerRadius
        contentView.dropShadow()
        
        //contentView
        addSubview(contentView)
        addConstraintsWithFormat(format: "H:|-10-[v0]-10-|", views: contentView)
        addConstraintsWithFormat(format: "V:|-10-[v0]-10-|", views: contentView)

        
        //placePriceStarView
        contentView.addSubview(placePriceStarView)
        contentView.addConstraintsWithFormat(format: "H:|-5-[v0]-5-|", views: placePriceStarView)
        contentView.addConstraintsWithFormat(format: "V:|-5-[v0]-5-|", views: placePriceStarView)
        
    }
    
    func addPlaceInfo(place: GooglePlace) {
        placePriceStarView.addPlaceInfo(place: place)
    }
    
}
