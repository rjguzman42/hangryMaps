//
//  SettingItem.swift
//  chefspot
//
//  Created by Roberto Guzman on 7/11/18.
//  Copyright © 2018 Fortytwo Sports. All rights reserved.
//

import Foundation

struct SettingItem {
    enum SettingCategory {
        case sideView
        case account
        
        func toString() -> String {
            switch self {
            case .sideView:
                return "SideView"
            case .account:
                return "Account"
            }
        }
    }
    
    let category: SettingCategory
    let title: String?
    let imageName: String?
    let placeholder: String?
    let userInputText: String?
}
