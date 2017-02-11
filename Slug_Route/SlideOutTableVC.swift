//
//  SlideOutTableVC.swift
//  Slug_Route
//
//  Created by Jeff on 12/5/16.
//  Copyright © 2016 Jeff. All rights reserved.
//

import Foundation

class SlideOutTableVC: UITableViewController {
    
    var BusNames = ["Bus 10 - UCSC Via High", "Bus 15 - UCSC Via Laurel West", "Bus 16 - UCSC Via Laurel East", "Bus 19 - UCSC Via Lower Bay", "Bus 20 - UCSC Via Westside"]
    
    override func viewDidLoad() {
        let header = UIView()
        header.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height*0.14)
        header.backgroundColor = UIColor(red:0.25, green:0.32, blue:0.71, alpha:1.0)
        
        let headerText = InsetLabel(top: 35, bottom: 0, left: 80, right: 0, rect: CGRect(x: 0, y: 0, width: 500, height: UIScreen.main.bounds.height*0.14))
        headerText.text = "UCSC"
        headerText.font = UIFont(name: "Helvetica", size: 34.0)
        headerText.textColor = UIColor(red: 1.00, green: 0.63, blue: 0.00, alpha: 1.0)
        
        header.addSubview(headerText)
        
        let footer = UIView()
        footer.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height*0.55)
        footer.backgroundColor = UIColor(red:0.01, green:0.47, blue:0.74, alpha:1.0)

        self.tableView.tableHeaderView = header
        self.tableView.tableFooterView = footer
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return BusNames.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SlideOutCell", for: indexPath) as UITableViewCell
        
        cell.textLabel?.text = BusNames[indexPath.row]
        cell.textLabel?.font = UIFont(name: "Helvetica", size: 15.0)
        cell.backgroundColor = UIColor(red:0.01, green:0.53, blue:0.82, alpha:1.0)
        cell.textLabel?.textColor = UIColor.white
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        var url = "https://www.scmtd.com/media/bkg/20172/sched/"
        
        switch (indexPath.row) {
        case 0:
            url += "rte_10.pdf"
            break
        case 1:
            url += "rte_15.pdf"
            break
        case 2:
            url += "rte_16.pdf"
            break
        case 3:
            url += "rte_19.pdf"
            break
        default:
            url += "rte_20.pdf"
        }
        
        UIApplication.shared.openURL(NSURL(string: url) as! URL)
        
        self.revealViewController().revealToggle(animated: true)
    }
    
    class InsetLabel: UILabel {
        var topInset = CGFloat(0)
        var bottomInset = CGFloat(0)
        var leftInset = CGFloat(0)
        var rightInset = CGFloat(0)
        
        init(top: Float, bottom: Float, left: Float, right: Float, rect: CGRect) {
            self.topInset = CGFloat(top)
            self.bottomInset = CGFloat(bottom)
            self.leftInset = CGFloat(left)
            self.rightInset = CGFloat(right)
            super.init(frame: rect)
        }
        
        required init?(coder aDecoder: NSCoder) {
            super.init(coder: aDecoder)
        }
        
        override func drawText(in rect: CGRect) {
            let insets: UIEdgeInsets = UIEdgeInsets(top: topInset, left: leftInset, bottom: bottomInset, right: rightInset)
            
            super.drawText(in: UIEdgeInsetsInsetRect(rect, insets))
        }
        
        override public var intrinsicContentSize: CGSize {
            var intrinsicSuperViewContentSize = super.intrinsicContentSize
            
            intrinsicSuperViewContentSize.height += topInset + bottomInset
            intrinsicSuperViewContentSize.width += leftInset + rightInset
            
            return intrinsicSuperViewContentSize
        }
    }
    
}
