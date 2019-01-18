//
//  OrderFooterView.swift
//  chefspot
//
//  Created by Roberto Guzman on 7/12/18.
//  Copyright © 2018 Fortytwo Sports. All rights reserved.
//

import Foundation

class OrderFooterView: UIView {
    
    let eatNowButton: FlatButton = {
        let button = FlatButton(frame: CGRect(x: UIScreen.main.bounds.size.width, y: UIScreen.main.bounds.size.height, width: Constants.Sizes.eatNowButton.width, height: Constants.Sizes.eatNowButton.height))
        button.setTitle(Constants.Strings.eatNow, for: .normal)
        button.layer.cornerRadius = button.frame.size.width / 15
        return button
    }()
    let placePriceStarView: PlacePriceStarView = {
        let view = PlacePriceStarView(frame: CGRect(x: 0, y: 0, width: Constants.Sizes.orderFooterView.width, height: Constants.Sizes.placePriceStarView.height))
        return view
    }()
    var favButtonTapped: (() -> Void)?
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupSubViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    //MARK: UI
    
    func setupSubViews() {
        backgroundColor =  Theme.Colors.reallyWhite.color
        dropShadow()
        
        //eatNowButton
        addSubview(eatNowButton)
        addConstraintsWithFormat(format: "H:[v0(\(Constants.Sizes.eatNowButton.width))]-10-|", views: eatNowButton)
        addConstraintsWithFormat(format: "V:|-10-[v0]-10-|", views: eatNowButton)
        
        //placePriceStarView
        addSubview(placePriceStarView)
        addConstraintsWithFormat(format: "H:|-10-[v0]-10-[v1]", views: placePriceStarView, eatNowButton)
        addConstraintsWithFormat(format: "V:|-10-[v0]-10-|", views: placePriceStarView)
        
        addGestures()
    }
    
    func addPlaceInfo(place: GooglePlace) {
        placePriceStarView.addPlaceInfo(place: place)
    }
    
    
    //MARK: Actions
    
    func addGestures() {
        eatNowButton.addTarget(self, action: #selector(handleFavButtonTapped), for: .touchUpInside)
    }
    
    @objc func handleFavButtonTapped() {
        if favButtonTapped != nil {
            favButtonTapped!()
        }
    }
}
