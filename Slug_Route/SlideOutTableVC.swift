//
//  SlideOutTableVC.swift
//  Slug_Route
//
//  Created by Jeff on 12/5/16.
//  Copyright © 2016 Jeff. All rights reserved.
//

import Foundation

class SlideOutTableVC: UITableViewController {
    
    var BusNames = [String]()
    
    override func viewDidLoad() {
        BusNames = ["Bus 10", "Bus 15", "Bus 19", "Bus 20"]
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return BusNames.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SlideOutCell", for: indexPath) as UITableViewCell
        
        cell.textLabel?.text = BusNames[indexPath.row]
        
        return cell
    }
    
}
