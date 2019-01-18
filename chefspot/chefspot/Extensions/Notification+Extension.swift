//
//  Notification+Extension.swift
//  chefspot
//
//  Created by Roberto Guzman on 7/6/18.
//  Copyright © 2018 Fortytwo Sports. All rights reserved.
//

import Foundation

extension Notification.Name {
    static let searchTerm = Notification.Name("searchTerm")
    static let userUpdated = Notification.Name("userUpdated")
    static let savedFoodItemsUpdated = Notification.Name("savedFoodItemsUpdated")
    static let favoritePlacesUpdated = Notification.Name("favoritePlacesUpdated")
}
