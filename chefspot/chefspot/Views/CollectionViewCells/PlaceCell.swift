//
//  PlaceCell.swift
//  chefspot
//
//  Created by Roberto Guzman on 7/9/18.
//  Copyright © 2018 Fortytwo Sports. All rights reserved.
//

import Foundation
import UIKit

class PlaceCell: UICollectionViewCell {
    
    let placeImageView: UIImageView = {
        let view = UIImageView()
        view.backgroundColor = Theme.Colors.hintGray.color
        view.clipsToBounds = true
        view.isUserInteractionEnabled = true
        view.layer.cornerRadius = Constants.Sizes.squareCornerRadius
        view.contentMode = .scaleAspectFill
        return view
    }()
    let placePriceStarView: PlacePriceStarView = {
        let view = PlacePriceStarView(frame: CGRect(x: 0, y: 0, width: Constants.Sizes.placePriceStarView.width, height: Constants.Sizes.placePriceStarView.height))
        return view
    }()
    var place: GooglePlace!
    var cellTapped: (() -> Void)?
    let dataManager = DataManager.sharedInstance
    
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
        backgroundColor = Theme.Colors.reallyWhite.color
        
        //placePriceStarView
        addSubview(placePriceStarView)
        addConstraintsWithFormat(format: "H:|[v0]|", views: placePriceStarView)
        addConstraintsWithFormat(format: "V:[v0(\(Constants.Sizes.placePriceStarView.height))]-5-|", views: placePriceStarView, placeImageView)
        
        //placeImageView
        addSubview(placeImageView)
        addConstraintsWithFormat(format: "H:|[v0]|", views: placeImageView)
        addConstraintsWithFormat(format: "V:|[v0]-0-[v1]", views: placeImageView, placePriceStarView)
        
        addGestures()
    }
    
    func addPlaceInfo(place: GooglePlace) {
        self.place = place
        placePriceStarView.addPlaceInfo(place: place)
    }
    
    func reset() {
        placeImageView.image = nil
        placePriceStarView.reset()
    }
    
    
    //MARK: Actions
    
    func addGestures() {
        let placeTapGesture = UITapGestureRecognizer(target: self, action: #selector(handlePlaceImageViewTapped))
        placeImageView.addGestureRecognizer(placeTapGesture)
    }
    
    @objc func handlePlaceImageViewTapped() {
        if cellTapped != nil {
            cellTapped!()
        }
    }
    
}
