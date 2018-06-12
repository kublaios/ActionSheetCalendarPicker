//
//  ViewController.swift
//  ActionSheetCalendarPicker
//
//  Created by Kubilay Erdogan on 11.06.2018.
//  Copyright © 2018 @kublaios. All rights reserved.
//

import UIKit
import LGAlertView

class ViewController: UIViewController {

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

