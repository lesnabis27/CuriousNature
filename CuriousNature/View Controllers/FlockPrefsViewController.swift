//
//  FlockPrefsViewController.swift
//  CuriousNature
//
//  Created by Sam Richardson on 5/13/18.
//  Copyright © 2018 Sam Richardson. All rights reserved.
//

import Cocoa

class FlockPrefsViewController: NSViewController, NSTableViewDelegate, NSTableViewDataSource {

    // MARK: - IBOutlets
    
    @IBOutlet weak var colorTableView: NSTableView!
    @IBOutlet weak var populationField: NSTextField!
    @IBOutlet weak var newColorWell: NSColorWell!
    
    // MARK: - IBActions
    
    @IBAction func populationFieldChanged(_ sender: Any) {
    }
    @IBAction func addColor(_ sender: Any) {
        colorTableView.reloadData()
    }
    @IBAction func removeColor(_ sender: Any) {
        colorTableView.reloadData()
    }
    @IBAction func randomizeColors(_ sender: Any) {
        colorTableView.reloadData()
    }
    
    // MARK: - Properties
    
    var colors: [CGColor?] = []
    
    // MARK: - Lifecycle Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    // MARK: - Table View
    
    func numberOfRows(in tableView: NSTableView) -> Int {
        return colors.count
    }
    
}
