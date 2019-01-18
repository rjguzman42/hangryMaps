//
//  SearchTermType.swift
//  chefspot
//
//  Created by Roberto Guzman on 7/18/18.
//  Copyright © 2018 Fortytwo Sports. All rights reserved.
//

import Foundation
import UIKit

enum SearchTermType: String {
    case saved //user saved search terms are stored locally and shown in menuBar
    case temp //temporary search terms are terms that are not stored locally, but are searched while using the app. They show up on the menubar like 'User Search Terms', but once the app is closed, they are moved to 'Recent Search Terms'
    case recent //recent search terms are shown as options under the search bar
    case popular //popular terms are created by the app, but we allow the user to delete the terms
    case favorite //only one favorite search term exists. we preload it when user enters app for first time
}
