//
//  PrefsViewController.swift
//  CuriousNature
//
//  Created by Sam Richardson on 5/13/18.
//  Copyright © 2018 Sam Richardson. All rights reserved.
//

import Cocoa

class PrefsViewController: NSTabViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        NSCursor.unhide()
    }
    
    override func viewDidDisappear() {
        super.viewDidDisappear()
        NSCursor.hide()
    }
    
}
