//
//  BusStop.swift
//  Slug_Route
//
//  Created by Jeff on 11/8/16.
//  Copyright © 2016 Jeff. All rights reserved.
//

import Foundation
import MapKit

class BusStop: LocationObject {
    private var _name: String
    
    var name: String {
        set { _name = newValue }
        get { return _name }
    }
    
    init(id: Int, lat: Double, lon: Double, name: String) {
        _name = name
        super.init(id: id, lat: lat, lon: lon, type: "0")
    }
    
    init(_ id: Int,_ location: CLLocation,_ name: String) {
        _name = name
        super.init(id: id, location: location, type: "0")
    }
    
}

enum BusStopType: String {
    case outerStop = "Outer Stop"
    case innerStop = "Inner Stop"
}

extension UIImage {
    enum BusStopImage: String {
        case blue_stop, orange_stop
    }
    
    convenience init!(busStopImage: BusStopImage) {
        self.init(named: busStopImage.rawValue)
    }
}

struct BusStops {
    var innerLoopList = [BusStop]()
    var outerLoopList = [BusStop]()
    
    init() {
        // Populate the inner loop stops
        innerLoopList.append(BusStop(5, CLLocation(latitude: 36.9999313354492, longitude: -122.062049865723), "McLaughlin & Science Hill"));
        
        innerLoopList.append(BusStop(2, CLLocation(latitude: 36.9967041015625, longitude: -122.063583374023), "Heller & Kerr Hall"));
        
        innerLoopList.append(BusStop(3, CLLocation(latitude: 36.999210357666, longitude: -122.064338684082), "Heller & Kresge College"));
        
        innerLoopList.append(BusStop(5, CLLocation(latitude: 36.9999313354492, longitude: -122.062049865723), "McLaughlin & Science Hill"));
    
        innerLoopList.append(BusStop(6, CLLocation(latitude: 36.9997062683105, longitude: -122.05834197998), "McLaughlin & College 9 & 10 - Health Center"));
    
        innerLoopList.append(BusStop(10, CLLocation(latitude: 36.9966621398926, longitude: -122.055480957031), "Hagar & Bookstore"));
        
        innerLoopList.append(BusStop(13, CLLocation(latitude: 36.9912567138672, longitude: -122.054962158203), "Hagar & East Remote"));
        
        innerLoopList.append(BusStop(15, CLLocation(latitude: 36.985523223877, longitude: -122.053588867188), "Hagar & Lower Quarry Rd"));
        
        innerLoopList.append(BusStop(17, CLLocation(latitude: 36.9815368652344, longitude: -122.052131652832), "Coolidge & Hagar"));
        
        innerLoopList.append(BusStop(18, CLLocation(latitude: 36.9787902832031, longitude: -122.057762145996), "High & Western Dr"));
        
        innerLoopList.append(BusStop(20, CLLocation(latitude: 36.9773025512695, longitude: -122.054328918457), "High & Barn Theater"));
        
        innerLoopList.append(BusStop(23, CLLocation(latitude: 36.9826698303223, longitude: -122.062492370605), "Empire Grade & Arboretum"));
        
        innerLoopList.append(BusStop(26, CLLocation(latitude: 36.9905776977539, longitude: -122.066116333008), "Heller & Oakes College"));
        
        innerLoopList.append(BusStop(29, CLLocation(latitude: 36.9927787780762, longitude: -122.064880371094), "Heller & College 8 & Porter"));
        
        
        // Outer loop stops
        outerLoopList.append(BusStop(1, CLLocation(latitude: 36.9992790222168, longitude: -122.064552307129), "Heller & Kresge College"));
        
        outerLoopList.append(BusStop(4, CLLocation(latitude: 37.0000228881836, longitude: -122.062339782715), "McLaughlin & Science Hill"));
        
        outerLoopList.append(BusStop(7, CLLocation(latitude: 36.9999389648438, longitude: -122.058349609375), "McLaughlin & College 9 & 10 - Health Center"));
        
        outerLoopList.append(BusStop(8, CLLocation(latitude: 36.9990234375, longitude: -122.055229187012), "McLaughlin & Crown College"));
        
        outerLoopList.append(BusStop(9, CLLocation(latitude: 36.9974822998047, longitude:-122.055030822754), "Hagar & Bookstore-Stevenson College"));
        
        outerLoopList.append(BusStop(11, CLLocation(latitude: 36.9942474365234, longitude:-122.055511474609), "Hagar & Field House East"));
        
        outerLoopList.append(BusStop(12, CLLocation(latitude: 36.9912986755371, longitude: -122.054656982422), "Hagar & East Remote"));
        
        outerLoopList.append(BusStop(14, CLLocation(latitude: 36.985912322998, longitude:-122.053520202637), "Hagar & Lower Quarry Rd"));
        
        outerLoopList.append(BusStop(16, CLLocation(latitude: 36.9813537597656, longitude:-122.051971435547), "Coolidge & Hagar"));
        
        outerLoopList.append(BusStop(19, CLLocation(latitude: 36.9776763916016, longitude:-122.053558349609), "Coolidge & Main Entrance"));
        
        outerLoopList.append(BusStop(21, CLLocation(latitude: 36.9786148071289, longitude: -122.05785369873), "High & Western Dr"));
        
        outerLoopList.append(BusStop(22, CLLocation(latitude: 36.9798469543457, longitude:-122.059257507324), "Empire Grade & Tosca Terrace"));
        
        outerLoopList.append(BusStop(24, CLLocation(latitude: 36.9836616516113, longitude:-122.064964294434), "Empire Grade & Arboretum"));
        
        outerLoopList.append(BusStop(25, CLLocation(latitude: 36.989917755127, longitude:-122.067230224609), "Heller & Oakes College"));
        
        outerLoopList.append(BusStop(27, CLLocation(latitude: 36.991828918457, longitude:-122.066833496094), "Heller & Family Student Housing"));
        
        outerLoopList.append(BusStop(28, CLLocation(latitude: 36.992977142334, longitude:-122.065223693848), "Heller & College 8 & Porter"));
        
    }
    
}
