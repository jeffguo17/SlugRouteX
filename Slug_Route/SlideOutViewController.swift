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
    
    private var gymCountPeople = [String]()
    private var gymCountTime = [String]()
    private var gymCountColor = [CGFloat]()
    private var gymCountValidTime = [Bool]()
    var gymTableView = UITableView()
    var lastUpdateTime = Date()
    var lastResult = [String]()
    var showTutorial = true
    
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
        
        //Google SpreadSheet Setup
        service.apiKey = self.apiKey
        
        
        //GYM TableView setup
        let gymHeaderView = UIView(frame: CGRect(x: 0, y:0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height*0.6))
        
        self.gymTableView = UITableView(frame: CGRect(x: -12, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height*0.6))
        
        self.gymTableView.isUserInteractionEnabled = false
        
        self.gymTableView.register(UITableViewCell.self, forCellReuseIdentifier: "SlideOutCellGym")
        self.gymTableView.delegate = self
        self.gymTableView.dataSource = self
        
        self.gymTableView.tableFooterView = UIView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 1))
        
        gymHeaderView.addSubview(self.gymTableView)
        
        self.tableView.tableHeaderView = gymHeaderView
        
        //Refresh Tableview Setup
        _ = tableView.es_addPullToRefresh {
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                self.listGymLiveCount()
            }
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        //Refresh TableView
        self.tableView.es_startPullToRefresh()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == self.tableView {
            return BusNames.count
        }
        return gymCountPeople.count
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
        
        //Gym TableView
        let cell = tableView.dequeueReusableCell(withIdentifier: "SlideOutCellGym", for: indexPath) as UITableViewCell
        
        //GymTableView String
        let gymCountString = gymCountPeople[indexPath.row] + "    " + gymCountTime[indexPath.row] + "\n"
        
        //GymTableView String Font
        let gymCountAttriString = NSMutableAttributedString(string: "\(gymCountString)", attributes: [NSFontAttributeName: UIFont(name: "Helvetica", size: 10.0)!])
        
        //GymTableView TimeTextColor
        var timeTextColor = UIColor.green
        if !gymCountValidTime[indexPath.row] {
            timeTextColor = UIColor.red
        }
        
        //GymTableView Time color Setup
        gymCountAttriString.addAttribute(NSForegroundColorAttributeName, value: timeTextColor, range: .init(location: gymCountPeople[indexPath.row].characters.count, length: gymCountString.characters.count-gymCountPeople[indexPath.row].characters.count))
        
        //GymTableView Number of People color Setup
        let greenPercentage = self.gymCountColor[indexPath.row]
        
        gymCountAttriString.addAttribute(NSForegroundColorAttributeName, value: UIColor(red: greenPercentage, green: 1-greenPercentage, blue: 0.0, alpha: 1.0), range: .init(location: 0, length: gymCountPeople[indexPath.row].characters.count))
        
        
        cell.textLabel?.attributedText = gymCountAttriString
        
        cell.backgroundColor = UIColor(red:0.05, green:0.28, blue:0.63, alpha:1.0)
        
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
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if tableView == self.gymTableView {
            self.tableView.es_stopPullToRefresh(completion: true)
        }
    }
    
    private func listGymLiveCount() {
        if showTutorial {
            self.showAlert(title: "Live Facility Counts", message: "Facility: Participants/Max Capacity\nRed text = Last update was 3+ hours ago \n\nFacility counts are typically posted every hour, and wellness center counts are posted every 30 minutes.")
            showTutorial = false
        }
        
        //Allow user to update every 3 minutes only
        let now = Date()
        if now >= lastUpdateTime {
            lastUpdateTime = now.addingTimeInterval(3.0 * 60.0)
        } else {
            self.tableView.es_stopPullToRefresh(completion: true)
            return
        }
        
        let spreadSheetId = "1o1lQ6FFqr6RALPZ6I48cuWDd1clrPOlks8f3sWKx-9s"
        let range = "Live Count Sheet!A36:E"
        
        let query = GTLRSheetsQuery_SpreadsheetsValuesGet.query(withSpreadsheetId: spreadSheetId, range: range)
        
        service.executeQuery(query, delegate: self, didFinish: #selector(self.displayResultWithTicket(ticket:finishedWithObjectResult:error:)))
    }
    
    @objc private func displayResultWithTicket(ticket: GTLRServiceTicket, finishedWithObjectResult result: GTLRSheets_ValueRange, error: NSError?) {
        
        if let error = error {
            self.tableView.es_stopPullToRefresh(completion: true)
            showAlert(title: "Error", message: error.localizedDescription)
            return
        }
        
        self.gymCountPeople.removeAll()
        self.gymCountTime.removeAll()
        self.gymCountValidTime.removeAll()
        self.gymCountColor.removeAll()
        
        for row in result.values! {
            
            var colorMeter = Float()
            var numberOfPeople = "0"
            
            if let _ = row[optional: 0], let _ = row[optional: 1], let currNumPeople = Float("\(row[1])") {
                
                let place = "\(row[0])"
                numberOfPeople = "\(row[1])"
                
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
                    colorMeter = currNumPeople / 40
                    numberOfPeople += "/40"
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
                
                //Data: Number of People
                self.gymCountPeople.append("\(row[0]): \(numberOfPeople)")
            }
            
            var gymTime = ""
            if let _ = row[optional: 2] {
                gymTime = "\(row[2])"
                
                if let time = self.dateFormat(date: "\(row[2])") {
                    gymTime = time
                }
                
                //Check if current Gym data has a relevant time
                self.gymCountValidTime.append(self.checkValidTime(gymDate: "\(row[2])"))
            }
            
            
            //Data: time
            self.gymCountTime.append("\(gymTime)")
            //Color meter for number of people, ranging from bright green to bright red
            self.gymCountColor.append(CGFloat(colorMeter))
        }
        
        self.gymTableView.reloadData()
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let MinHeight = CGFloat(25)
        
        if tableView == self.tableView {
            return self.tableView.rowHeight
        }
        
        let tHeight = tableView.bounds.height
        
        let temp = tHeight/CGFloat(gymCountPeople.count)
        
        return temp > MinHeight ? temp : MinHeight
    }
    
    private func dateFormat(date: String) -> String? {
        var dateFormat = ""
        
        // If there are more than two commas, get the day "Monday, March"
        if date.components(separatedBy: ",").count >= 3 {
            if let gymDay = self.getGymDay(date: date) {
                dateFormat += gymDay + ", "
            }
        }
        
        if let gymMonth = self.getGymMonth(date: date) {
            dateFormat += gymMonth + " "
        }
        
        if let gymMonthDay = self.getGymMonthDay(date: date) {
            dateFormat += gymMonthDay + ", 17"
        }
        
        if let gymTime = self.getGymTime(date: date) {
            dateFormat += " - " + gymTime
        }
        
        if dateFormat == "" {
            return nil
        }
        
        return dateFormat
    }
    
    private func getGymDay(date: String) -> String? {
        //Day of the month, Monday, Tuesday, Wednesday...
        if let dayIndex = date.index(date.startIndex, offsetBy: 3, limitedBy: date.endIndex) {
            return date.substring(to: dayIndex)
        }
        return nil
    }
    
    private func getGymMonth(date: String) -> String? {
        //Month of the year, Jan, Feb, Mar...
        let monthDate = date.components(separatedBy: ",")
        
        //If there are 2 commas, that means "Friday, March", otherwise, "March".
        let commaCount = monthDate.count - 2
        
        guard let _ = monthDate[optional: commaCount] else {
            return nil
        }
        var month = monthDate[optional: commaCount]!
        
        //Check if there the first character is an empty space
        let emptySpaceIndex = month.index(month.startIndex, offsetBy: 0)
        if month[emptySpaceIndex] == " " {
            let emptySpace = month.components(separatedBy: " ")
            if let m = emptySpace[optional: 1] {
                month = m
            }
        }
        
        if let monthIndex = month.index(month.startIndex, offsetBy: 3, limitedBy: month.endIndex) {
            return month.substring(to: monthIndex)
        }
        
        return nil
    }
    
    private func getGymMonthDay(date: String) -> String? {
        let monthDate = date.components(separatedBy: ",")
        //Day of the month, 01, 02, 03...
        
        //If there are 2 commas, that means "Friday, March", otherwise, "March".
        let commaCount = monthDate.count - 2
        
        if let monthDay = monthDate[optional: commaCount]?.components(separatedBy: " "), let m = monthDay[optional: monthDay.count-1] {
            return m
        }
        
        return nil
    }
    
    private func getGymTime(date: String) -> String? {
        let timeDate = date.components(separatedBy: "2017")
        
        guard let _ = timeDate[optional: 1] else {
            return nil
        }
        
        let time = timeDate[optional: 1]!
        let emptySpace = time.components(separatedBy: " ")
        
        //1:20: .. 3:45:
        if let timeNum = emptySpace[optional: emptySpace.count-2], let meridies = emptySpace[optional: emptySpace.count-1] {
            
            let seperateByColon = timeNum.components(separatedBy: ":")
            return seperateByColon[0] + ":" + seperateByColon[1] + " " + meridies
        }
        
        return nil
    }
    
    //Helper for checking if gym data has revelant time
    //If its 3 hours or more, return false
    private func checkValidTime(gymDate : String) -> Bool {
        guard let _ = self.getGymMonth(date: gymDate) , let _ = self.getGymMonthDay(date: gymDate) ,
            let _ = self.getGymTime(date: gymDate) else {
                return false
        }
        
        let dateFormatter = DateFormatter()
        
        dateFormatter.dateFormat = "h: mm"
        dateFormatter.dateStyle = .medium
        dateFormatter.timeStyle = .short
        dateFormatter.timeZone = TimeZone(identifier: "PST")
        
        //Current Time Setup
        let currentTime = dateFormatter.string(from: Date())
        
        let seperateByComma = currentTime.components(separatedBy: ",")
        let monthAndDay = seperateByComma[0]
        let time = seperateByComma[2]
        
        let emptySpace = time.components(separatedBy: " ")
        let meridies = emptySpace[emptySpace.count-1]
        
        let colon = emptySpace[emptySpace.count-2].components(separatedBy: ":")
        let hour : Int? = Int(colon[0])
        
        //Gym Time Setup
        let gymMonthAndDay = self.getGymMonth(date: gymDate)! + " " + self.getGymMonthDay(date: gymDate)!
        let gymTime = " " + self.getGymTime(date: gymDate)!
        
        let gymEmptySpace = gymTime.components(separatedBy: " ")
        let gymMeridies = gymEmptySpace[gymEmptySpace.count-1]
        
        let gymColon = gymEmptySpace[gymEmptySpace.count-2].components(separatedBy: ":")
        let gymHour : Int? = Int(gymColon[0])
        
        //Check if current time and Gym time are 3 hours apart
        if gymMonthAndDay != monthAndDay {
            return false
        }
        
        if var currHour = hour, var gHour = gymHour {
            //Converting standard hour to military hour
            if meridies == "PM" && currHour != 12 {
                currHour += 12
            }
            if gymMeridies == "PM" && gHour != 12 {
                gHour += 12
            }
            
            if abs(currHour - gHour) >= 3 {
                return false
            }
        }
        
        return true
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

extension Collection where Indices.Iterator.Element == Index {
    // Returns the element iff its within the bounds, else return nil
    subscript (optional index: Index) -> Generator.Element? {
        return indices.contains(index) ? self[index] : nil
    }
}
