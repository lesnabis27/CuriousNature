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
    @IBOutlet weak var minDepthField: NSTextField!
    @IBOutlet weak var maxDepthField: NSTextField!
    @IBOutlet weak var vineAlphaField: NSTextField!
    @IBOutlet weak var leafAlphaField: NSTextField!
    @IBOutlet weak var newColorWell: NSColorWell!
    
    // MARK: - IBActions
    
    @IBAction func populationFieldChanged(_ sender: NSTextField) {
        state.population = Int(sender.intValue)
        NotificationCenter.default.post(name: .populationChanged, object: nil)
    }
    @IBAction func minDepthFieldChanged(_ sender: NSTextField) {
        state.minDepth = CGFloat(sender.floatValue)
        NotificationCenter.default.post(name: .depthChanged, object: nil)
    }
    @IBAction func maxDepthFieldChanged(_ sender: NSTextField) {
        state.maxDepth = CGFloat(sender.floatValue)
        NotificationCenter.default.post(name: .depthChanged, object: nil)
    }
    @IBAction func vineAlphaFieldChanged(_ sender: NSTextField) {
    }
    @IBAction func leafAlphaFieldChanged(_ sender: NSTextField) {
    }
    @IBAction func addColor(_ sender: NSButton) {
        colorTableView.reloadData()
    }
    @IBAction func removeColor(_ sender: NSButton) {
        colorTableView.reloadData()
    }
    @IBAction func randomizeColors(_ sender: NSButton) {
        colorTableView.reloadData()
    }
    
    // MARK: - Properties
    
    var colors: [CGColor?] = []
    
    // MARK: - Lifecycle Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        populationField.stringValue = "\(state.population)"
        minDepthField.stringValue = "\(state.minDepth)"
        maxDepthField.stringValue = "\(state.maxDepth)"
    }
    
    // MARK: - Table View
    
    func numberOfRows(in tableView: NSTableView) -> Int {
        return colors.count
    }
    
}
