//
//  LibraryAPI.swift
//  chefspot
//
//  Created by Roberto Guzman on 7/6/18.
//  Copyright © 2018 Fortytwo Sports. All rights reserved.
//

import Foundation
import UIKit
import CoreData
import SDWebImage

class LibraryAPI  {
    
    static let sharedInstance = LibraryAPI()
    private let httpManager = HTTPManager()
    private let persistencyManager = PersistencyManager.sharedInstance
    private let utility = AppUtility.sharedInstance
    private var isOnline: Bool = true
    
    private init() {
        isOnline = AppUtility.sharedInstance.isInternetAvailable()
    }
    
    
    //MARK: GooglePlace
    
    func nearbysearch(_ location: String, radius: String, keyword: String, types: String, completion: @escaping (APIResult<GooglePlacesAPIResponse>) -> Void) {
        httpManager.getRequest(APIClientType.googlePlaces, GooglePlacesAPIRouter.nearbysearch(location, radius, keyword, types), completion: completion)
    }
    
    func getPlaceDetails(_ placeid: String, fields: String, completion: @escaping (APIResult<GooglePlacesAPIResponse>) -> Void) {
        httpManager.getRequest(APIClientType.googlePlaces, GooglePlacesAPIRouter.getPlaceDetails(placeid, fields), completion: completion)
    }
    
    func setPhotoFromReference(reference: String, maxWidth: Int, imageView: UIImageView) {
        let urlPath = getGooglePlacePhotoURLPath(reference: reference, maxWidth: maxWidth)
        imageView.sd_setImage(with: URL(string: urlPath), placeholderImage: nil, options: [.continueInBackground])
    }
    
    func getPhotoFromReference(reference: String, maxWidth: Int, imageView: UIImageView, completion: @escaping (UIImage?, Data?) -> Void) {
        let urlPath = getGooglePlacePhotoURLPath(reference: reference, maxWidth: maxWidth)
        downloadImageWithPath(path: urlPath, completion: {[weak self] image, data in
            if self != nil {
                completion(image, data)
            }
        })
    }
    
    func getGooglePlacePhotoURLPath(reference: String, maxWidth: Int) -> String {
        let urlPath = "\(Constants.APIPaths.googlePlaces)/photo?\(Constants.APIKeys.maxwidth)=\(maxWidth)&\(Constants.APIKeys.photoreference)=\(reference)&\(Constants.APIKeys.googlePlacesRestAPIKey)=\(Constants.APIValues.googlePlacesRestAPIKey)"
        return urlPath
    }
    
    func getVisitedPlaces(completion: @escaping (APIResult<[LocalPlace]>) -> Void) {
        let predicates = [ NSPredicate(format: "savedType == %@", PlaceType.visited.rawValue)]
        let compoundPredicates = NSCompoundPredicate(type: NSCompoundPredicate.LogicalType.and, subpredicates: predicates)
        let sortDescriptors: [NSSortDescriptor] = [NSSortDescriptor(key: "visitDate", ascending: false)]
        persistencyManager.getCoreDataCollectionRequest(compoundPredicates, sortDescriptors, completion: completion)
    }
    
    func saveAsVisitedPlace(_ googlePlace: GooglePlace, completion: @escaping (LocalPlace) -> Void) {
        let place = convertGooglePlaceToLocalPlace(googlePlace)
        place.savedType = PlaceType.visited.rawValue
        place.visitDate = Date()
        do {
            try persistencyManager.viewContext.save()
            completion(place)
        } catch {
            DebugLog.DLog("Couldn't save as local place")
        }
    }
    
    func getFavoritePlaces(completion: @escaping (APIResult<[LocalPlace]>) -> Void) {
        let predicates = [ NSPredicate(format: "savedType == %@", PlaceType.favorite.rawValue)]
        let compoundPredicates = NSCompoundPredicate(type: NSCompoundPredicate.LogicalType.and, subpredicates: predicates)
        persistencyManager.getCoreDataCollectionRequest(compoundPredicates, [], completion: completion)
    }
    
    func getFavoritePlace(placeId: String, completion: @escaping (APIResult<LocalPlace>) -> Void) {
        let predicates = [NSPredicate(format: "placeId == %@", placeId), NSPredicate(format: "savedType == %@", PlaceType.favorite.rawValue)]
        let compoundPredicates = NSCompoundPredicate(type: NSCompoundPredicate.LogicalType.and, subpredicates: predicates)
        persistencyManager.getCoreDataRequest(compoundPredicates, [], completion: completion)
    }
    
