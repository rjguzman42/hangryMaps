//
//  DataManager.swift
//  chefspot
//
//  Created by Roberto Guzman on 7/10/18.
//  Copyright © 2018 Fortytwo Sports. All rights reserved.
//

import Foundation

class DataManager {
    
    static let sharedInstance = DataManager()
    private let libraryAPI = LibraryAPI.sharedInstance
    private let utility = AppUtility.sharedInstance

    var localPlaces: [String : [GooglePlace]] = [:]
    var favoritePlaces: [GooglePlace] = []
    var visitedPlaces: [GooglePlace] = []
    var savedSearchTerms: [SearchTerm] = []
    var recentSearchTerms: [SearchTerm] = []
    var popularSearchTerms: [SearchTerm] = []
    var availableTermIcons: [String] = ["ic_utensil", "ic_star", "ic_coffee",  "ic_hamburger", "ic_ice_cream", "ic_pancakes", "ic_tacos", "ic_pizza", "ic_smoothie"]
    var favoriteSearchTerm: SearchTerm?
    
    private init() {
        getFavoriteSearchTerm()
        getFavoritePlaces()
        getSearchTerms()
    }
    
    
    //MARK: Favorites
    func getFavoriteSearchTerm() {
        libraryAPI.getSearchTerm(name: Constants.Strings.favorites, type: SearchTermType.favorite,completion: {[weak self] result in
            if self != nil {
                switch result {
                case .success(let term):
                    self?.favoriteSearchTerm = term
                    break
                default:
                    break
                }
            }
        })
    }
    
    func getFavoritePlaces() {
        libraryAPI.getFavoritePlaces(completion: {[weak self] result in
            if self != nil {
                switch result {
                case .success(let localPlaces):
                    self?.getGooglePlacesFromFavorites(localPlaces)
                    break
                case .clientError(_, let errMsg):
                    DebugLog.DLog(errMsg)
                    self?.utility.handleAPIResultError(result)
                    break
                default:
                    self?.utility.handleAPIResultError(result)
                    break
                }
            }
        })
    }
    
    func getGooglePlacesFromFavorites(_ locPlaces: [LocalPlace]) {
        let googlePlaces = convertLocalPlacesToGooglePlaces(locPlaces, isFavorite: true)
        favoritePlaces = googlePlaces
        localPlaces[Constants.Strings.favorites] = favoritePlaces
    }
    
    func convertLocalPlacesToGooglePlaces(_ locPlaces: [LocalPlace], isFavorite: Bool) -> [GooglePlace] {
        var googlePlaces: [GooglePlace] = []
        for place in locPlaces {
            var googlePlace = GooglePlace()
            if let formattedAddress = place.formattedAddress {
                googlePlace.formattedAddress = formattedAddress
            }
            if let formattedPhoneNumber = place.formattedPhoneNumber {
                googlePlace.formattedPhoneNumber = formattedPhoneNumber
            }
            if let icon = place.icon {
                googlePlace.icon = icon
            }
            if let id = place.id {
                googlePlace.id = id
            }
            if let name = place.name {
                googlePlace.name = name
            }
            if let placeId = place.placeId {
                googlePlace.placeId = placeId
            }
            googlePlace.priceLevel = place.priceLevel
            googlePlace.rating = place.rating
            if let reference = place.reference {
                googlePlace.reference = reference
            }
            if let types = place.types as? [String] {
                googlePlace.types = types
            }
            if let vicinity = place.vicinity {
                googlePlace.vicinity = vicinity
            }
            if let website = place.website {
                googlePlace.website = website
            }
            if let location = place.location {
                googlePlace.geometry = PlaceGeometry(location: PlaceLocation(lat: location.latitude, lng: location.longitude))
            }
            
            googlePlace.isFavorite = isFavorite
            
            //photos
            if let photos = place.photos?.allObjects as? [LocalPhoto] {
                var googlePlacePhotos: [PlacePhoto] = []
                
                //get main photo data
                if let firstPhotoData = photos.first?.photoData {
                    googlePlace.photoData = firstPhotoData
                }
                
                for photo in photos {
                    googlePlacePhotos.append(PlacePhoto(height: nil, htmlAttributions: nil, photoReference: photo.photoReference, width: nil))
                }
                googlePlace.photos = googlePlacePhotos
            }
            
            //reviews
            if let reviews = place.reviews?.allObjects as? [LocalReview] {
                var googlePlaceReviews: [PlaceReview] = []
                
                for review in reviews {
                    googlePlaceReviews.append(PlaceReview(authorName: review.authorName, authorUrl: review.authorUrl, profilePhotoUrl: review.profilePhotoUrl, rating: review.rating, relativeTimeDescription: review.relativeTimeDescription, text: review.text))
                }
                googlePlace.reviews = googlePlaceReviews
            }
            
            googlePlaces.append(googlePlace)
        }
        return googlePlaces
    }
    
