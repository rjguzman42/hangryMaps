//
//  UserManager.swift
//  chefspot
//
//  Created by Roberto Guzman on 7/10/18.
//  Copyright © 2018 Fortytwo Sports. All rights reserved.
//

import Foundation
import CoreData
import SDWebImage

class UserManager {
    
    static let sharedInstance = UserManager()
    let libraryAPI = LibraryAPI.sharedInstance
    let utility = AppUtility.sharedInstance
    var localUser: LocalUser?
    
    private init() {
    }
    
    func getLocalUser() {
        libraryAPI.getLocalUser(completion: {[weak self] result in
            if self != nil {
                switch result {
                case .success(let localUser):
                    DebugLog.DLog(localUser)
                    self?.localUser = localUser
                    if self?.localUser == nil {
                        self?.logOut()
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
        })
    }
    
    func updateLocalUser(name: String?, profileImage: UIImage?, completion: (APIResult<LocalUser>) -> Void) {
        guard localUser != nil else {
            return
        }
        libraryAPI.updateLocalUser(localUser: localUser!, name: name, profileImage: profileImage, completion: {[weak self] result in
            if self != nil {
                switch result {
                case .success(let localUser):
                    self?.localUser = localUser
                    self?.notifyUserUpdate()
                    break
                default:
                    self?.utility.showAlert(Constants.Alerts.userUpdateFailedTitle, message: Constants.Alerts.userUpdateFailedMessage, vc: nil)
                    break
                }
                completion(result)
            }
        })
    }
    
    func notifyUserUpdate() {
        NotificationCenter.default.post(name: .userUpdated, object: self)
    }
    
    
    //MARK: Authentication
    
    func authenticate(name: String, profileImage: UIImage, completion: () -> Void) {
        libraryAPI.authenticate(name: name, profileImage: profileImage, completion: { [weak self] user in
            if self != nil {
                localUser = user
                completion()
            }
        })
    }
    
    func setAuthToken(_ token: String?) {
        libraryAPI.setAuthToken(token)
    }
    
    func getAuthToken() -> String? {
        let token = libraryAPI.getAuthToken()
        return token
    }
    
    func logOut() {
        libraryAPI.logOut()
    }
}