    func removeFavoritePlace(_ googlePlace: GooglePlace, completion: @escaping () -> Void) {
        if let placeId = googlePlace.placeId {
            getFavoritePlace(placeId: placeId, completion: {[weak self] result in
                if self != nil {
                    switch result {
                    case .success(let localPlace):
                        self?.persistencyManager.removeCoreDataObject(localPlace)
                        completion()
                        break
                    default:
                        break
                    }
                }
            })
        }
    }
    
    func saveAsFavoritePlace(_ googlePlace: GooglePlace, completion: @escaping (LocalPlace) -> Void) {
        let place = convertGooglePlaceToLocalPlace(googlePlace)
        place.savedType = PlaceType.favorite.rawValue
        do {
            try persistencyManager.viewContext.save()
            completion(place)
        } catch {
            DebugLog.DLog("Couldn't save as local place")
        }
    }
    
    func convertGooglePlaceToLocalPlace(_ googlePlace: GooglePlace) -> LocalPlace {
        let localPlace = LocalPlace(context: persistencyManager.viewContext)

        if let formattedAddress = googlePlace.formattedAddress {
            localPlace.formattedAddress = formattedAddress
        }
        if let formattedPhoneNumber = googlePlace.formattedPhoneNumber {
            localPlace.formattedPhoneNumber = formattedPhoneNumber
        }
        if let icon = googlePlace.icon {
            localPlace.icon = icon
        }
        if let id = googlePlace.id {
            localPlace.id = id
        }
        if let name = googlePlace.name {
            localPlace.name = name
        }
        if let placeId = googlePlace.placeId {
            localPlace.placeId = placeId
        }
        if let priceLevel = googlePlace.priceLevel {
            localPlace.priceLevel = priceLevel
        }
        if let rating = googlePlace.rating {
            localPlace.rating = rating
        }
        if let reference = googlePlace.reference {
            localPlace.reference = reference
        }
        if let types = googlePlace.types {
            localPlace.types = types as NSObject
        }
        if let vicinity = googlePlace.vicinity {
            localPlace.vicinity = vicinity
        }
        if let website = googlePlace.website {
            localPlace.website = website
        }
        if let googleLocation = googlePlace.geometry?.location, let lat = googleLocation.lat, let lng = googleLocation.lng {
            let location = Location(context: persistencyManager.viewContext)
            location.place = localPlace
            location.latitude = lat
            location.longitude = lng
        }
        
        //photos
        if let photos = googlePlace.photos {
            for photo in photos {
                if let reference = photo.photoReference {
                    let localPhoto = LocalPhoto(context: persistencyManager.viewContext)
                    localPhoto.photoReference = reference
                    localPhoto.place = localPlace
                    let urlPath = getGooglePlacePhotoURLPath(reference: reference, maxWidth: Int(Constants.Sizes.placeHeaderView.width))
                    downloadImageWithPath(path: urlPath, completion: {[weak self] image, data in
                        if data != nil && self != nil {
                            localPhoto.photoData = data
                        }
                    })
                }
            }
        }
    
        //reviews
        if let reviews = googlePlace.reviews {
            for review in reviews {
                let localReview = LocalReview(context: persistencyManager.viewContext)
                localReview.place = localPlace
                if let authorName = review.authorName {
                    localReview.authorName = authorName
                }
                if let authorURL = review.authorUrl {
                    localReview.authorUrl = authorURL
                }
                if let profilePhotoURL = review.profilePhotoUrl {
                    localReview.profilePhotoUrl = profilePhotoURL
                }
                if let rating = review.rating {
                    localReview.rating = rating
                }
                if let relativeTimeDescription = review.relativeTimeDescription {
                    localReview.relativeTimeDescription = relativeTimeDescription
                }
                if let text = review.text {
                    localReview.text = text
                }
            }
        }
            
        return localPlace
    }
    
    
    //MARK: User
    
    func getLocalUser(completion: @escaping (APIResult<LocalUser>) -> Void) {
        let token = getAuthToken() ?? ""
        let predicates = [NSPredicate(format: "authToken == %@", token)]
        let compoundPredicates = NSCompoundPredicate(type: NSCompoundPredicate.LogicalType.and, subpredicates: predicates)
        persistencyManager.getCoreDataRequest(compoundPredicates, [], completion: completion)
    }
    