    func removeFavoritePlace(_ place: GooglePlace, searchTermName: String = "") {
        //remove from coreData
        libraryAPI.removeFavoritePlace(place, completion: {[weak self] in
            if self != nil {
                //remove from self.favoritePlaces
                if let index = self?.favoritePlaces.index(where: {$0.placeId == place.placeId}) {
                    self?.favoritePlaces.remove(at: index)
                }
                self?.updateAsFavorite(place, searchTermName: searchTermName, add: false)
            }
        })
    }
    
    func saveFavoritePlace(_ place: GooglePlace, searchTermName: String = "") {
        //add to coreData
        libraryAPI.saveAsFavoritePlace(place, completion: {[weak self] localPlace in
            if self != nil {
                self?.favoritePlaces.append(place)
                self?.updateAsFavorite(place, searchTermName: searchTermName, add: true)
            }
        })
    }
    
    func updateAsFavorite(_ place: GooglePlace, searchTermName: String = "", add: Bool) {
        if let index = localPlaces[searchTermName]?.index(where: {$0.placeId == place.placeId}) {
            localPlaces[searchTermName]?[index].isFavorite = add
            NotificationCenter.default.post(name: .favoritePlacesUpdated, object: self, userInfo: ["googlePlace" : place])
        }
    }
    
    func saveVisitedPlace(_ place: GooglePlace) {
        //add to coreData
        libraryAPI.saveAsVisitedPlace(place, completion: {[weak self] localPlace in
            if self != nil {
                self?.visitedPlaces.append(place)
            }
        })
    }
    
    func getVisitedPlaces(completion: @escaping () -> Void) {
        libraryAPI.getVisitedPlaces(completion: {[weak self] result in
            if self != nil {
                switch result {
                case .success(let localPlaces):
                    self?.getGooglePlacesFromVisited(localPlaces)
                    completion()
                    break
                case .clientError(_, let errMsg):
                    DebugLog.DLog(errMsg)
                    self?.utility.handleAPIResultError(result)
                    break
                default:
                    self?.utility.handleAPIResultError(result)
                    break
                }
            }
        })
    }
    
    func getGooglePlacesFromVisited(_ locPlaces: [LocalPlace]) {
        let googlePlaces = convertLocalPlacesToGooglePlaces(locPlaces, isFavorite: false)
         visitedPlaces = googlePlaces
    }
    

    //MARK: Google Places
    
    func nearbySearch(location: String, radius: String, keyword: String, completion: @escaping () -> Void) {
        DispatchQueue.global(qos: .background).async {
            self.libraryAPI.nearbysearch(location, radius: radius, keyword: keyword, types: "food,bakery,bar,cafe,restaurant,supermarket", completion: {[weak self] result in
                DebugLog.DLog("Result: \(result)")
                DispatchQueue.main.async {
                    if self != nil {
                        switch result {
                        case .success(let response):
                            DebugLog.DLog("Successfull Response: \(response)")
                            if let results = response.results {
                                self?.localPlaces[keyword] = results
                            }
                            completion()
                            break
                        case .clientError(_, let errMsg):
                            DebugLog.DLog(errMsg)
                            self?.utility.handleAPIResultError(result)
                            break
                        default:
                            self?.utility.handleAPIResultError(result)
                            break
                        }
                    }
                }
            })
        }
    }
    
    func getPlaceDetails(placeid: String, completion: @escaping (GooglePlace) -> Void) {
        DispatchQueue.global(qos: .background).async {
            self.libraryAPI.getPlaceDetails(placeid, fields: "name,rating,formatted_phone_number,photo,url,opening_hours,website,price_level,rating,review,geometry,place_id", completion: {[weak self] result in
                DebugLog.DLog("Result: \(result)")
                DispatchQueue.main.async {
                    if self != nil {
                        switch result {
                        case .success(let response):
                            DebugLog.DLog("Successfull Response: \(response)")
                            if let result = response.result {
                                completion(result)
                            }
                            break
                        case .clientError(_, let errMsg):
                            DebugLog.DLog(errMsg)
                            self?.utility.handleAPIResultError(result)
                            break
                        default:
                            self?.utility.handleAPIResultError(result)
                            break
                        }
                    }
                }
            })
        }
    }
    
