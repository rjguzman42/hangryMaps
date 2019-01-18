//
//  NoDataView.swift
//  Hangry Maps
//
//  Created by Roberto Guzman on 7/24/18.
//  Copyright © 2018 Fortytwo Sports. All rights reserved.
//

import Foundation
import UIKit

class NoDataView: UIView {
    
    let mainImageView: UIImageView = {
        let view = UIImageView(frame: CGRect(x: 0, y: 0, width: Constants.Sizes.noDataImage.width, height: Constants.Sizes.noDataImage.height))
        view.contentMode = .scaleAspectFit
        return view
    }()
    let title: UILabel = {
        let label = UILabel()
        label.text = ""
        label.textColor = Theme.Colors.primaryText.color
        label.font = Theme.Fonts.primaryDemiBold.font
        label.lineBreakMode = NSLineBreakMode.byTruncatingTail
        label.numberOfLines = 0
        label.textAlignment = .center
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupSubViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    //MARK UI
    
    func setupSubViews() {
        
        //mainImageView
        addSubview(mainImageView)
        addConstraintsWithFormat(format: "H:|[v0]|", views: mainImageView)
        addConstraintsWithFormat(format: "V:|[v0]", views: mainImageView)

        //title
        addSubview(title)
        addConstraintsWithFormat(format: "H:|-10-[v0]-10-|", views: title)
        addConstraintsWithFormat(format: "V:[v1]-5-[v0]|", views: title, mainImageView)
    }
}
