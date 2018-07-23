//
//  FlockPrefsViewController.swift
//  CuriousNature
//
//  Created by Sam Richardson on 5/13/18.
//  Copyright © 2018 Sam Richardson. All rights reserved.
//

import Cocoa

class FlockPrefsViewController: NSViewController {

    // MARK: - IBOutlets
    
    @IBOutlet weak var populationField: NSTextField!
    @IBOutlet weak var minDepthField: NSTextField!
    @IBOutlet weak var maxDepthField: NSTextField!
    @IBOutlet weak var vineAlphaField: NSTextField!
    @IBOutlet weak var leafAlphaField: NSTextField!
    @IBOutlet weak var saturationRangeLabel: NSTextField!
    @IBOutlet weak var maxSaturationSlider: NSSlider!
    @IBOutlet weak var minSaturationSlider: NSSlider!
    @IBOutlet weak var brightnessRangeLabel: NSTextField!
    @IBOutlet weak var maxBrightnessSlider: NSSlider!
    @IBOutlet weak var minBrightnessSlider: NSSlider!
    
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
        state.vineAlpha = CGFloat(sender.floatValue)
        NotificationCenter.default.post(name: .vineAlphaChanged, object: nil)
    }
    @IBAction func leafAlphaFieldChanged(_ sender: NSTextField) {
        state.leafAlpha = CGFloat(sender.floatValue)
        NotificationCenter.default.post(name: .leafAlphaChanged, object: nil)
    }
    @IBAction func maxSaturationSliderChanged(_ sender: NSSlider) {
        state.maxSaturation = CGFloat(sender.floatValue).truncate(places: 2)
        if state.minSaturation > state.maxSaturation {
            state.minSaturation = state.maxSaturation
            minSaturationSlider.floatValue = Float(state.minSaturation)
        }
        saturationRangeLabel.stringValue = "\(state.minSaturation)-\(state.maxSaturation)"
    }
    @IBAction func minSaturationSliderChanged(_ sender: NSSlider) {
        state.minSaturation = CGFloat(sender.floatValue).truncate(places: 2)
        if state.maxSaturation < state.minSaturation {
            state.maxSaturation = state.minSaturation
            maxSaturationSlider.floatValue = Float(state.maxSaturation)
        }
        saturationRangeLabel.stringValue = "\(state.minSaturation)-\(state.maxSaturation)"
    }
    @IBAction func maxBrightnessSliderChanged(_ sender: NSSlider) {
        state.maxBrightness = CGFloat(sender.floatValue).truncate(places: 2)
        if state.minBrightness > state.maxBrightness {
            state.minBrightness = state.maxBrightness
            minBrightnessSlider.floatValue = Float(state.minBrightness)
        }
        brightnessRangeLabel.stringValue = "\(state.minBrightness)-\(state.maxBrightness)"
    }
    @IBAction func minBrightnessSliderChanged(_ sender: NSSlider) {
        state.minBrightness = CGFloat(sender.floatValue).truncate(places: 2)
        if state.maxBrightness < state.minBrightness {
            state.maxBrightness = state.minBrightness
            maxBrightnessSlider.floatValue = Float(state.minBrightness)
        }
        brightnessRangeLabel.stringValue = "\(state.minBrightness)-\(state.maxBrightness)"
    }
    
    // MARK: - Lifecycle Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        populationField.stringValue = "\(state.population)"
        minDepthField.stringValue = "\(state.minDepth)"
        maxDepthField.stringValue = "\(state.maxDepth)"
        vineAlphaField.stringValue = "\(state.vineAlpha)"
        leafAlphaField.stringValue = "\(state.leafAlpha)"
        saturationRangeLabel.stringValue = "\(state.minSaturation)-\(state.maxSaturation)"
        brightnessRangeLabel.stringValue = "\(state.minBrightness)-\(state.maxBrightness)"
        maxSaturationSlider.floatValue = Float(state.maxSaturation)
        minSaturationSlider.floatValue = Float(state.minSaturation)
        maxBrightnessSlider.floatValue = Float(state.maxBrightness)
        minBrightnessSlider.floatValue = Float(state.minBrightness)
    }
    
}
