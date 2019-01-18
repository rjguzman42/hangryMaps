//
//  FlatButton.swift
//  chefspot
//
//  Created by Roberto Guzman on 7/11/18.
//  Copyright © 2018 Fortytwo Sports. All rights reserved.
//

import Foundation
import UIKit

class FlatButton: UIButton {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setDefaultAttributes()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func setDefaultAttributes() {
        clipsToBounds = true
        layer.cornerRadius = frame.size.width / 10
        backgroundColor = Theme.Colors.primaryPurple.color
        setTitleColor(Theme.Colors.reallyWhite.color, for: .normal)
    }
    
    func setLargeTheme() {
        clipsToBounds = true
        layer.cornerRadius = frame.size.width / 18
        backgroundColor = Theme.Colors.primaryPurple.color
        setTitleColor(Theme.Colors.reallyWhite.color, for: .normal)
    }
    
    func setBoxedTheme() {
        layer.cornerRadius = frame.size.width / 50
    }
}
