//
//  LocationObject.swift
//  Slug_Route
//
//  Created by Jeff on 11/8/16.
//  Copyright © 2016 Jeff. All rights reserved.
//

import Foundation
import MapKit

class LocationObject {
    private var _id: Int
    private var _location: CLLocation
    private var _type: String
    
    var id: Int {
        set { _id = newValue }
        get { return _id }
    }
    
    var location: CLLocation {
        set { _location = newValue }
        get { return _location }
    }
    
    var type: String {
        set { _type = newValue }
        get { return _type }
    }
    
    init(id: Int, lat: Double, lon: Double, type: String) {
        _id = id
        _location = CLLocation(latitude: lat, longitude: lon)
        _type = type
    }
    
    init(id: Int, location: CLLocation, type: String) {
        _id = id
        _location = location
        _type = type
    }
    
}
