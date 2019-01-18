//
//  MapVC.swift
//  chefspot
//
//  Created by Roberto Guzman on 7/6/18.
//  Copyright © 2018 Fortytwo Sports. All rights reserved.
//

import Foundation
import UIKit
import GoogleMaps

class MapVC: UIViewController {
    
    let mapView: GMSMapView = {
        let view = GMSMapView()
        view.mapStyle(withFilename: Constants.Strings.mapStyleLight, andType: "json")
        return view
    }()
    var nearMeButton: MapButtonView = {
        let view = MapButtonView(frame: CGRect(x: UIScreen.main.bounds.size.width - 10, y: UIScreen.main.bounds.size.height - 10, width: Constants.Sizes.mapButtonViewHeight, height: Constants.Sizes.mapButtonViewHeight))
        view.mainImageView.image = UIImage(named: "ic_near_me")?.imageWithInsets(insets: UIEdgeInsets(top: 15, left: 15, bottom: 15, right: 15))
        return view
    }()
    var searchButton: MapButtonView = {
        let view = MapButtonView(frame: CGRect(x: UIScreen.main.bounds.size.width - 10, y: 10, width: Constants.Sizes.mapButtonViewHeight, height: Constants.Sizes.mapButtonViewHeight))
        view.mainImageView.image = UIImage(named: "ic_search")?.imageWithInsets(insets: UIEdgeInsets(top: 13, left: 13, bottom: 13, right: 13))
        return view
    }()
    var profileButton: MapButtonView = {
        let view = MapButtonView(frame: CGRect(x: 10, y: 10, width: Constants.Sizes.mapButtonViewHeight, height: Constants.Sizes.mapButtonViewHeight))
        view.mainImageView.image = UIImage(named: "ic_account_empty")?.imageWithInsets(insets: UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0))
        return view
    }()
    lazy var searchAreaButton: MapButtonView = {
        let searchAreaButtonSize = utility.getSizeToFitString(text: Constants.Strings.searchAgain, font: Theme.Fonts.primary.font)
        let view = MapButtonView(frame: CGRect(x: 10, y: 10, width: searchAreaButtonSize.width, height: searchAreaButtonSize.height + 10))
        view.mainImageView.isHidden = true
        view.titleLabel.isHidden = false
        view.layer.cornerRadius = searchAreaButtonSize.width / 9
        view.isHidden = true
        view.alpha = 0.0
        return view
    }()
    lazy var sideViewManager: SideViewManager = {
        let manager = SideViewManager()
        manager.vc = self
        return manager
    }()
    lazy var foodFilterViewManager: FoodFilterViewManager = {
        let manager = FoodFilterViewManager()
        manager.vc = self
        return manager
    }()
    let buttonSize = Constants.Sizes.mapButtonViewHeight ?? 35
    lazy var searchAreaButtonSize = utility.getSizeToFitString(text: Constants.Strings.searchAgain, font: Theme.Fonts.primary.font)
    private let locationManager = CLLocationManager()
    let dataManager = DataManager.sharedInstance
    let userManager = UserManager.sharedInstance
    let utility = AppUtility.sharedInstance
    let libraryAPI = LibraryAPI.sharedInstance
    var mapDidLoad: Bool = false
    lazy var mapCenterLocation: CLLocationCoordinate2D = {
       let coordinate = locationManager.location?.coordinate
        return coordinate ?? CLLocationCoordinate2D(latitude: 40.7128, longitude: 74.0060)
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        getLocalPlaces(keyword: dataManager.savedSearchTerms.first?.name ?? "Lunch")
        setupInitialLocation()
        setupSubViews()
        addUserInfo()
        addFavoritePlaces()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.isHidden = true
        subscribeToNotifications()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.navigationBar.isHidden = false
    }
    
    
    //MARK: UI

    func setupSubViews() {
        title = ""
        
        //mapView
        view.addSubview(mapView)
        view.addConstraintsWithFormat(format: "H:|[v0]|", views: mapView)
        view.addConstraintsWithFormat(format: "V:|[v0]|", views: mapView)
        mapView.delegate = self
        
        //searchButton
        view.addSubview(searchButton)
        view.addConstraintsWithFormat(format: "H:[v0(\(buttonSize))]-10-|", views: searchButton)
        view.addConstraintsWithFormat(format: "V:|-20-[v0(\(buttonSize))]", views: searchButton)
        
        //profileButton
        view.addSubview(profileButton)
        view.addConstraintsWithFormat(format: "H:|-10-[v0(\(buttonSize))]", views: profileButton)
        view.addConstraintsWithFormat(format: "V:|-20-[v0(\(buttonSize))]", views: profileButton)
        
        //searchAreaButton
        view.addSubview(searchAreaButton)
        view.addConstraintsWithFormat(format: "H:[v0(\(searchAreaButtonSize.width))]", views: searchAreaButton)
        view.addConstraintsWithFormat(format: "V:[v0(\(searchAreaButtonSize.height + 10))]", views: searchAreaButton)
        view.addConstraint(NSLayoutConstraint(item: searchAreaButton, attribute: .centerX, relatedBy: .equal, toItem: view, attribute: .centerX, multiplier: 1, constant: 0))
        view.addConstraint(NSLayoutConstraint(item: searchAreaButton, attribute: .centerY, relatedBy: .equal, toItem: profileButton, attribute: .centerY, multiplier: 1, constant: 0))
        
        //foodFilterView
        foodFilterViewManager.attachedViews = [nearMeButton]
        foodFilterViewManager.show()
        foodFilterViewManager.placeCellTapped = { [weak self] place in
            self?.presentPlaceVC(place: place)
        }
        foodFilterViewManager.loadPlaceCellTapped = { [weak self] searchTerm in
            self?.getLocalPlaces(keyword: searchTerm)
        }
        
        //nearMeButton
        view.addSubview(nearMeButton)
        view.addConstraintsWithFormat(format: "H:[v0(\(buttonSize))]-10-|", views: nearMeButton)
        view.addConstraintsWithFormat(format: "V:[v0(\(buttonSize))]", views: nearMeButton)
        view.addConstraint(NSLayoutConstraint(item: nearMeButton, attribute: .bottom, relatedBy: .equal, toItem: foodFilterViewManager.foodFilterView, attribute: .top, multiplier: 1, constant: -10))
    
        addGestures()
    }
    
    func hideSearchAreaButton(_ hide: Bool) {
        searchAreaButton.isHidden = hide
        if hide {
            searchAreaButton.alpha = 0.0
        } else {
            searchAreaButton.alpha = 1.0
        }
    }
    
    
    //MARK: Content
    
    func getLocalPlaces(keyword: String) {
        
        
        //calculate parameters
        let lat = mapCenterLocation.latitude
        let lon = mapCenterLocation.longitude
        let currentLocation = "\(lat),\(lon)"
        var radius = Int(mapView.getRadius())
        if radius < 3000 {
            radius = 3000
        }
        
        dataManager.nearbySearch(location: currentLocation, radius: String(radius), keyword: keyword, completion: {[weak self] in
            self?.foodFilterViewManager.foodFilterView.placeScrollView.collectionView.reloadData()
            self?.addMapMarkers(keyword: keyword)
        })
    }
    
    func addUserInfo() {
        if let profileImageData = userManager.localUser?.profileImageData {
            profileButton.mainImageView.image = UIImage(data: profileImageData)
        } else if let profileImagePath = userManager.localUser?.profileImagePath {
            libraryAPI.downloadImageWithPath(path: profileImagePath, completion: { [weak self] image, data in
                if image != nil {
                    self?.profileButton.mainImageView.image = image
                }
            })
        }
    }
    
    func addFavoritePlaces() {
        addMapMarkers(keyword: Constants.Strings.favorites)
    }
    
    func clearMapMarkers(removeFavorites: Bool) {
        mapView.clear()
        if !removeFavorites {
            addFavoritePlaces()
        }
    }
    
    func addMapMarkers(keyword: String) {
        if let places = dataManager.localPlaces[keyword] {
            if dataManager.favoriteSearchTerm?.name == keyword {
                for place in places {
                    addPlaceMarker(place: place, searchTerm: dataManager.favoriteSearchTerm)
                }
            } else if let searchTerm = dataManager.savedSearchTerms.filter({$0.name == keyword}).first {
                for place in places {
                    addPlaceMarker(place: place, searchTerm: searchTerm)
                }
            } else if let searchTerm = dataManager.popularSearchTerms.filter({$0.name == keyword}).first {
                for place in places {
                    addPlaceMarker(place: place, searchTerm: searchTerm)
                }
            }
        }
    }
    
    
    func addPlaceMarker(place: GooglePlace, searchTerm: SearchTerm?) {
        guard searchTerm != nil else {
            return
        }
        let iconSize = Constants.Strings.foodItemSizeSmall
        let marker = PlaceMarker(place: place, searchTerm: searchTerm!)
        marker.map = mapView
        marker.title = place.name
        if let imageName = searchTerm?.imageName {
            let sizedName = iconSize + imageName
            marker.icon = UIImage(named: sizedName)?.withRenderingMode(.alwaysOriginal)
        }
    }
    
    //MARK: Notifications
    
    func subscribeToNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(handleSearchTerm(_:)), name: .searchTerm, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(handleUserUpdated(_:)), name: .userUpdated, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(handleSavedFoodItemsUpdated(_:)), name: .savedFoodItemsUpdated, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(handleFavoritePlacesUpdated(_:)), name: .favoritePlacesUpdated, object: nil)
    }
    
    @objc func handleSearchTerm(_ notification: Notification) {
        guard let userInfo = notification.userInfo,
            let term = userInfo["term"] as? String else {
                return
        }
    
        foodFilterViewManager.handleNewSearchTerm(term)
        getLocalPlaces(keyword: term)
    }
    
    @objc func handleUserUpdated(_ notification: Notification) {
        addUserInfo()
    }
    
    @objc func handleSavedFoodItemsUpdated(_ notification: Notification) {
        foodFilterViewManager.handleNewSearchTerm(nil)
    }
    
    @objc func handleFavoritePlacesUpdated(_ notification: Notification) {
        guard let userInfo = notification.userInfo,
            let place = userInfo["googlePlace"] as? GooglePlace else {
                return
        }
        addPlaceMarker(place: place, searchTerm: dataManager.favoriteSearchTerm)
    }

    
    
    //MARK: Actions
    
    func addGestures() {
        let nearMeTapGesture = UITapGestureRecognizer(target: self, action: #selector(handleNearMeButtonTapped))
        nearMeButton.addGestureRecognizer(nearMeTapGesture)
        
        let profileTapGesture = UITapGestureRecognizer(target: self, action: #selector(handleProfileButtonTapped))
        profileButton.addGestureRecognizer(profileTapGesture)
        
        let searchTapGesture = UITapGestureRecognizer(target: self, action: #selector(handleSearchButtonTapped))
        searchButton.addGestureRecognizer(searchTapGesture)
        
        let searchAreaTapGesture = UITapGestureRecognizer(target: self, action: #selector(handleSearchAreaButtonTapped))
        searchAreaButton.addGestureRecognizer(searchAreaTapGesture)
    }
    
    @objc func handleNearMeButtonTapped() {
        if let currentLocation = mapView.myLocation {
            showUserLocation(location: currentLocation, animate: true)
        }
    }
    
    @objc func handleProfileButtonTapped() {
         sideViewManager.show()
    }
    
    @objc func handleSearchButtonTapped() {
        let searchVC = SearchVC()
        navigationController?.pushViewController(searchVC, animated: true)
    }
    
    @objc func handleSearchAreaButtonTapped() {
        hideSearchAreaButton(true)
        
        //reset localPlaces data
        dataManager.resetLocalPlaces(removeFavorites: false)
        
        //reset mapView
        clearMapMarkers(removeFavorites: false)
        
        //get current menuBar title
        let title = foodFilterViewManager.getCurrentMenuBarTitle()
        
        getLocalPlaces(keyword: title)
    }
    
     func presentPlaceVC(place: GooglePlace) {
        let placeVC = PlaceVC()
        placeVC.searchTermName = foodFilterViewManager.getCurrentMenuBarTitle()
        placeVC.place = place
        navigationController?.pushViewController(placeVC, animated: true)
    }
}

//MARK: GMSMapViewDelegate

extension MapVC: GMSMapViewDelegate {
    
    func mapView(_ mapView: GMSMapView, idleAt position: GMSCameraPosition) {
        if mapDidLoad {
            UIView.animate(withDuration: 0.6) {
                self.hideSearchAreaButton(false)
                self.mapCenterLocation = mapView.getCenterCoordinate()
            }
        }
        mapDidLoad = true
    }
    
    func mapView(_ mapView: GMSMapView, markerInfoWindow marker: GMSMarker) -> UIView? {
        guard let placeMarker = marker as? PlaceMarker else {
            return nil
        }
        let place = placeMarker.place
        let markerView = PlaceMarkerView(frame: CGRect.init(x: 0, y: 0, width: Constants.Sizes.placeMarkerSuperView.width, height: Constants.Sizes.placeMarkerSuperView.height))
        markerView.addPlaceInfo(place: place)
        return markerView
    }
    
    func mapView(_ mapView: GMSMapView, didTapInfoWindowOf marker: GMSMarker) {
        guard let placeMarker = marker as? PlaceMarker else {
            return
        }
        let place = placeMarker.place
        presentPlaceVC(place: place)
    }
}


// MARK: CLLocationManagerDelegate
// called when the user grants or revokes location permissions

extension MapVC: CLLocationManagerDelegate {
    
    func setupInitialLocation() {
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        guard status == .authorizedWhenInUse else {
            return
        }
        locationManager.startUpdatingLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.first else {
            return
        }
    
        showUserLocation(location: location)
        
        //use if you want to stop following the user
        locationManager.stopUpdatingLocation()
    }
    
    func showUserLocation(location: CLLocation, animate: Bool = false, zoom: Float = 14, bearing: CLLocationDirection = 0, viewingAngle: Double = 0) {
        let cameraPosition = GMSCameraPosition(target: location.coordinate, zoom: zoom, bearing: bearing, viewingAngle: viewingAngle)
        if animate {
            mapView.animate(to: cameraPosition)
        } else {
            mapView.camera = cameraPosition
        }
        mapView.isMyLocationEnabled = true
    }
    
    
}
