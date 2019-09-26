//
//  ProfileCalender.swift
//  Profile
//
//  Created by HIPL-GLOBYLOG on 8/16/19.
//  Copyright © 2019 learning. All rights reserved.
//

import UIKit


protocol CalenderSelectDelegate: class {
    func updateCalenderSelectionDate(date_sel: Date , date_type: String)
}

import UIKit
import JTAppleCalendar
class ProfileCalender: UIViewController {
    @IBOutlet weak var currentDateTxt: UILabel!
    
    @IBOutlet weak var dateTypeTitle: UILabel!
    
    @IBOutlet weak var dateTypeLabel: UILabel!
    var startDate: String?
    var startDateTtl: String?
    var selectedDate: Date?
    var selectedDate_start: Date?
    var selectedDate_end: Date?
    var requestDate_start: Date?
    var requestDate_end: Date?
    weak var delegateDateUpdate: CalenderSelectDelegate!
   // var adminRule = AdminRuleResponse.getInstance()
    @IBOutlet weak var calendarView: JTAppleCalendarView!
    override func viewDidLoad() {
        super.viewDidLoad()
        if let dat = selectedDate {
            dateTypeLabel.text = DateUtil.convertDateToString(date: dat, reqFormat: DateUtil.CalDate_FORMAT)
            
        }
        self.setupCalendarView()
        // Do any additional setup after loading the view.
    }
    @IBAction func onBack(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    @IBAction func OkBtnClicked(){
        if startDateTtl == "end" {
            selectedDate_end = selectedDate
        }
        else if startDateTtl == "start" {
            selectedDate_start = selectedDate
        }
        
        if selectedDate_start != nil && selectedDate_end != nil {
            
            if selectedDate_end!.isBeforeDate(selectedDate_start!) {
                DataUtil.alertMessage("Trip Start Date can not be greater than End Date", viewController: self)
              //  showalert(title: "", message: "Trip Start Date can not be greater than End Date")
                return
            }
            
            
        }
        
        if let selDate = selectedDate {
            delegateDateUpdate.updateCalenderSelectionDate(date_sel: selDate, date_type: startDateTtl ?? "start")
            self.dismiss(animated: true, completion: nil)
        }
        else {
            DataUtil.alertMessage("Travel Plan Already Exist for given dates", viewController:self )
            
          //  showalert(title: "Tess360", message: )
        }
        
    }
    func setupCalendarView(){
        
        calendarView.minimumLineSpacing = 0
        calendarView.minimumInteritemSpacing = 0
        var showDate = Date()
        
        if let dat = selectedDate {
            showDate = dat
        }
        
        calendarView.scrollToDate(showDate, triggerScrollToDateDelegate: false, animateScroll: false, preferredScrollPosition: nil, extraAddedOffset: 0) {
            
        }
        calendarView.visibleDates{ (visibleDates) in
            let date = visibleDates.monthDates.first!.date
            
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "MMMM yyyy"
            self.currentDateTxt.text = dateFormatter.string(from: date)
            
            
        }
    }
    
    @IBAction func nextAction(_ sender: Any) {
        calendarView.scrollToSegment(.next)
    }
    
    @IBAction func previousAction(_ sender: Any) {
        calendarView.scrollToSegment(.previous)
    }
}

extension ProfileCalender: JTAppleCalendarViewDelegate, JTAppleCalendarViewDataSource{
    
    func calendar(_ calendar: JTAppleCalendarView, willDisplay cell: JTAppleCell, forItemAt date: Date, cellState: CellState, indexPath: IndexPath) {
        
        
    }
    
    func configureCalendar(_ calendar: JTAppleCalendarView) -> ConfigurationParameters {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        dateFormatter.timeZone = Calendar.current.timeZone
        dateFormatter.locale = Calendar.current.locale
        let startDate = DateUtil.lastTwoYearsDate()
        let endDate = DateUtil.next200YearsDate()
        let configuration = ConfigurationParameters(startDate: startDate, endDate: endDate)
        return configuration
    }
    func calendar(_ calendar: JTAppleCalendarView, didDeselectDate date: Date, cell: JTAppleCell?, cellState: CellState){
        
        guard let myCustomCell = cell as? CalendarCellProfile  else { return }
        
        myCustomCell.selectedView.isHidden = true
    }
    
