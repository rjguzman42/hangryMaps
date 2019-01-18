//
//  PlaceDescriptionCell.swift
//  chefspot
//
//  Created by Roberto Guzman on 7/12/18.
//  Copyright © 2018 Fortytwo Sports. All rights reserved.
//

import Foundation
import UIKit

class PlaceDescriptionCell: UITableViewCell {

    let descriptionLabel: UILabel = {
        let label = UILabel()
        label.text = ""
        label.font = Theme.Fonts.primary.font
        label.textColor = Theme.Colors.primaryText.color
        label.numberOfLines = 0
        label.contentMode = .left
        label.lineBreakMode = .byTruncatingTail
        label.textAlignment = .left
        label.isUserInteractionEnabled = false
        return label
    }()
    var labelTapped: (() -> Void)?
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupSubViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        reset()
    }
    
    deinit {
        DebugLog.DLog("Setting Cell Deinited")
    }
    
    func reset() {
        descriptionLabel.text = ""
        descriptionLabel.isUserInteractionEnabled = false
    }
    
    
    //MARK: UI
    
    func setupSubViews() {
    
        //descriptionLabel
        addSubview(descriptionLabel)
        addConstraintsWithFormat(format: "H:|-10-[v0]-10-|", views: descriptionLabel)
        addConstraintsWithFormat(format: "V:|-10-[v0]-10-|", views: descriptionLabel)
        
        addGestures()
    }
    
    
    //MARK: Actions
    
    func addGestures() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleLabelTapped))
        descriptionLabel.addGestureRecognizer(tapGesture)
    }
    
    @objc func handleLabelTapped() {
        if labelTapped != nil {
            labelTapped!()
        }
    }
}
