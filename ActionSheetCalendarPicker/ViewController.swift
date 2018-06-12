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
        let alertView = LGAlertView.init(viewAndTitle: nil, message: nil, style: .actionSheet, view: nil, buttonTitles: nil, cancelButtonTitle: nil, destructiveButtonTitle: nil, delegate: nil)
        alertView.offsetVertical = 0
        alertView.cancelButtonOffsetY = 0
        alertView.layerCornerRadius = 0
        alertView.width = self.view.frame.size.width
        alertView.showAnimated()
    }
    
}