    func calendar(_ calendar: JTAppleCalendarView, didSelectDate date: Date, cell: JTAppleCell?, cellState: CellState) {
        if requestDate_start != nil && requestDate_end != nil {
            if date.isBeforeDate(requestDate_start!) ||  date.isAfterDate(requestDate_end!) {
                return
            }
        }
        else if requestDate_start != nil && requestDate_end == nil {
            if date.isBeforeDate(requestDate_start!) {
                return
            }
        }
        else if requestDate_start == nil && requestDate_end != nil {
            if date.isAfterDate(requestDate_end!) {
                return
            }
        }
        if selectedDate_start != nil && date.isBeforeDate(selectedDate_start!) && startDateTtl == "end"{
            DataUtil.alertMessage("Trip End Date can not be less than Start Date", viewController: self)
            return
        }
        
        

        
        let cDate = DateUtil.convertDateToString(date: date, reqFormat: DateUtil.CalDate_FORMAT)
        self.dateTypeLabel.text = cDate
        selectedDate = date
        
        guard let myCustomCell = cell as? CalendarCellProfile  else { return }
        
        myCustomCell.selectedView.isHidden = false
        
        
    }
    
    func calendar(_ calendar: JTAppleCalendarView, cellForItemAt date: Date, cellState: CellState, indexPath: IndexPath) -> JTAppleCell {
        let cell = calendar.dequeueReusableJTAppleCell(withReuseIdentifier: "CalendarCellProfile", for: indexPath) as! CalendarCellProfile
        
        cell.dateLabel.text = cellState.text
        cell.backView.backgroundColor = UIColor.white
        cell.tripCommentTxt.text = ""
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM"
        let datestr = dateFormatter.string(from: date) + "-" + cellState.text
        dateFormatter.dateFormat = "yyyy-MM-dd"
        
        
        let calendarDate = dateFormatter.date(from: datestr)!
       // let loginUserId = DefaultsUtil.getUserId()
        
        if ( dateFormatter.string(from: calendarDate) == dateFormatter.string(from: Date()) ){
            cell.dateLabel.textColor = UIColor.red
        }else{
            if ( cellState.dateBelongsTo == .thisMonth){
                cell.dateLabel.textColor = UIColor.black
            }else{
                cell.dateLabel.textColor = UIColor.lightGray
            }
        }
        
        if cellState.isSelected{
            cell.selectedView.isHidden = false
        }
        else {
            cell.selectedView.isHidden = true
        }
        if requestDate_start != nil && requestDate_end != nil {
            
            if date.isBeforeDate(requestDate_start!) ||  date.isAfterDate(requestDate_end!) {
                cell.dateLabel.textColor = UIColor.lightGray
            }
        }
        else if requestDate_start != nil && requestDate_end == nil {
            if date.isBeforeDate(requestDate_start!) {
                cell.dateLabel.textColor = UIColor.lightGray
            }
        }
        else if requestDate_start == nil && requestDate_end != nil {
            if date.isAfterDate(requestDate_end!) {
                cell.dateLabel.textColor = UIColor.lightGray
            }
        }
        
        return cell
    }
    
    func calendar(_ calendar: JTAppleCalendarView, didScrollToDateSegmentWith visibleDates: DateSegmentInfo) {
        let date = visibleDates.monthDates.first!.date
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMMM yyyy"
        self.currentDateTxt.text = dateFormatter.string(from: date)
    }
}

extension Date {
    func isSameDate(_ comparisonDate: Date) -> Bool {
        let order = Calendar.current.compare(self, to: comparisonDate, toGranularity: .day)
        return order == .orderedSame
    }
    
    func isBeforeDate(_ comparisonDate: Date) -> Bool {
        let order = Calendar.current.compare(self, to: comparisonDate, toGranularity: .day)
        return order == .orderedAscending
    }
    
    func isAfterDate(_ comparisonDate: Date) -> Bool {
        let order = Calendar.current.compare(self, to: comparisonDate, toGranularity: .day)
        return order == .orderedDescending
    }
}

class CalendarCellProfile: JTAppleCell {
    
    @IBOutlet weak var tripCommentTxt: UILabel!
    @IBOutlet weak var backView: UIView!
    @IBOutlet weak var selectedView: UIView!
    @IBOutlet weak var dateLabel: UILabel!
}


@IBDesignable
class RoundButton: UIButton {
    
    @IBInspectable var cornerRadius: CGFloat = 0 {
        didSet {
            self.layer.cornerRadius = cornerRadius
        }
    }
    
    @IBInspectable var borderWidth: CGFloat = 0 {
        didSet {
            self.layer.borderWidth = borderWidth
        }
    }
    
    @IBInspectable var borderColor: UIColor = UIColor.clear {
        didSet {
            self.layer.borderColor = borderColor.cgColor
        }
        
    }
    // For shadow
    @IBInspectable public var shadowOpacity: CGFloat = 0
    @IBInspectable public var shadowColor: UIColor = UIColor.clear
    @IBInspectable public var shadowRadius: CGFloat = 0
    @IBInspectable public var shadowOffset: CGSize = CGSize(width: 0, height: 0)
    
}
