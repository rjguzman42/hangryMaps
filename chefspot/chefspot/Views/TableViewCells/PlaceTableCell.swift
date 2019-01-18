//
//  PlaceTableCell.swift
//  chefspot
//
//  Created by Roberto Guzman on 7/19/18.
//  Copyright © 2018 Fortytwo Sports. All rights reserved.
//

import Foundation
import UIKit

class PlaceTableCell: UITableViewCell {
    
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
        let view = PlacePriceStarView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.size.width, height: Constants.Sizes.placePriceStarView.height))
        return view
    }()
    var place: GooglePlace!
    var cellTapped: (() -> Void)?
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
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
        
        //placeImageView
        addSubview(placeImageView)
        addConstraintsWithFormat(format: "H:|-10-[v0(\(Constants.Sizes.placeTableImageView.width))]", views: placeImageView)
        addConstraintsWithFormat(format: "V:|-10-[v0(\(Constants.Sizes.placeTableImageView.height))]-10-|", views: placeImageView)
        
        //placePriceStarView
        addSubview(placePriceStarView)
        addConstraintsWithFormat(format: "H:[v1]-5-[v0]-10-|", views: placePriceStarView, placeImageView)
        addConstraintsWithFormat(format: "V:|-10-[v0]-10-|", views: placePriceStarView)
        
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
        addGestureRecognizer(placeTapGesture)
    }
    
    @objc func handlePlaceImageViewTapped() {
        if cellTapped != nil {
            cellTapped!()
        }
    }
    
}
