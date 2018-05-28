//
//  InteractionsPrefsViewController.swift
//  CuriousNature
//
//  Created by Sam Richardson on 5/13/18.
//  Copyright © 2018 Sam Richardson. All rights reserved.
//

import Cocoa

class InteractionsPrefsViewController: NSViewController {

    // MARK: - IBOutlets
    @IBOutlet weak var speedLimitTextField: NSTextField!
    @IBOutlet weak var forceLimitTextField: NSTextField!
    @IBOutlet weak var separationTextField: NSTextField!
    @IBOutlet weak var separationSlider: NSSlider!
    @IBOutlet weak var cohesionTextField: NSTextField!
    @IBOutlet weak var cohesionSlider: NSSlider!
    @IBOutlet weak var alignmentTextField: NSTextField!
    @IBOutlet weak var alignmentSlider: NSSlider!
    @IBOutlet weak var rangeTextField: NSTextField!
    
    // MARK: - IBActions
    @IBAction func speedLimitTextFieldChanged(_ sender: NSTextField) {
        state.maximumSpeed = CGFloat(sender.floatValue)
    }
    @IBAction func forceLimitTextFieldChanged(_ sender: NSTextField) {
        state.maximumForce = CGFloat(sender.floatValue)
    }
    @IBAction func separationTextFieldChanged(_ sender: NSTextField) {
        state.separationWeight = CGFloat(sender.floatValue)
        separationSlider.floatValue = sender.floatValue
    }
    @IBAction func separationSliderChanged(_ sender: NSSlider) {
        state.separationWeight = CGFloat(sender.floatValue)
        separationTextField.stringValue = sender.stringValue
    }
    @IBAction func cohesionTextFieldChanged(_ sender: NSTextField) {
        state.cohesionWeight = CGFloat(sender.floatValue)
        cohesionSlider.floatValue = sender.floatValue
    }
    @IBAction func cohesionSliderChanged(_ sender: NSSlider) {
        state.cohesionWeight = CGFloat(sender.floatValue)
        cohesionTextField.stringValue = sender.stringValue
    }
    @IBAction func alignmentTextFieldChanged(_ sender: NSTextField) {
        state.alignmentWeight = CGFloat(sender.floatValue)
        alignmentSlider.floatValue = sender.floatValue
    }
    @IBAction func alignmentSliderChanged(_ sender: NSSlider) {
        state.alignmentWeight = CGFloat(sender.floatValue)
        alignmentTextField.stringValue = sender.stringValue
    }
    @IBAction func rangeTextFieldChanged(_ sender: NSTextField) {
        state.activeRange = CGFloat(sender.floatValue)
        state.activeRangeSquared = CGFloat(sender.floatValue * sender.floatValue)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Initialize controls to correct states
        speedLimitTextField.stringValue = "\(state.maximumSpeed)"
        forceLimitTextField.stringValue = "\(state.maximumForce)"
        separationTextField.stringValue = "\(state.separationWeight)"
        separationSlider.floatValue = Float(state.separationWeight)
        cohesionTextField.stringValue = "\(state.cohesionWeight)"
        cohesionSlider.floatValue = Float(state.cohesionWeight)
        alignmentTextField.stringValue = "\(state.alignmentWeight)"
        alignmentSlider.floatValue = Float(state.alignmentWeight)
        rangeTextField.stringValue = "\(state.activeRange)"
    }
    
}
