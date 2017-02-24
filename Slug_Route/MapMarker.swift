//
//  MapMarker.swift
//  Slug_Route
//
//  Created by Jeff on 2/23/17.
//  Copyright © 2017 Jeff. All rights reserved.
//

import Foundation
import MapKit

class MapMarker: NSObject, MKAnnotation {
    dynamic var coordinate: CLLocationCoordinate2D
    var title: String?
    var subtitle: String?
    var image: UIImage?
    var zOrder: CGFloat?
    
    init(coordinate: CLLocationCoordinate2D, title: String, subtitle: String, image: UIImage, zOrder: CGFloat) {
        self.coordinate = coordinate
        self.title = title
        self.subtitle = subtitle
        self.image = image
        self.zOrder = zOrder
    }
}
