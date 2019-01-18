//
//  Constants.swift
//  chefspot
//
//  Created by Roberto Guzman on 7/6/18.
//  Copyright © 2018 Fortytwo Sports. All rights reserved.
//

import Foundation

struct Constants {
    
    
    //MARK: Strings
    
    struct Strings {
        static let appName = "Hangry Maps"
        static let mapStyleLight = "mapStyleLight"
        static let mapStyleNight = "mapStyleNight"
        static let defaultUserName = "HangryMe"
        static let generalInputCharactersNotAllowed = "[]+\\&~#^|$%*!@/()-'\":;,?{}=!$^';,?×÷<>{}€£¥₩%~`¤♡♥|《》¡¿°•○●□■◇◆♧♣▲▼▶◀↑↓←→☆★▪:-);-):-:-(:'(:"
        static let nameInputCharactersNotAllowed = " []+\\&~#^|$%*!@/()-'\":;,?{}=!$^';,?×÷<>{}€£¥₩%~`¤♡♥|《》¡¿°•○●□■◇◆♧♣▲▼▶◀↑↓←→☆★▪:-);-):-:-(:'(:"
        static let searchAgain = NSLocalizedString("Search this area", comment: "Button title to search area")
        static let visitHistory = NSLocalizedString("Visit history", comment: "setting title to view your visit history")
        static let favorites = NSLocalizedString("Favorites", comment: "setting title to view favorites")
        static let settings = NSLocalizedString("Settings", comment: "setting title to view settings")
        static let signUpToCook = NSLocalizedString("Sign up to cook", comment: "setting title to sign up to cook")
        static let chooseImage = NSLocalizedString("Choose Image", comment:"Prompt user to select an image")
        static let camera = NSLocalizedString("Camera", comment:"")
        static let gallery = NSLocalizedString("Gallery", comment:"")
        static let cancel = NSLocalizedString("Cancel", comment:"")
        static let inviteFriendsMessage = NSLocalizedString("Hey, check out the \(appName) app - appstore.com/hangryMaps", comment:"Invite friends message")
        static let logout = NSLocalizedString("Log Out", comment: "Log the user out")
        static let save = NSLocalizedString("Save", comment: "Save data")
        static let rateApp = NSLocalizedString("Rate \(appName)", comment: "Rate the app")
        static let shareApp = NSLocalizedString("Share", comment: "Share the app")
        static let legal = NSLocalizedString("Legal", comment: "View legal terms for app")
        static let userNameHint = NSLocalizedString("Username", comment: "hint for entering user name")
        static let eatNow = NSLocalizedString("Eat Now", comment: "button title to eat at this place")
        static let getStarted = NSLocalizedString("Get Started", comment: "get started button title")
        static let next = NSLocalizedString("Next", comment: "next button title")
        static let done = NSLocalizedString("Done", comment: "done button title")
        static let add = NSLocalizedString("Add", comment: "add button title")
        static let welcomeMessage = NSLocalizedString("Let's get started!\nPick your favorite foods", comment: "Welcome message describing app purpose.")
        static let loadWithFacebook = NSLocalizedString("load with Facebook", comment: "description to load profile info with facebook")
        static let addTermHint = NSLocalizedString("Name", comment: "hint for adding a food item")
        static let tapToRemoveHint = NSLocalizedString("Tap a term to remove", comment: "hint telling user to tap word to remove")
        static let removedTerm = NSLocalizedString("Removed ", comment: "hint showing term removed")
        static let contact = NSLocalizedString("Contact", comment: "Contact title")
        static let reviews = NSLocalizedString("Reviews", comment: "Reviews title")
        static let call = NSLocalizedString("Call", comment: "call")
        static let site = NSLocalizedString("Visit", comment: "site")
        static let callPlace = NSLocalizedString("Call Place", comment: "user prompt to call place")
        static let visitWebsite = NSLocalizedString("Visit Website", comment: "user prompt to enter location site")
        static let search = NSLocalizedString("Search", comment: "Search page title")
        static let recentSearches = NSLocalizedString("Recent", comment: "recent searches title")
        static let popularSearches = NSLocalizedString("Popular", comment: "popular searches title")
        static let delete = NSLocalizedString("Delete", comment: "delete an item")
        static let favoritePlaces = NSLocalizedString("Favorite places", comment: "title for favorite places")
        static let savedFoodItems = NSLocalizedString("Saved food items", comment: "title for saved food items")
        static let addItem = NSLocalizedString("Add Item", comment: "title for adding food items page")
        static let myItems = NSLocalizedString("My Items", comment: "title for my food items")
        static let noDataForPlace = NSLocalizedString("No places nearby for", comment: "no places nearby")
        static let appearance = NSLocalizedString("Appearance", comment: "appearance")
        static let foodItemSizeSmall = "small_"
        static let foodItemSizeLarge = "large_"
        static let noFavoritePlaces = NSLocalizedString("No favorite places \n Tap the heart icon on a place to add as favorite", comment: "no favorite places description")
        static let noVisitedPlaces = NSLocalizedString("You haven't visited any places on \(appName)", comment: "user hasn't visited any places to eat")
        static let skip = NSLocalizedString("Skip", comment: "skip")
    }
    
    
    //MARK: Alerts
    
