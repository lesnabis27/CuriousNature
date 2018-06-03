//
//  EnvironmentPrefsViewController.swift
//  CuriousNature
//
//  Created by Sam Richardson on 5/13/18.
//  Copyright © 2018 Sam Richardson. All rights reserved.
//

import Cocoa

class EnvironmentPrefsViewController: NSViewController {

    // MARK: - IBOutlets
    @IBOutlet weak var backgroundColorWell: NSColorWell!
    @IBOutlet weak var fadeCheckbox: NSButton!
    @IBOutlet weak var fadeAlphaTextField: NSTextField!
    @IBOutlet weak var fadeAlphaSlider: NSSlider!
    @IBOutlet weak var fadeFrequencyTextField: NSTextField!
    @IBOutlet weak var fadeFrequencySlider: NSSlider!
    @IBOutlet weak var resolutionPopupButton: NSPopUpButton!
    @IBOutlet weak var xResolutionTextField: NSTextField!
    @IBOutlet weak var yResolutionTextField: NSTextField!
    @IBOutlet weak var borderWidthTextField: NSTextField!
    
    // MARK: - IBActions
    @IBAction func backgroundColorWellChanged(_ sender: NSColorWell) {
        state.backgroundColor = CGColorCodable(color: sender.color.cgColor)
        NotificationCenter.default.post(name: .backgroundColorChanged, object: nil)
    }
    @IBAction func fadeCheckboxChanged(_ sender: NSButton) {
        if sender.state == .on {
            state.shouldFade = true
        } else {
            state.shouldFade = false
        }
        fadeAlphaTextField.isEnabled = state.shouldFade
        fadeAlphaSlider.isEnabled = state.shouldFade
        fadeFrequencyTextField.isEnabled = state.shouldFade
        fadeFrequencySlider.isEnabled = state.shouldFade
    }
    @IBAction func fadeAlphaTextFieldChanged(_ sender: NSTextField) {
        state.fadeAlpha = CGFloat(sender.floatValue)
        fadeAlphaSlider.floatValue = Float(state.fadeAlpha)
    }
    @IBAction func fadeAlphaSliderChanged(_ sender: NSSlider) {
        state.fadeAlpha = CGFloat(sender.floatValue)
        fadeAlphaTextField.stringValue = "\(state.fadeAlpha)"
    }
    @IBAction func fadeFrequencyTextFieldChanged(_ sender: NSTextField) {
        state.fadeFrequency = Int(sender.intValue)
        fadeFrequencySlider.intValue = Int32(state.fadeFrequency)
    }
    @IBAction func fadeFrequencySliderChanged(_ sender: NSSlider) {
        state.fadeFrequency = Int(sender.intValue)
        fadeFrequencyTextField.stringValue = "\(state.fadeFrequency)"
    }
    @IBAction func resolutionPopupButtonChanged(_ sender: NSPopUpButton) {
        switch sender.titleOfSelectedItem! {
            case "Standard":
                state.xResolution = NSScreen.main!.frame.width - state.border * 2
                state.yResolution = NSScreen.main!.frame.height - state.border * 2
                xResolutionTextField.stringValue = "\(state.xResolution + state.border * 2)"
                yResolutionTextField.stringValue = "\(state.yResolution + state.border * 2)"
                xResolutionTextField.isEnabled = false
                yResolutionTextField.isEnabled = false
                NotificationCenter.default.post(name: .resolutionChanged, object: nil)
            case "Retina":
                state.xResolution = NSScreen.main!.frame.width * 2 - state.border * 2
                state.yResolution = NSScreen.main!.frame.height * 2 - state.border * 2
                xResolutionTextField.stringValue = "\(state.xResolution + state.border * 2)"
                yResolutionTextField.stringValue = "\(state.yResolution + state.border * 2)"
                xResolutionTextField.isEnabled = false
                yResolutionTextField.isEnabled = false
                NotificationCenter.default.post(name: .resolutionChanged, object: nil)
            default:
                xResolutionTextField.isEnabled = true
                yResolutionTextField.isEnabled = true
        }
    }
    @IBAction func xResolutionTextFieldChanged(_ sender: NSTextField) {
        state.xResolution = CGFloat(sender.floatValue) - state.border * 2
        NotificationCenter.default.post(name: .resolutionChanged, object: nil)
    }
    @IBAction func yResolutionTextFieldChanged(_ sender: NSTextField) {
        state.yResolution = CGFloat(sender.floatValue) - state.border * 2
        NotificationCenter.default.post(name: .resolutionChanged, object: nil)
    }
    @IBAction func borderWidthTextFieldChanged(_ sender: NSTextField) {
        state.border = CGFloat(sender.floatValue)
        state.xResolution = state.xResolution - state.border * 2
        state.yResolution = state.yResolution - state.border * 2
        NotificationCenter.default.post(name: .resolutionChanged, object: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Update controls to correct states
        backgroundColorWell.color = state.backgroundColor.toNSColor()
        fadeAlphaTextField.stringValue = "\(state.fadeAlpha)"
        fadeAlphaSlider.floatValue = Float(state.fadeAlpha)
        fadeFrequencyTextField.stringValue = "\(state.fadeFrequency)"
        fadeFrequencySlider.floatValue = Float(state.fadeFrequency)
        
        // Resolution controls
        xResolutionTextField.stringValue = "\(state.xResolution + state.border * 2)"
        yResolutionTextField.stringValue = "\(state.yResolution + state.border * 2)"
        if state.xResolution + state.border * 2 == NSScreen.main!.frame.width && state.yResolution + state.border * 2 == NSScreen.main!.frame.height {
            resolutionPopupButton.selectItem(withTitle: "Standard")
            xResolutionTextField.isEnabled = false
            yResolutionTextField.isEnabled = false
        } else if state.xResolution + state.border * 2 == NSScreen.main!.frame.width * 2 && state.yResolution + state.border * 2 == NSScreen.main!.frame.height * 2 {
            resolutionPopupButton.selectItem(withTitle: "Retina")
            xResolutionTextField.isEnabled = false
            yResolutionTextField.isEnabled = false
        } else {
            resolutionPopupButton.selectItem(withTitle: "Custom")
            xResolutionTextField.isEnabled = true
            yResolutionTextField.isEnabled = true
        }
        borderWidthTextField.stringValue = "\(state.border)"
        
        // Enable or disable controls
        if state.shouldFade {
            fadeCheckbox.state = .on
        } else {
            fadeCheckbox.state = .off
        }
        fadeAlphaTextField.isEnabled = state.shouldFade
        fadeAlphaSlider.isEnabled = state.shouldFade
        fadeFrequencyTextField.isEnabled = state.shouldFade
        fadeFrequencySlider.isEnabled = state.shouldFade
    }
    
}
