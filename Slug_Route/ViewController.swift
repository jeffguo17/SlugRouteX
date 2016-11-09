//
//  ViewController.swift
//  Slug_Route
//
//  Created by Jeff on 11/5/16.
//  Copyright © 2016 Jeff. All rights reserved.
//

import UIKit
import GoogleMaps

class ViewController: UIViewController {
    
    var mapView: GMSMapView?

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        GMSServices.provideAPIKey("AIzaSyAtebqP7WjxCl7H7TpYwnBhMyIL8mqnK7o")
        
        let camera = GMSCameraPosition.camera(withLatitude: 36.990573, longitude: -122.0586165, zoom: 14)
        
        mapView = GMSMapView.map(withFrame: CGRect.zero, camera: camera)
        
        view = mapView
        
        Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(self.fetchBusHttp), userInfo: nil, repeats: true)
        
        drawBusStops()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func fetchBusHttp() {
        let URL = NSURL(string: "http://bts.ucsc.edu:8081/location/get")
        
        let session = URLSession.shared
        
        let task = session.dataTask(with: URL! as URL) {
            (data, response, error) in
            
            if error != nil {
                print(error)
                return
            }
            
            do {
                let jsonArray = try JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.mutableContainers)
                
                for jsonObject in jsonArray as! [[String: AnyObject]] {
                    print(jsonObject["id"])
                }
                
                
            } catch let jsonError {
                print(jsonError)
            }
            
            
        }
        
        task.resume()
    }
    
    func drawBusStops() {
        for mBusStop in BusStops().innerLoopList {
            let mMarker = GMSMarker(position: mBusStop.location.coordinate)
            mMarker.title = mBusStop.name
            mMarker.icon = UIImage(busStopImage: .orange_stop)
            mMarker.snippet = "Inner Loop"
            mMarker.map = mapView
        }
        
        for mBusStop in BusStops().outerLoopList {
            let mMarker = GMSMarker(position: mBusStop.location.coordinate)
            mMarker.title = mBusStop.name
            mMarker.icon = UIImage(busStopImage: .blue_stop)
            mMarker.snippet = "Outer Loop"
            mMarker.map = mapView
        }
    }

}

