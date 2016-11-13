//
//  ViewController.swift
//  Slug_Route
//
//  Created by Jeff on 11/5/16.
//  Copyright © 2016 Jeff. All rights reserved.
//

import UIKit
import GoogleMaps

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var popUpTableView: UITableView!
    @IBOutlet var popUpView: UIView!
    
    @IBAction func popUpViewButton(_ sender: UIButton) {
        UIView.animate(withDuration: 0.25, animations: {
            self.popUpView.transform = CGAffineTransform(scaleX: 1.3, y: 1.3)
            self.popUpView.alpha = 0
        }) { (success: Bool) in
            self.visualEffectView.removeFromSuperview()
            self.popUpView.removeFromSuperview()
        }
    }
    
    var mapView: GMSMapView?
    var busList = [Bus]()
    var busMarkerList = [BusMarker]()
    var visualEffectView: UIView!
    
    let mapName = [BusType.loop.rawValue,BusType.upperCampus.rawValue,BusType.outOfService.rawValue, BusType.nightOwl.rawValue, BusType.special.rawValue, BusStopType.innerStop.rawValue,BusStopType.outerStop.rawValue]
    
    let mapImage = [UIImage(busImage: .loop), UIImage(busImage: .uppercampus), UIImage(busImage: .outofservice), UIImage(busImage: .nightowl), UIImage(busImage: .special),UIImage(busStopImage: .orange_stop), UIImage(busStopImage: .blue_stop)]
    
    override func viewDidLoad() {
        super.viewDidLoad()
    GMSServices.provideAPIKey("AIzaSyAtebqP7WjxCl7H7TpYwnBhMyIL8mqnK7o")
        
        let mapSize = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height-45)
        
        let camera = GMSCameraPosition.camera(withLatitude: 36.992550, longitude: -122.0586165, zoom: 14)
        
        mapView = GMSMapView.map(withFrame: mapSize, camera: camera)
        
        self.view.addSubview(mapView!)
        
        let infoButton = UIButton(frame: CGRect(x: self.view.frame.size.width-50, y: 125, width: 35, height: 35))
        
        infoButton.layer.cornerRadius = 0.5 * infoButton.bounds.size.width
        
        infoButton.backgroundColor = UIColor.white
        infoButton.setTitle("i", for: .normal)
        infoButton.setTitleColor(self.view.tintColor, for: .normal)

        infoButton.addTarget(self, action: #selector(infoButtonAction), for: UIControlEvents.touchUpInside)
        
        mapView?.addSubview(infoButton)
        
        let numBusLabel = UILabel(frame: CGRect(x: 0, y: view.frame.height-45, width: self.view.frame.width, height: 45))
            
        numBusLabel.text = "Testing 123 321"
        
        numBusLabel.backgroundColor = UIColor.blue
        
        self.view.addSubview(numBusLabel)
        
        self.popUpView.layer.cornerRadius = 15
        self.popUpView.clipsToBounds = true
        
        visualEffectView = UIView()
        visualEffectView.frame = self.view.bounds
        visualEffectView.backgroundColor = UIColor.gray.withAlphaComponent(0.6)
        
        Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(self.fetchBusHttp), userInfo: nil, repeats: true)
        
        DispatchQueue.main.async {
            self.drawBusStops()
        }
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @objc private func fetchBusHttp() {
        let URL = NSURL(string: "http://bts.ucsc.edu:8081/location/get")
        
        let session = URLSession.shared
        
        let task = session.dataTask(with: URL! as URL) {
            (data, response, error) in
            
            if error != nil {
                print(error!)
                return
            }
            
            do {
                let jsonArray = try JSONSerialization.jsonObject(with: data!, options:
                    JSONSerialization.ReadingOptions.mutableContainers) as! [[String: AnyObject]]
                
                self.setBusList(resultArray: jsonArray)
                
            } catch let jsonError {
                print(jsonError)
            }
            
            
        }
        
        task.resume()
    }
    
    private func drawBusStops() {
        for mBusStop in BusStops().innerLoopList {
            let mMarker = GMSMarker(position: mBusStop.location.coordinate)
            mMarker.title = mBusStop.name
            mMarker.icon = UIImage(busStopImage: .orange_stop)
            mMarker.snippet = BusStopType.innerStop.rawValue
            mMarker.groundAnchor = CGPoint(x: 0.5, y: 0.5)
            mMarker.map = self.mapView
        }
        
        for mBusStop in BusStops().outerLoopList {
            let mMarker = GMSMarker(position: mBusStop.location.coordinate)
            mMarker.title = mBusStop.name
            mMarker.icon = UIImage(busStopImage: .blue_stop)
            mMarker.snippet = BusStopType.outerStop.rawValue
            mMarker.groundAnchor = CGPoint(x: 0.5, y:0.5)
            mMarker.map = self.mapView
        }
    }
    
    private func setBusList(resultArray: [[String: AnyObject]]) {
        busList.removeAll()
        for jsonObject in resultArray {
            busList.append(Bus(id: Int(jsonObject["id"] as! String)!, lat: jsonObject["lat"] as! Double, lon: jsonObject["lon"] as! Double, type: jsonObject["type"] as! String))
        }
        
        DispatchQueue.main.async {
            self.updateBusMarkers()
        }
    }
    
    private func updateBusMarkers() {
        for b in busList {
            
            var mBusMarker: BusMarker?
            
            for m in busMarkerList {
                if m.id == b.id {
                    mBusMarker = m
                    
                    if m.type != b.type {
                        let mIndex = busMarkerList.index(where: { $0 === m })
                        busMarkerList.remove(at: mIndex!)
                        m.marker.map = nil
                        mBusMarker = nil
                    }
                    
                    break
                }
            }
            
            if let mBusMarker = mBusMarker {
                mBusMarker.marker.position = b.location.coordinate
                //animate marker
            } else {
                var busImage: UIImage?
                
                switch( b.type.uppercased() ) {
                case "LOOP": busImage = UIImage(busImage: .loop)
                case "UPPER CAMPUS": busImage = UIImage(busImage: .uppercampus)
                case "NIGHT OWL": busImage = UIImage(busImage: .nightowl)
                case "LOOP OUT OF SERVICE AT BARN THEATER", "OUT OF SERVICE/SORRY": busImage = UIImage(busImage: .outofservice)
                default: busImage = UIImage(busImage: .special)
                }
                
                let newMarker = GMSMarker(position: b.location.coordinate)
                newMarker.title = b.type
                newMarker.icon = busImage
                newMarker.groundAnchor = CGPoint(x: 0.5, y: 0.5)
                newMarker.zIndex = 1
                newMarker.map = mapView
                
                busMarkerList.append(BusMarker(id: b.id, marker: newMarker, location: b.location, type: b.type))
            }
            
        }
        
        //Remove off-line bus markers
        var indexToRemove = [Int]()
        
        for m in 0..<busMarkerList.count {
            
            var removeCurrentMarker: Bool = true
            
            for b in busList {
                if ( b.id == busMarkerList[m].id ) {
                    removeCurrentMarker = false
                    break
                }
            }
            
            if removeCurrentMarker {
                busMarkerList[m].marker.map = nil
                indexToRemove.append(m)
            }
            
        }
        
        for i in indexToRemove {
            busMarkerList.remove(at: i)
        }
        
    }
    
    func infoButtonAction() {
        self.view.addSubview(popUpView)
        popUpView.center = self.view.center
        
        popUpView.transform = CGAffineTransform.init(scaleX: 1.3, y: 1.3)
        popUpView.alpha = 0
        
        UIView.animate(withDuration: 0.25) {
            self.view.addSubview(self.visualEffectView)
            
            self.view.bringSubview(toFront: self.popUpView)
            self.popUpView.alpha = 1
            self.popUpView.transform = CGAffineTransform.identity
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return mapName.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
       
        let cell = self.popUpTableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! MapKeyCell
        
        cell.mapImage.image = mapImage[indexPath.row]
        cell.mapName.text = mapName[indexPath.row]
        
        return cell
    }
    
}

