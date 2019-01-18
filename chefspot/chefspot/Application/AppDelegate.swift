//
//  AppDelegate.swift
//  chefspot
//
//  Created by Roberto Guzman on 7/6/18.
//  Copyright © 2018 Fortytwo Sports. All rights reserved.
//

import UIKit
import Firebase
import GoogleMaps

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    let persistencyManager = PersistencyManager.sharedInstance
    let userManager = UserManager.sharedInstance
    let utility = AppUtility.sharedInstance
    var orientationLock = UIInterfaceOrientationMask.portrait


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        //setup persistency
        persistencyManager.appDidLaunch()
        
        //remove previous temp
        let libraryAPI = LibraryAPI.sharedInstance
        libraryAPI.removeTemporarySearchTerms()
        
        //load local user
        userManager.getLocalUser()

        configureExternalServices()

        utility.setupBaseUI()

        //transfer user to correct page based on login
        updateRootVC()
        
        return true
    }
    
    func application(_ application: UIApplication, supportedInterfaceOrientationsFor window: UIWindow?) -> UIInterfaceOrientationMask {
        return orientationLock
    }

    
    //MARK: External Services
    
    func configureExternalServices() {
        //Firebase
        FirebaseApp.configure()
        
        //GoogleMaps
        var googleDict: NSDictionary?
        if let path = Bundle.main.path(forResource: "GoogleService-Info", ofType: "plist") {
            googleDict = NSDictionary(contentsOfFile: path)
        }
        if let dict = googleDict {
            let googleAPIKey = dict["API_KEY"] as! String
            GMSServices.provideAPIKey(googleAPIKey)
        }
    }

    
    //MARK: Authentication
    
    func updateRootVC() {
        let authToken = userManager.getAuthToken()
        var rootVC : UIViewController?
        
        if(authToken != nil){
            //user is logged in....let's enter app and show the Home Page
            let navVC = UINavigationController()
            navVC.viewControllers = [MapVC()]
            rootVC = navVC
        } else {
            //user is not logged in, and shall be sent to root controller to login
            let navVC = UINavigationController()
            navVC.navigationBar.isHidden = false
            navVC.viewControllers = [GetStartedVC()]
            rootVC = navVC
        }
        
        self.window?.rootViewController = rootVC
        self.window?.makeKeyAndVisible()
    }

}

