//
//  SlideOutTableVC.swift
//  Slug_Route
//
//  Created by Jeff on 12/5/16.
//  Copyright © 2016 Jeff. All rights reserved.
//

import Foundation
import SVWebViewController
import ESPullToRefresh
import GoogleAPIClientForREST

class SlideOutViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    private var BusNames = ["Bus 10 - UCSC Via High", "Bus 15 - UCSC Via Laurel West", "Bus 16 - UCSC Via Laurel East", "Bus 19 - UCSC Via Lower Bay", "Bus 20 - UCSC Via Westside"]
    var tableView = UITableView()
    
    private var gymCount = [String]()
    private var gymCountColor = [CGFloat]()
    var gymTableView = UITableView()
    
    //Google Sheet
    private let service = GTLRSheetsService()
    private let apiKey = "AIzaSyDm22uY8J4OXi0hjTmIHIlCg-yhykauhy8"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //Header View Setup
        let headerView = UIView()
        headerView.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height*0.14)
        headerView.backgroundColor = UIColor(red:0.25, green:0.32, blue:0.71, alpha:1.0)
        
        let headerText = InsetLabel(top: 20, bottom: 0, left: 80, right: 0, rect: CGRect(x: 0, y: 0, width: 500, height: UIScreen.main.bounds.height*0.14))
        headerText.text = "UCSC"
        headerText.font = UIFont(name: "Helvetica", size: 34.0)
        headerText.textColor = UIColor(red: 1.00, green: 0.63, blue: 0.00, alpha: 1.0)
        
        headerView.addSubview(headerText)
        
        self.view.addSubview(headerView)
        
        //Table View Setup
        self.tableView = UITableView(frame: CGRect(x: 0, y: headerView.bounds.height, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height))
        
        self.tableView.register(UITableViewCell.self, forCellReuseIdentifier: "SlideOutCell")
        
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.rowHeight = 55.0

        self.view.addSubview(tableView)
        
        //tableview footer
        let footer = UIView()
        footer.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height*0.60)
        footer.backgroundColor = UIColor(red:0.01, green:0.47, blue:0.74, alpha:1.0)
        
        self.tableView.tableFooterView = footer
        
        _ = tableView.es_addPullToRefresh {
            self.listGymLiveCount()
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                self.tableView.es_stopPullToRefresh(completion: true)
            }
        }
        
        //Google SpreadSheet Setup
        service.apiKey = self.apiKey
        
    }

    override func viewDidAppear(_ animated: Bool) {
        //Refresh TableView
        self.tableView.es_startPullToRefresh()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == self.tableView {
            return BusNames.count
        }
        return gymCount.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if tableView == self.tableView {
            let cell = tableView.dequeueReusableCell(withIdentifier: "SlideOutCell", for: indexPath) as UITableViewCell
        
            cell.textLabel?.text = BusNames[indexPath.row]
            cell.textLabel?.font = UIFont(name: "Helvetica", size: 15.0)
            cell.textLabel?.textColor = UIColor.white
            cell.backgroundColor = UIColor(red:0.19, green:0.25, blue:0.62, alpha:1.0)
            return cell
        }
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "SlideOutCellGym", for: indexPath) as UITableViewCell
        
        cell.textLabel?.text = gymCount[indexPath.row]
        //cell.textLabel?.adjustsFontSizeToFitWidth = true
        cell.textLabel?.font = UIFont(name: "Helvetica", size: 10)
        let greenPercentage = self.gymCountColor[indexPath.row]
        
        cell.textLabel?.textColor = UIColor(red: greenPercentage, green: 1-greenPercentage, blue: 0.0, alpha: 1.0)
        
        cell.backgroundColor = UIColor(red:0.05, green:0.28, blue:0.63, alpha:1.0)

        //UIColor(red:0.01, green:0.53, blue:0.82, alpha:1.0)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        var url = "https://www.scmtd.com/media/bkg/20172/sched/"
        var busNum = ""
        
        switch (indexPath.row) {
        case 0:
            url += "rte_10.pdf"
            busNum = "10"
            break
        case 1:
            url += "rte_15.pdf"
            busNum = "15"
            break
        case 2:
            url += "rte_16.pdf"
            busNum = "16"
            break
        case 3:
            url += "rte_19.pdf"
            busNum = "19"
            break
        default:
            url += "rte_20.pdf"
            busNum = "20"
        }
        
        let webViewController = SVModalWebViewController(address: url)
        
        webViewController!.title = "Bus \(busNum)"
        
        self.present(webViewController!, animated: true, completion: nil)
        tableView.deselectRow(at: indexPath, animated: true)
        self.revealViewController().revealToggle(animated: true)
    }
    
    private func listGymLiveCount() {
        let spreadSheetId = "1o1lQ6FFqr6RALPZ6I48cuWDd1clrPOlks8f3sWKx-9s"
        let range = "Live Count Sheet!A36:E"
        
        let query = GTLRSheetsQuery_SpreadsheetsValuesGet.query(withSpreadsheetId: spreadSheetId, range: range)
        
        service.executeQuery(query, delegate: self, didFinish: #selector(self.displayResultWithTicket(ticket:finishedWithObjectResult:error:)))
        
    }
    
    @objc private func displayResultWithTicket(ticket: GTLRServiceTicket, finishedWithObjectResult result: GTLRSheets_ValueRange, error: NSError?) {
        
        if let error = error {
            showAlert(title: "Error", message: error.localizedDescription)
            return
        }
        
        self.gymCount.removeAll()
        
        let gymHeaderView = UIView(frame: CGRect(x: 0, y:0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height*0.4))
    
        self.gymTableView = UITableView(frame: CGRect(x: -10, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height*0.4))
        
        self.gymTableView.isUserInteractionEnabled = false
        
        self.gymTableView.register(UITableViewCell.self, forCellReuseIdentifier: "SlideOutCellGym")
        self.gymTableView.delegate = self
        self.gymTableView.dataSource = self
        
        for row in result.values! {
            let place = "\(row[0])"
            
            var colorMeter = Float()
            var numberOfPeople = "\(row[1])"
            
            if let currNumPeople = Float("\(row[1])") {
            switch(place) {
                case "East Gym" :
                    colorMeter = currNumPeople / 100
                    numberOfPeople += "/100"
                case "Pool" :
                    colorMeter = currNumPeople / 150
                    numberOfPeople += "/150"
                case "Martial Arts Room" :
                    colorMeter = currNumPeople / 40
                    numberOfPeople += "/40"
                case "Activities Room" :
                    colorMeter = currNumPeople / 200
                    numberOfPeople += "/200"
                case "Dance Studio" :
                    colorMeter = currNumPeople / 40
                    numberOfPeople += "/40"
                case "Racquetball Courts" :
                    colorMeter = currNumPeople / 25
                    numberOfPeople += "/25"
                case "Multi-Purpose Room" :
                    colorMeter = currNumPeople / 50
                    numberOfPeople += "/50"
                case "Wellness 1st Floor" :
                    colorMeter = currNumPeople / 140
                    numberOfPeople += "/140"
                case "Wellness 2nd Floor" :
                    colorMeter = currNumPeople / 140
                    numberOfPeople += "/140"
                default: colorMeter = 0.0
                
            }
            }

            self.gymCount.append("\(row[0]): \(numberOfPeople) || \(self.dateFormat(date: row[2] as! String)) \n")
            self.gymCountColor.append(CGFloat(colorMeter))
        }
        
        gymHeaderView.addSubview(self.gymTableView)
        self.tableView.tableHeaderView = gymHeaderView
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let MinHeight = CGFloat(25)
        
        if tableView == self.tableView {
            return self.tableView.rowHeight
        }
        
        let tHeight = tableView.bounds.height
        
        let temp = tHeight/CGFloat(gymCount.count)
        
        return temp > MinHeight ? temp : MinHeight
    }
    
    private func dateFormat(date: String) -> String {
        //Day of the month, Monday, Tuesday, Wednesday...
        let dayIndex = date.index(date.startIndex, offsetBy: 3)
        let day = date.substring(to: dayIndex) + ","
        
        //Month of the year, Jan, Feb, Mar...
        let monthDate = date.components(separatedBy: ",")
        var month = monthDate[1]
        let monthIndex = month.index(month.startIndex, offsetBy: 4)
        
        //Day in the month, 01, 02, 03...
        let monthDay = monthDate[1].components(separatedBy: " ")
        month = month.substring(to: monthIndex) + " " + monthDay[2] + ", 17"
        
        let timeDate = date.components(separatedBy: "2017")
        var time = timeDate[1]
        let timeIndex = time.index(time.startIndex, offsetBy: 4)
        time = time.substring(from: timeIndex)
        
        return day + month + " - " + time
    }
    
    // Helper for showing an alert
    private func showAlert(title : String, message: String) {
        let alert = UIAlertController(
            title: title,
            message: message,
            preferredStyle: .alert
        )
        let ok = UIAlertAction(
            title: "OK",
            style: .default,
            handler: nil
        )
        alert.addAction(ok)
        self.present(alert, animated: true, completion: nil)
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
