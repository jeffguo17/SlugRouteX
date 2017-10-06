//
//  MapLabel.swift
//  Slug_Route
//
//  Created by J on 10/5/17.
//  Copyright © 2017 Jeff. All rights reserved.
//

import Foundation
import MapKit

class MapLabel: NSObject, MKAnnotation {
    dynamic var coordinate: CLLocationCoordinate2D
    var title: String?
    var subtitle: String?
    
    init(coordinate: CLLocationCoordinate2D, title: String, subtitle: String) {
        self.coordinate = coordinate
        self.title = title
        self.subtitle = subtitle
    }
    
}
