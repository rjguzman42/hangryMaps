//
//  PersistRouter.swift
//  chefspot
//
//  Created by Roberto Guzman on 7/6/18.
//  Copyright © 2018 Fortytwo Sports. All rights reserved.
//

import Foundation

struct PersistRouter {
    
    
    //MARK: App
    
    static let launchCount = "launchCount"
    static let firstLaunch = "firstLaunch"
    static let mapLatitude = "mapLatitude"
    static let mapLongitude = "mapLongitude"
    static let mapLatitudeSpan = "mapLatitudeSpan"
    static let mapLongitudeSpan = "mapLongitudeSpan"
    static let savedSearchTerms = "savedSearchTerms"
    static let recentSearchTerms = "recentSearchTerms"
    static let popularSearchTerms = "popularSearchTerms"
    
    //MARK: SSKeychain
    
    static let keychainAppService = "authClient"
    
    
    //MARK: User
    
    static let authToken = "authToken"
    
}
