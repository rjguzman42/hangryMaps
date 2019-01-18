//
//  Theme.swift
//  chefspot
//
//  Created by Roberto Guzman on 7/6/18.
//  Copyright © 2018 Fortytwo Sports. All rights reserved.
//

import Foundation
import UIKit

struct Theme {
    //MARK: Colors
    
    enum Colors {
        case background
        case backgroundBlack
        case primaryPurple
        case darkRoseRed
        case primaryText
        case primaryTextLight
        case navBar
        case toolBar
        case hintGray
        case reallyWhite
        case secondaryYellow
        case dropShadow
        case dropShadowDark
        case facebookBlue
        case buttonTint
        
        var color: UIColor {
            switch self {
            case .background: return UIColor(red: 255/255, green: 255/255, blue: 255/255, alpha: 1.0)
            case .backgroundBlack: return  UIColor(red: 021/255, green: 021/255, blue: 021/255, alpha: 1.0)
            case .primaryPurple: return UIColor(red: 96/255, green: 84/255, blue: 247/255, alpha: 1.0)
            case .darkRoseRed: return UIColor(red: 201/255, green: 034/255, blue: 040/255, alpha: 1.0)
            case .primaryText: return UIColor(red: 033/255, green: 033/255, blue: 033/255, alpha: 1.0)
            case .primaryTextLight: return UIColor(red: 084/255, green: 085/255, blue: 084/255, alpha: 1.0)
            case .navBar: return UIColor(red: 255/255, green: 255/255, blue: 255/255, alpha: 1.0)
            case .toolBar: return UIColor(red: 255/255, green: 255/255, blue: 255/255, alpha: 1.0)
            case .hintGray: return UIColor(red: 196/255, green: 196/255, blue: 196/255, alpha: 1.0)
            case .reallyWhite: return UIColor(red: 255/255, green: 255/255, blue: 255/255, alpha: 1.0)
            case .secondaryYellow: return UIColor(red: 236/255, green: 185/255, blue: 56/255, alpha: 1.0)
            case .dropShadow: return UIColor(red: 196/255, green: 196/255, blue: 196/255, alpha: 1.0)
            case .dropShadowDark: return UIColor(red: 150/255, green: 150/255, blue: 150/255, alpha: 1.0)
            case .facebookBlue: return UIColor(red: 59/255, green: 89/255, blue: 152/255, alpha: 1.0)
            case .buttonTint: return  UIColor(red: 021/255, green: 021/255, blue: 021/255, alpha: 1.0)
            }
        }
    }
    
    
    //MARK: Fonts
    
    enum Fonts {
        case primary
        case primarySmall
        case primaryMedium
        case primaryLarge
        case primaryDemiBold
        case primaryLargeBold
        case primarySuperLargeBold
        case titleBold
        case menuBarTitle
        
        var font: UIFont {
            switch self {
            case .primary: return UIFont(name: "AvenirNext-Regular", size: 16)!
            case .primarySmall: return UIFont(name: "AvenirNext-Regular", size: 12)!
            case .primaryMedium: return UIFont(name: "AvenirNext-Medium", size: 16)!
            case .primaryLarge: return UIFont(name: "AvenirNext-Regular", size: 20)!
            case .primaryDemiBold: return UIFont(name: "AvenirNext-DemiBold", size: 16)!
            case .primaryLargeBold: return UIFont(name: "AvenirNext-Bold", size: 20)!
            case .primarySuperLargeBold: return UIFont(name: "AvenirNext-Bold", size: 30)!
            case .titleBold: return UIFont(name: "AvenirNext-Bold", size: 18)!
            case .menuBarTitle: return UIFont(name: "AvenirNext-Bold", size: 18)!
            }
        }
    }
}