    func updateLocalUser(localUser: LocalUser, name: String?, profileImage: UIImage?, completion: (APIResult<LocalUser>) -> Void) {
        if name != nil {
            localUser.name = name
        }
        if profileImage != nil {
            if let data = UIImagePNGRepresentation(profileImage!) {
                localUser.profileImageData = data
            }
        }
        do {
            try persistencyManager.viewContext.save()
            completion(APIResult.success(localUser))
        } catch {
            DebugLog.DLog("Couldn't update user")
            completion(APIResult.unexpectedResponse)
        }
    }
    
    
    //MARK: Search Term

    func saveSearchTerm(name: String, imageName: String?, type: SearchTermType, order: Int?, completion: @escaping (SearchTerm) -> Void) {
        let term = SearchTerm(context: persistencyManager.viewContext)
        term.name = name
        term.type = type.rawValue
        term.imageName = imageName ?? "ic_utensil"
        if order != nil {
            term.order = Int32(order!)
        }
        do {
            try persistencyManager.viewContext.save()
            completion(term)
        } catch {
            DebugLog.DLog("Couldn't save user")
        }
    }
    
    func removeSearchTerm(_ term: SearchTerm) {
        persistencyManager.removeCoreDataObject(term)
    }
    
    func getSearchTerm(name: String?, type: SearchTermType?, completion: @escaping (APIResult<SearchTerm>) -> Void) {
        var predicates: [NSPredicate] = []
        if name != nil {
            predicates.append(NSPredicate(format: "name == %@", name!))
        }
        if type != nil {
            predicates.append(NSPredicate(format: "type == %@", type!.rawValue))
        }
        let compoundPredicates = NSCompoundPredicate(type: NSCompoundPredicate.LogicalType.and, subpredicates: predicates)
        persistencyManager.getCoreDataRequest(compoundPredicates, [], completion: completion)
    }
    
    func getSearchTerms(type: SearchTermType?, completion: @escaping (APIResult<[SearchTerm]>) -> Void) {
        var predicates: [NSPredicate] = []
        if type != nil {
            predicates.append(NSPredicate(format: "type == %@", type!.rawValue))
        }
        var sortDescriptors: [NSSortDescriptor] = []
        if type == SearchTermType.saved {
            sortDescriptors.append(NSSortDescriptor(key: "order", ascending: true))
        }
        let compoundPredicates = NSCompoundPredicate(type: NSCompoundPredicate.LogicalType.and, subpredicates: predicates)
        persistencyManager.getCoreDataCollectionRequest(compoundPredicates, sortDescriptors, completion: completion)
    }
    
    func removeTemporarySearchTerms() {
        getSearchTerms(type: SearchTermType.temp, completion: {[weak self] result in
            if self != nil {
                switch result {
                case .success(let terms):
                    for term in terms {
                        self?.removeSearchTerm(term)
                    }
                    break
                default:
                    break
                }
            }
        })
    }
    
    
    //MARK: Authentication
    
    func authenticate(name: String, profileImage: UIImage, completion: (LocalUser) -> Void) {
        let user = LocalUser(context: persistencyManager.viewContext)
        user.name = name
        if let data = UIImagePNGRepresentation(profileImage) {
            user.profileImageData = data
        }
        let date = utility.getCurrentDateAsString()
        let authToken = name + date
        user.authToken = authToken
        do {
            try persistencyManager.viewContext.save()
            setAuthToken(authToken)
            completion(user)
        } catch {
            DebugLog.DLog("Couldn't save user")
        }
    }
    
    func setAuthToken(_ token: String?) {
        persistencyManager.setSecureValue(value: token, key: PersistRouter.authToken)
    }
    
    func getAuthToken() -> String? {
        let token = persistencyManager.getSecureValueForKey(PersistRouter.authToken)
        return token
    }
    
    func logOut() {
        
        //Clear all local persisted data
        persistencyManager.clearAllDataLocally()
        
        //revert back to login page
        utility.clearControllers()
    }

    
    //MARK: CoreData
    
    func saveCoreData() {
        persistencyManager.saveCoreData()
    }
    
    
    //MARK: Image
    
    func downloadImageWithPath(path: String, completion: @escaping (UIImage?, Data?) -> Void) {
        httpManager.downloadImageWithPath(path: path, completion: { [weak self] image, data in
            if self != nil {
                completion(image, data)
            }
        })

    }
    
    
}
