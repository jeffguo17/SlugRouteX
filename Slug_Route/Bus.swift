//
//  Bus.swift
//  Slug_Route
//
//  Created by Jeff on 11/7/16.
//  Copyright © 2016 Jeff. All rights reserved.
//

import Foundation
import CoreLocation
import UIKit

class Bus: LocationObject {
    
}

enum BusType: String {
    case loop = "Loop"
    case upperCampus = "Upper Campus"
    case outOfService = "Out Of Service"
    case nightOwl = "Night Owl"
    case special = "Special"
}

extension UIImage {
    enum BusIcon: String {
        case loop, uppercampus, nightowl, outofservice, special
    }
    
    convenience init!(busImage: BusIcon) {
        self.init(named: busImage.rawValue)
    }
}
