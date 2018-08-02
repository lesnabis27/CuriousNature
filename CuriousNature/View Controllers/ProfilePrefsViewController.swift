//
//  ProfilePrefsViewController.swift
//  CuriousNature
//
//  Created by Sam Richardson on 5/13/18.
//  Copyright © 2018 Sam Richardson. All rights reserved.
//

import Cocoa
import ORSSerial

class ProfilePrefsViewController: NSViewController {

    
    // MARK: - IBOutlets
    @IBOutlet weak var serialPortsPopUp: NSPopUpButton!
    @IBOutlet weak var autosaveFramesCheckbox: NSButton!
    @IBOutlet weak var autosavePathTextField: NSTextField!
    
    // MARK: - IBActions
    @IBAction func serialPortPopUpChanged(_ sender: NSPopUpButton) {
        serialCommunicator.serialPort = ORSSerialPort(path: "/dev/cu.\(sender.titleOfSelectedItem!)")
    }
    @IBAction func autosaveFramesCheckboxChanged(_ sender: NSButton) {
    }
    @IBAction func autosavePathTextFieldChanged(_ sender: NSTextField) {
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        for port in serialPortManager.availablePorts {
            serialPortsPopUp.addItem(withTitle: port.name)
        }
        if let currentPort = serialCommunicator.serialPort {
            if serialPortsPopUp.itemTitles.contains(currentPort.name) {
                serialPortsPopUp.selectItem(withTitle: currentPort.name)
            }
        }
    }
    
}
