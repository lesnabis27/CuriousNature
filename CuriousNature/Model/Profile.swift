//
//  Profile.swift
//  CuriousNature
//
//  Created by Sam Richardson on 5/7/18.
//  Copyright © 2018 Sam Richardson. All rights reserved.
//

//
// Profile stores a preferences configuration
//

import Cocoa

class Profile {
    
    // MARK: - Environment Properties
    var backgroundColor: CGColor // FIX
    var shouldFade: Bool
    var fadeAlpha: CGFloat
    var fadeFrequency: Int
    var xResolution: CGFloat
    var yResolution: CGFloat
    var border: CGFloat
    
    // MARK: - Flock Properties
    var population: Int
    var minDepth: CGFloat
    var maxDepth: CGFloat
    var vineAlpha: CGFloat
    var leafAlpha: CGFloat
    var maxSaturation: CGFloat
    var minSaturation: CGFloat
    var maxBrightness: CGFloat
    var minBrightness: CGFloat
    
    // MARK: - Interaction Properties
    var maximumSpeed: CGFloat
    var maximumForce: CGFloat
    var separationWeight: CGFloat
    var alignmentWeight: CGFloat
    var cohesionWeight: CGFloat
    var activeRange: CGFloat
    var activeRangeSquared: CGFloat
    
    // MARK: - Initializer
    init() {
        backgroundColor = CGColor(gray: 0.0, alpha: 1.0)
        shouldFade = true
        fadeAlpha = 0.005
        fadeFrequency = 17
        xResolution = NSScreen.main!.frame.width
        yResolution = NSScreen.main!.frame.height
        border = 0.0
        population = 30
        minDepth = 0.0
        maxDepth = 5.0
        vineAlpha = 0.2
        leafAlpha = 0.2
        maxSaturation = 1.0
        minSaturation = 0.0
        maxBrightness = 1.0
        minBrightness = 0.0
        maximumSpeed = 10.0
        maximumForce = 0.1
        separationWeight = 1.7
        alignmentWeight = 0.2
        cohesionWeight = 1.5
        activeRange = 75.0
        activeRangeSquared = activeRange * activeRange
    }
    
}
