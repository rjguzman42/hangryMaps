//
//  LoadingCollectionCell.swift
//  chefspot
//
//  Created by Roberto Guzman on 7/16/18.
//  Copyright © 2018 Fortytwo Sports. All rights reserved.
//

import Foundation
import UIKit

class LoadingCollectionCell: UICollectionViewCell {
    
    let loadingControl: UIActivityIndicatorView = {
        let view = UIActivityIndicatorView()
        view.color = UIColor.lightGray
        view.transform = CGAffineTransform(scaleX: 0.9, y: 0.9)
        view.isHidden = true
        return view
    }()
    let loadImageView: UIImageView = {
        let view = UIImageView()
        view.backgroundColor = Theme.Colors.reallyWhite.color
        view.clipsToBounds = true
        view.isUserInteractionEnabled = true
        view.image = UIImage(named: "ic_load")
        view.contentMode = .scaleAspectFill
        return view
    }()
    let title: UILabel = {
        let label = UILabel()
        label.text = ""
        label.textColor = Theme.Colors.primaryText.color
        label.font = Theme.Fonts.primaryDemiBold.font
        label.lineBreakMode = NSLineBreakMode.byTruncatingTail
        label.numberOfLines = 2
        label.textAlignment = .center
        return label
    }()
    var cellTapped: (() -> Void)?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
        currentlyLoading(false)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("Init(coder:) has not been implemented")
    }
    
    
    //MARK: UI
    
    func setupViews() {
        
        //loadImageView
        addSubview(loadImageView)
        addConstraintsWithFormat(format: "H:[v0(\(frame.size.height / 3))]", views: loadImageView)
        addConstraintsWithFormat(format: "V:[v0(\(frame.size.height / 3))]", views: loadImageView)
        addConstraint(NSLayoutConstraint(item: loadImageView, attribute: .centerY, relatedBy: .equal, toItem: self, attribute: .centerY, multiplier: 1, constant: -40))
        addConstraint(NSLayoutConstraint(item: loadImageView, attribute: .centerX, relatedBy: .equal, toItem: self, attribute: .centerX, multiplier: 1, constant: 0))
        
        //title
        addSubview(title)
        addConstraintsWithFormat(format: "H:|[v0]|", views: title)
        addConstraintsWithFormat(format: "V:[v1]-1-[v0]", views: title, loadImageView)
        addConstraint(NSLayoutConstraint(item: title, attribute: .centerX, relatedBy: .equal, toItem: self, attribute: .centerX, multiplier: 1, constant: 0))
        
        //loadingControl
        addSubview(loadingControl)
        addConstraintsWithFormat(format: "H:[v0(\(loadImageView.frame.size.width / 2))]", views: loadingControl)
        addConstraintsWithFormat(format: "V:[v1]-10-[v0(\(loadImageView.frame.size.width / 2))]", views: loadingControl, title)
        addConstraint(NSLayoutConstraint(item: loadingControl, attribute: .centerX, relatedBy: .equal, toItem: self, attribute: .centerX, multiplier: 1, constant: 0))
        
        addGestures()
    }
    
    func currentlyLoading(_ enabled: Bool) {
        loadingControl.isHidden = !enabled
        if enabled {
            loadingControl.startAnimating()
        } else {
            loadingControl.stopAnimating()
        }
    }
    
    
    //MARK Actions
    
    func addGestures() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTapGesture))
        addGestureRecognizer(tapGesture)
    }
    
    @objc func handleTapGesture() {
        if cellTapped != nil {
            cellTapped!()
            currentlyLoading(true)
        }
    }
}
