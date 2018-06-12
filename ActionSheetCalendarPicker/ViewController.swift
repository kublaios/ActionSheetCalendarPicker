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

class ViewController: UIViewController {
    let formatter = DateFormatter()

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
            // configure the width of the custom view
            cv.widthConstant?.constant = self.view.frame.size.width
            
            // when UICollectionView is inside of a nib file, we are unable to insert a cell through IB (you can try)
            // so we are registering cells separetely
            cv.calendarView?.register(UINib(nibName: "CalendarCell", bundle: nil), forCellWithReuseIdentifier: "CalendarCell")
            
            // setting calendar data source and delegate since we are loading it through a nib file
            cv.calendarView?.calendarDataSource = self
            cv.calendarView?.calendarDelegate = self
            
            // initialize the action sheet
            let aSheet = LGAlertView.init(viewAndTitle: nil, message: nil, style: .actionSheet, view: cv, buttonTitles: nil, cancelButtonTitle: nil, destructiveButtonTitle: nil, delegate: nil)
            aSheet.offsetVertical = 0
            aSheet.cancelButtonOffsetY = 0
            aSheet.layerCornerRadius = 0
            aSheet.width = self.view.frame.size.width
            aSheet.showAnimated()
        } else {
            print("Something is wrong with the custom view")
        }
    }
    
}

extension ViewController: JTAppleCalendarViewDelegate, JTAppleCalendarViewDataSource
{
    func calendar(_ calendar: JTAppleCalendarView, willDisplay cell: JTAppleCell, forItemAt date: Date, cellState: CellState, indexPath: IndexPath) {
        print("JTAppleCalendarView willDisplayCell")
    }
    
    func configureCalendar(_ calendar: JTAppleCalendarView) -> ConfigurationParameters {
        self.formatter.dateFormat = "yyyy MM dd"
        self.formatter.timeZone = Calendar.current.timeZone
        self.formatter.locale = Calendar.current.locale
        
        let startDate = formatter.date(from: "2018 01 01")!
        let endDate = formatter.date(from: "2018 12 31")!
        
        let parameters = ConfigurationParameters(startDate: startDate, endDate: endDate)
        return parameters
    }
    
    func calendar(_ calendar: JTAppleCalendarView, cellForItemAt date: Date, cellState: CellState, indexPath: IndexPath) -> JTAppleCell {
        let cell = calendar.dequeueReusableJTAppleCell(withReuseIdentifier: "CalendarCell", for: indexPath) as! CalendarCell
        cell.dateLabel?.text = cellState.text
        return cell
    }
}
