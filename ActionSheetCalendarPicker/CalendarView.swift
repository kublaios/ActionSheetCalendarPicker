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
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}
