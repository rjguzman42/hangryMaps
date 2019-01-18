//
//  FoodFilterView.swift
//  chefspot
//
//  Created by Roberto Guzman on 7/9/18.
//  Copyright © 2018 Fortytwo Sports. All rights reserved.
//

import Foundation
import UIKit

class FoodFilterView: UIView {
    
    let horizontalLineView: UIImageView = {
        let view = UIImageView()
        view.image = UIImage(named: "ic_horizontal_line")
        return view
    }()
    lazy var menuBar: MenuBar = {
        let mb = MenuBar()
        return mb
    }()
    let placeScrollView: PlaceScrollView = {
        let view = PlaceScrollView()
        return view
    }()
    
    let utility = AppUtility.sharedInstance
    lazy var currentController = utility.getCurrentViewController()
    var placeCellTapped: ((_ place: GooglePlace) -> Void)?
    var loadPlaceCellTapped: ((_ searchTerm: String) -> Void)?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupSubViews()
        placeScrollView.scrollToSection(section: 0, animated: false)
        menuBar.scrollToMenuIndex(menuIndex: 0, animated: false)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    
    //MARK: UI
    
    func setupSubViews() {
        backgroundColor = Theme.Colors.reallyWhite.color
        dropShadow()
        
        //horizontalLine
        addSubview(horizontalLineView)
        addConstraintsWithFormat(format: "H:[v0(\(Constants.Sizes.horizontalLineView.width))]", views: horizontalLineView)
        addConstraintsWithFormat(format: "V:|[v0(\(Constants.Sizes.horizontalLineView.height))]", views: horizontalLineView)
        addConstraint(NSLayoutConstraint(item: horizontalLineView, attribute: .centerX, relatedBy: .equal, toItem: self, attribute: .centerX, multiplier: 1, constant: 0))
        
        //menuBar
        addSubview(menuBar)
        addConstraintsWithFormat(format: "H:|[v0]|", views: menuBar)
        addConstraintsWithFormat(format: "V:[v1]-0-[v0(\(Constants.Sizes.menuBar.height))]", views: menuBar, horizontalLineView)
        
        //placeScrollView
        addSubview(placeScrollView)
        addConstraintsWithFormat(format: "H:|[v0]|", views: placeScrollView)
        addConstraintsWithFormat(format: "V:[v1]-0-[v0(\(Constants.Sizes.placeScrollView.height))]", views: placeScrollView, menuBar)
        placeScrollView.placeCellTapped = { [weak self] place in
            if self?.placeCellTapped != nil {
                self?.placeCellTapped!(place)
            }
        }
        placeScrollView.loadPlaceCellTapped = { [weak self] searchTerm in
            if self?.loadPlaceCellTapped != nil {
                self?.loadPlaceCellTapped!(searchTerm)
            }
        }
    }
}