    func resetLocalPlaces(removeFavorites: Bool) {
        guard !removeFavorites else {
            localPlaces.removeAll(keepingCapacity: false)
            return
        }
        
        //remove all except favorites
        for key in localPlaces.keys {
            if key != Constants.Strings.favorites {
                localPlaces[key] = nil
            }
        }
    }


    //MARK: Search Terms
    
    func getSearchTerms(type: SearchTermType? = nil) {
        libraryAPI.getSearchTerms(type: type, completion: {[weak self] result in
            if self != nil {
                switch result {
                case .success(let terms):
                    if type == nil {
                        self?.savedSearchTerms.removeAll(keepingCapacity: false)
                        self?.popularSearchTerms.removeAll(keepingCapacity: false)
                        self?.recentSearchTerms.removeAll(keepingCapacity: false)
                        for term in terms {
                            self?.updateTermToArray(term, add: true)
                        }
                    } else {
                        switch type! {
                        case SearchTermType.saved:
                            self?.savedSearchTerms = terms
                            break
                        case SearchTermType.temp:
                            self?.savedSearchTerms.append(contentsOf: terms)
                            break
                        case SearchTermType.recent:
                            self?.recentSearchTerms = terms
                            break
                        case SearchTermType.popular:
                            self?.popularSearchTerms = terms
                            break
                        default:
                            break
                        }
                    }
                    break
                default:
                    self?.utility.handleAPIResultError(result)
                    break
                }
            }
        })
    }
    
    func updateTermToArray(_ searchTerm: SearchTerm, add: Bool) {
        switch searchTerm.type {
        case SearchTermType.saved.rawValue:
            if add {
                savedSearchTerms.append(searchTerm)
            } else {
                if let index = savedSearchTerms.index(of: searchTerm) {
                    savedSearchTerms.remove(at: index)
                    libraryAPI.removeSearchTerm(searchTerm)
                }
            }
            break
        case SearchTermType.temp.rawValue:
            if add {
                savedSearchTerms.insert(searchTerm, at: 0)
            } else {
                if let index = savedSearchTerms.index(of: searchTerm) {
                    savedSearchTerms.remove(at: index)
                    libraryAPI.removeSearchTerm(searchTerm)
                }
            }
            break
        case SearchTermType.recent.rawValue:
            if add {
                recentSearchTerms.append(searchTerm)
            } else {
                if let index = recentSearchTerms.index(of: searchTerm) {
                    recentSearchTerms.remove(at: index)
                    libraryAPI.removeSearchTerm(searchTerm)
                }
            }
            break
        case SearchTermType.popular.rawValue:
            if add {
                popularSearchTerms.append(searchTerm)
            } else {
                if let index = popularSearchTerms.index(of: searchTerm) {
                    popularSearchTerms.remove(at: index)
                    libraryAPI.removeSearchTerm(searchTerm)
                }
            }
            break
        default:
            break
        }
    }
    
    func searchTermIsUnique(name: String, type: SearchTermType) -> Bool {
        switch type {
        case SearchTermType.saved:
            for term in savedSearchTerms {
                if name == term.name { return false }
            }
            break
        case SearchTermType.temp:
            break
        case SearchTermType.recent:
            for term in recentSearchTerms {
                if name == term.name { return false }
            }
            break
        case SearchTermType.popular:
            for term in popularSearchTerms {
                if name == term.name { return false }
            }
            break
        default:
            break
        }
        return true
    }
    
    func saveSearchTerm(_ termName: String, imageName: String?, type: SearchTermType, order: Int?) {
        guard searchTermIsUnique(name: termName, type: type) else {
            utility.showAlert(Constants.Alerts.saveTermNotUniqueTitle, message: Constants.Alerts.saveTermNotUniqueMessage, vc: nil)
            return
        }
        libraryAPI.saveSearchTerm(name: termName, imageName: imageName, type: type, order: order, completion: {[weak self] searchTerm in
            self?.updateTermToArray(searchTerm, add: true)
        })
    }
    
    func removeSearchTerm(_ term: SearchTerm) {
        updateTermToArray(term, add: false)
    }
    
}
