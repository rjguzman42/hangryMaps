//
//  TermIconCell.swift
//  chefspot
//
//  Created by Roberto Guzman on 7/19/18.
//  Copyright © 2018 Fortytwo Sports. All rights reserved.
//

import Foundation
import UIKit

class TermIconCell: UICollectionViewCell {
    
    let termIcon: UIImageView = {
        let view = UIImageView(frame: CGRect(x: 0, y: 0, width: Constants.Sizes.termIconCell.width, height: Constants.Sizes.termIconCell.height))
        view.clipsToBounds = true
        view.contentMode = .scaleAspectFit
        return view
    }()
    lazy var lineView: UIView = {
        let view = UIView(frame: CGRect(x: 0, y: 0, width: termIcon.bounds.size.width, height: 1))
        view.backgroundColor = Theme.Colors.primaryPurple.color
        isHidden = false
        return view
    }()
    var iconTapped: (() -> Void)?
    var imageName: String?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupSubViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        reset()
    }
    
    //MARK: UI
    
    func setupSubViews() {
        isUserInteractionEnabled = true
        backgroundColor = Theme.Colors.reallyWhite.color
        
        //termIcon
        addSubview(termIcon)
        addConstraintsWithFormat(format: "H:[v0(\(frame.size.width / 1.4))]", views: termIcon)
        addConstraintsWithFormat(format: "V:|[v0(\(frame.size.height / 1.4))]", views: termIcon)
        addConstraint(NSLayoutConstraint(item: termIcon, attribute: .centerX, relatedBy: .equal, toItem: self, attribute: .centerX, multiplier: 1, constant: 0))

        //lineView
        addSubview(lineView)
        addConstraintsWithFormat(format: "H:[v0(\(termIcon.bounds.size.width))]", views: lineView)
        addConstraintsWithFormat(format: "V:[v1]-5-[v0(1)]", views: lineView, termIcon)
        addConstraint(NSLayoutConstraint(item: lineView, attribute: .centerX, relatedBy: .equal, toItem: self, attribute: .centerX, multiplier: 1, constant: 0))
        
        addGestures()
    }
    
    func reset() {
        termIcon.image = nil
    }
    
    
    //MARK: Actions
    
    func addGestures() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleCellTapped))
        addGestureRecognizer(tapGesture)
    }
    
    @objc func handleCellTapped() {
        if iconTapped != nil {
            iconTapped!()
        }
    }
    
    func selectTerm(_ select: Bool) {
        guard imageName != nil else {
            return
        }
        
        let renderingMode: UIImageRenderingMode = .alwaysOriginal
        let size = Constants.Strings.foodItemSizeSmall
        let sizedName = size + imageName!
        
        termIcon.image = UIImage(named: sizedName)?.withRenderingMode(renderingMode)
        if select {
            termIcon.alpha = 1.0
            lineView.isHidden = false
        } else {
            termIcon.alpha = 0.5
            lineView.isHidden = true
        }
    }
}