    struct Alerts {
        static let dismissAlert = NSLocalizedString("Dismiss", comment:"")
        static let generalServerErrorTitle = NSLocalizedString("Oops", comment: "generalServerError title")
        static let generalServerErrorMessage = NSLocalizedString("Looks like something is wrong connecting to the server. Please try again", comment: "generalServerError message")
        static let generalPersistencyErrorTitle = NSLocalizedString("Oops", comment: "generalPersistencyError title")
        static let generalPersistencyErrorMessage = NSLocalizedString("Looks like something is wrong retrieving some information. Please try again", comment: "generalPersistencyError message")
        static let notEnoughSavedSearchesTitle = NSLocalizedString("Just a little more", comment: "title for not having the required saved searches")
        static let notEnoughSavedSearchesDescription = NSLocalizedString("Select at least 3 food items", comment: "dscription for not having enough saved search items")
        static let enterUserName = NSLocalizedString("Please enter your username", comment: "alert for missing username")
        static let enterProfileImage = NSLocalizedString("Please enter a profile image", comment: "alert for missing profile image")
        static let failedToOpenMapsTitle = NSLocalizedString("No maps app on your phone", comment: "title for no maps app on phone")
        static let failedToOpenMapsMessage = NSLocalizedString("Download Google Maps or Apple Maps to get directions", comment: "message for no maps app on phone")
        static let userUpdateFailedTitle = NSLocalizedString("Oops", comment: "title for error while updating user")
        static let userUpdateFailedMessage = NSLocalizedString("Something went wrong updating your info. Please try again.", comment: "message for error while updating user")
        static let saveTermNotUniqueTitle = NSLocalizedString("Oops", comment: "save term already exists title")
        static let saveTermNotUniqueMessage = NSLocalizedString("You already have a food item by this name", comment: "save term already exists message")
        static let logOutTitle = NSLocalizedString("Are you sure?", comment: "title for logging out informing user that data will be deleted")
        static let logOutMessage = NSLocalizedString("All account data will be deleted if you log out.", comment: "message for logging out informing user that data will be deleted")
        static let removeTermTitle = NSLocalizedString("Remove ", comment: "title for removing term")
        static let yes = NSLocalizedString("Yes", comment: "approve of a message")
    }
    
    
    //MARK: Cells
    
    struct Cells {
        static let placeCellId = "placeCellId"
        static let menuCellId = "menuCellId"
        static let settingCellId = "settingCellId"
        static let starCellId = "starCellId"
        static let placeDescriptionCellId = "placeDescriptionCellId"
        static let reviewCellId = "reviewCellId"
        static let searchTermCellId = "searchTermCellId"
        static let loadingCollectionCellId = "loadingCollectionCellId"
        static let addSearchTermViewId = "addSearchTermViewId"
        static let placeTableCellId = "placeTableCellId"
        static let termIconCellId = "termIconCellId"
    }
    
    
    //MARK: API
    
    struct APIPaths {
        static let hangryMaps = ""
        static let googlePlaces = "https://maps.googleapis.com/maps/api/place"
    }
    
    struct APIResponse {
        
    }
    
    struct APIKeys {
        static let hangryMapsRestAPIKey = ""
        static let googlePlacesRestAPIKey = "key"
        static let maxwidth = "maxwidth"
        static let photoreference = "photoreference"
    }
    
    struct APIValues {
        static let hangryMapsRestAPIKey = ""
        static let googlePlacesRestAPIKey = ""
    }
    
    struct APIMessage {
        static let generalError = "general error with server communication"
        static let persistencyError = "general error with local communication"
    }
    
    
    //MARK: Sizes
    
    struct Sizes {
        
