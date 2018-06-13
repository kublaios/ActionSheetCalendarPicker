//
//  CalendarView.swift
//  ActionSheetCalendarPicker
//
//  Created by Kubilay Erdogan on 12.06.2018.
//  Copyright © 2018 @kublaios. All rights reserved.
//

import Foundation
import UIKit
import JTAppleCalendar

class CalendarView: UIView
{
    @IBOutlet weak var widthConstant: NSLayoutConstraint?
    @IBOutlet weak var calendarView: JTAppleCalendarView?
    @IBOutlet weak var monthLabel: UILabel?
    @IBOutlet weak var headerLabel: UILabel?
    @IBOutlet weak var headerButton: UIButton?
    @IBOutlet weak var day1: UILabel?
    @IBOutlet weak var day2: UILabel?
    @IBOutlet weak var day3: UILabel?
    @IBOutlet weak var day4: UILabel?
    @IBOutlet weak var day5: UILabel?
    @IBOutlet weak var day6: UILabel?
    @IBOutlet weak var day7: UILabel?
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.day1?.text = "Mon"
        self.day2?.text = "Tue"
        self.day3?.text = "Wed"
        self.day4?.text = "Thu"
        self.day5?.text = "Fri"
        self.day6?.text = "Sat"
        self.day7?.text = "Sun"
    }
}
