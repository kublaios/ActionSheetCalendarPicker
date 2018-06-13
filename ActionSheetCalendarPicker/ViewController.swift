//
//  ViewController.swift
//  ActionSheetCalendarPicker
//
//  Created by Kubilay Erdogan on 11.06.2018.
//  Copyright © 2018 @kublaios. All rights reserved.
//

import UIKit
import LGAlertView
import JTAppleCalendar
import DateToolsSwift

class ViewController: UIViewController {
    @IBOutlet weak var lblSelectedDate: UILabel?
    
    let formatter = DateFormatter()
    var activeSheet: LGAlertView?
    var calendarView: JTAppleCalendarView?
    var dateSelectedOnInit = false
    var selectedDate: Date?

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func selectDate(sender: Any?) {
        // Check if custom view is available
        if let cv = Bundle.main.loadNibNamed("CalendarView", owner: self, options: nil)?.first as? CalendarView {
            self.calendarView = cv.calendarView
            
            // configure the width of the custom view
            cv.widthConstant?.constant = self.view.frame.size.width
            
            // when UICollectionView is inside of a nib file, we are unable to insert a cell through IB (you can try)
            // so we are registering cells separetely
            cv.calendarView?.register(UINib(nibName: "CalendarCell", bundle: nil), forCellWithReuseIdentifier: "CalendarCell")
            
            // setting calendar data source and delegate since we are loading it through a nib file
            cv.calendarView?.calendarDataSource = self
            cv.calendarView?.calendarDelegate = self
            
            // adding some styling
            cv.calendarView?.minimumLineSpacing = 0
            cv.calendarView?.minimumInteritemSpacing = 0
            
            // set date label
            cv.calendarView?.visibleDates({ (visibleDates) in
                guard let date = visibleDates.monthDates.first?.date else { return }
                self.formatter.dateFormat = "MMMM"
                cv.monthLabel?.text = self.formatter.string(from: date)
            })
            
            // set header label and close button action
            cv.headerLabel?.text = "DEPARTURE DATE"
            cv.headerButton?.addTarget(self, action: #selector(self.closePicker(sender:)), for: .touchUpInside)
            
            // select today's date by default
            let selectedDate = self.selectedDate ?? Date()
            cv.calendarView?.selectDates([selectedDate])
            self.dateSelectedOnInit = true // preventing the trigger of didSelectDate event since we select a date (even if programmatically)
            
            // initialize the action sheet
            let aSheet = LGAlertView.init(viewAndTitle: nil, message: nil, style: .actionSheet, view: cv, buttonTitles: nil, cancelButtonTitle: nil, destructiveButtonTitle: nil, delegate: nil)
            aSheet.offsetVertical = 0
            aSheet.cancelButtonOffsetY = 0
            aSheet.layerCornerRadius = 0
            aSheet.width = self.view.frame.size.width
            self.activeSheet = aSheet // set the property to use when close button is tapped
            aSheet.showAnimated()
        } else {
            print("Something is wrong with the custom view")
        }
    }
    
    // MARK: IB helper functions
    @objc func closePicker(sender: Any?) {
        guard let aSheet = self.activeSheet else { return }
        aSheet.dismissAnimated()
    }
    
    // MARK: in-house helper functions
    func handleCellTextColor(cell: JTAppleCell?, cellState: CellState) {
        guard let validCell = cell as? CalendarCell else { return }
        if cellState.isSelected {
            validCell.dateLabel?.textColor = .white
        } else {
            if cellState.date > 1.days.earlier && cellState.dateBelongsTo == .thisMonth {
                validCell.dateLabel?.textColor = .black
            } else {
                validCell.dateLabel?.textColor = .lightGray
            }
        }
    }
    
    func handleCellBackground(cell: JTAppleCell?, cellState: CellState) {
        guard let validCell = cell as? CalendarCell else { return }
        validCell.labelBackground?.isHidden = !cellState.isSelected // bugfix, see https://github.com/patchthecode/JTAppleCalendar/issues/553
    }
}

extension ViewController: LGAlertViewDelegate
{
    func alertViewDidDismiss(_ alertView: LGAlertView) {
        guard let calendar = self.calendarView else { return }
        calendar.deselectAllDates()
    }
}

// MARK: JTAppleCalendarViewDataSource
extension ViewController: JTAppleCalendarViewDataSource
{
    func configureCalendar(_ calendar: JTAppleCalendarView) -> ConfigurationParameters {
        self.formatter.dateFormat = "yyyy MM dd"
        self.formatter.timeZone = Calendar.current.timeZone
        self.formatter.locale = Calendar.current.locale
        
        let calendar = Calendar.current
        var comps = calendar.dateComponents([.year, .month], from: Date()/* today */)
        comps.setValue(1, for: .day) // first day of the month
        let startDate = calendar.date(from: comps)! // start the calendar from current month
        let endDate = formatter.date(from: "2018 12 31")!
        
        let parameters = ConfigurationParameters(startDate: startDate, endDate: endDate, firstDayOfWeek: .monday)
        return parameters
    }
}

// MARK: JTAppleCalendarViewDelegate
extension ViewController: JTAppleCalendarViewDelegate
{
    func calendar(_ calendar: JTAppleCalendarView, willDisplay cell: JTAppleCell, forItemAt date: Date, cellState: CellState, indexPath: IndexPath) {
        print("JTAppleCalendarView willDisplayCell")
    }
    
    func calendar(_ calendar: JTAppleCalendarView, cellForItemAt date: Date, cellState: CellState, indexPath: IndexPath) -> JTAppleCell {
        let cell = calendar.dequeueReusableJTAppleCell(withReuseIdentifier: "CalendarCell", for: indexPath) as! CalendarCell
        cell.dateLabel?.text = cellState.text
        self.handleCellBackground(cell: cell, cellState: cellState)
        self.handleCellTextColor(cell: cell, cellState: cellState)
        return cell
    }
    
    func calendar(_ calendar: JTAppleCalendarView, didSelectDate date: Date, cell: JTAppleCell?, cellState: CellState) {
        self.handleCellBackground(cell: cell, cellState: cellState)
        self.handleCellTextColor(cell: cell, cellState: cellState)
        
        // if this event is fired on init (after us setting the default date)
        if self.dateSelectedOnInit {
            self.dateSelectedOnInit = false
            return
        }
        
        self.selectedDate = date
        self.formatter.dateFormat = "dd MMM yyyy"
        self.lblSelectedDate?.text = self.formatter.string(from: date)
        
        // delay the closing of the picker
        DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(300)) {
            self.closePicker(sender: nil)
        }
    }
    
    func calendar(_ calendar: JTAppleCalendarView, didDeselectDate date: Date, cell: JTAppleCell?, cellState: CellState) {
        self.handleCellBackground(cell: cell, cellState: cellState)
        self.handleCellTextColor(cell: cell, cellState: cellState)
    }
    
    func calendar(_ calendar: JTAppleCalendarView, didScrollToDateSegmentWith visibleDates: DateSegmentInfo) {
        guard let date = visibleDates.monthDates.first?.date else { return }
        guard let cv = calendar.superview as? CalendarView else { return }
        self.formatter.dateFormat = "MMMM"
        cv.monthLabel?.text = self.formatter.string(from: date)
    }
    
    func calendar(_ calendar: JTAppleCalendarView, shouldSelectDate date: Date, cell: JTAppleCell?, cellState: CellState) -> Bool {
        return date >= 1.days.earlier
    }
}
