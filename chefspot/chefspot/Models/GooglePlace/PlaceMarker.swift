//
//  PlaceMarker.swift
//  Hangry Maps
//
//  Created by Roberto Guzman on 7/22/18.
//  Copyright © 2018 Fortytwo Sports. All rights reserved.
//

import Foundation
import GoogleMaps

class PlaceMarker: GMSMarker {

    let place: GooglePlace
    
    init(place: GooglePlace, searchTerm: SearchTerm?) {
        self.place = place
        super.init()
        
        guard let lat = place.geometry?.location?.lat, let long = place.geometry?.location?.lng else {
            return
        }
        
        position = CLLocationCoordinate2D(latitude: lat, longitude: long)
        groundAnchor = CGPoint(x: 0.5, y: 1)
        appearAnimation = .pop
        infoWindowAnchor = CGPoint(x: 0.44, y: 0)
        
        if searchTerm?.name == Constants.Strings.favorites {
            icon = UIImage(named: "small_ic_favorites")
        } else {
            icon = UIImage(named: "small_ic_hamburger")
        }
        
    }
}