        //MARK: Corner Radius
        static let squareCornerRadius: CGFloat = Constants.Sizes.placeCell.width / 20
        static let placeMarkerCornerRadius: CGFloat = Constants.Sizes.placeMarkerView.width / 25
        
        
        //MARK: Height
        static let flatButtonHeight: CGFloat = UIScreen.main.bounds.size.height / 14
        static var mapButtonViewHeight: CGFloat! {
            var size = UIScreen.main.bounds.size.width / 10
            if UIDevice.current.orientation.isLandscape {
                size = UIScreen.main.bounds.size.height / 7
            }
            return size
        }
        static let singleLineLabelHeight: CGFloat = 25
        static let userInputHeight: CGFloat = 45
        static let statusBarHeight: CGFloat = UIApplication.shared.statusBarFrame.height
        static let navigationBarHeight: CGFloat = 44
        
        
        //MARK: CGSize
        static let foodFilterView = CGSize(width: UIScreen.main.bounds.size.width, height: UIScreen.main.bounds.size.height)
        static let foodFilterViewPreview = CGSize(width: Constants.Sizes.foodFilterView.width, height: (UIScreen.main.bounds.size.height - ((UIScreen.main.bounds.size.height / 2) + 100)))
        static let foodFilterViewMinimized = CGSize(width: Constants.Sizes.foodFilterView.width, height: Constants.Sizes.menuBar.height + Constants.Sizes.horizontalLineView.height)
        static let menuBar = CGSize(width: UIScreen.main.bounds.size.width, height: 40)
        static let horizontalLineView = CGSize(width: 25, height: 25)
        static let placeScrollView = CGSize(width: UIScreen.main.bounds.size.width, height: Constants.Sizes.foodFilterViewPreview.height - Constants.Sizes.menuBar.height - Constants.Sizes.horizontalLineView.height)
        static let placeCell = CGSize(width: Constants.Sizes.placeScrollView.height * 0.8, height: Constants.Sizes.placeScrollView.height)
        static let sideView = CGSize(width: UIScreen.main.bounds.size.width - (UIScreen.main.bounds.size.width / 3), height: UIScreen.main.bounds.size.height)
        static let profileImageLarge = CGSize(width: UIScreen.main.bounds.size.width / 4, height: UIScreen.main.bounds.size.width / 4)
        static let profileImageSmall = CGSize(width: Constants.Sizes.profileImageLarge.width / 2, height: Constants.Sizes.profileImageLarge.height / 2)
        static let cameraImage = CGSize(width: Constants.Sizes.profileImageLarge.width / 2, height: Constants.Sizes.profileImageLarge.height / 2)
        static let userInfoView = CGSize(width: UIScreen.main.bounds.size.width, height: UIScreen.main.bounds.size.height / 4)
        static let userEditView = CGSize(width: UIScreen.main.bounds.size.width, height: UIScreen.main.bounds.size.height / 3.5)
        static let lineView = CGSize(width: UIScreen.main.bounds.size.width, height: 0.7)
        static let settingIcon = CGSize(width: 24, height: 24)
        static let placeHeaderView = CGSize(width: UIScreen.main.bounds.size.width, height: UIScreen.main.bounds.size.height / 2.5)
        static let orderFooterView = CGSize(width: UIScreen.main.bounds.size.width, height: UIScreen.main.bounds.size.height / 11)
        static let eatNowButton = CGSize(width: Constants.Sizes.orderFooterView.width / 3.5, height: Constants.Sizes.orderFooterView.height - 20)
        static let placePriceStarView = CGSize(width: Constants.Sizes.placeCell.width, height: Constants.Sizes.starsView.height + Constants.Sizes.singleLineLabelHeight)
        static let starsView = CGSize(width: Constants.Sizes.placeCell.width, height: Constants.Sizes.singleLineLabelHeight - 15)
        static let starCell = CGSize(width: Constants.Sizes.starsView.height, height: Constants.Sizes.starsView.height)
        static let placeTableImageView = CGSize(width: ((UIScreen.main.bounds.size.width / 5) * 0.8), height: UIScreen.main.bounds.size.width / 5)
        static let termAppearanceView = CGSize(width: UIScreen.main.bounds.size.width, height: singleLineLabelHeight + termAppearanceCell.height)
        static let termAppearanceCell = CGSize(width: UIScreen.main.bounds.size.width / 8, height: (UIScreen.main.bounds.size.width / 8))
        static let termIconCell = CGSize(width: UIScreen.main.bounds.size.width / 8, height: UIScreen.main.bounds.size.width / 8)
        static let termIconSmall = CGSize(width: ((UIScreen.main.bounds.size.width / 3) / 3), height: ((UIScreen.main.bounds.size.width / 3) / 3))
        static let noDataImage = CGSize(width: UIScreen.main.bounds.size.width / 2, height: UIScreen.main.bounds.size.width / 2)
        static let titleHeaderView = CGSize(width: UIScreen.main.bounds.size.width, height: Theme.Fonts.primaryLargeBold.font.pointSize + 10)
        static let addSearchTermView = CGSize(width: UIScreen.main.bounds.size.width, height: ((Constants.Sizes.titleHeaderView.height * 2) + Constants.Sizes.termAppearanceView.height + Constants.Sizes.userInputHeight +  Constants.Sizes.singleLineLabelHeight + 60))
        static let placeMarkerView = CGSize(width: 200, height: 50)
        static let placeMarkerSuperView = CGSize(width: Constants.Sizes.placeMarkerView.width + 20, height: Constants.Sizes.placeMarkerView.height + 20)
        static let markerImageView = CGSize(width: (Constants.Sizes.placeMarkerView.height - 4) * 0.8, height: Constants.Sizes.placeMarkerView.height - 4)
    }
    
}
