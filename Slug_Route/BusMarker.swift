//
//  BusMarker.swift
//  Slug_Route
//
//  Created by Jeff on 11/7/16.
//  Copyright © 2016 Jeff. All rights reserved.
//

import Foundation
import GoogleMaps

class BusMarker: LocationObject {
    var _marker: GMSMarker
    
    var marker: GMSMarker {
        set { _marker = newValue }
        get { return _marker }
    }
    
    init(id: Int, marker: GMSMarker, location: CLLocation, type: String) {
        _marker = marker
        super.init(id: id, location: location, type: type)
    }
    
    init(id: Int, marker: GMSMarker, latitude: Double, longitude: Double, type: String) {
        _marker = marker
        super.init(id: id, lat: latitude, lon: longitude, type: type)
    }

}
