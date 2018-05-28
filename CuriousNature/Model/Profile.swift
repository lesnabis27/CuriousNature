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

class Profile: Codable {
    
    // MARK: - Environment Properties
    var backgroundColor: CGColorCodable
    var shouldFade: Bool
    var fadeAlpha: CGFloat
    var fadeFrequency: Int
    var xResolution: CGFloat
    var yResolution: CGFloat
    
    // MARK: - Flock Properties
    var population: Int
    var colors: [CGColorCodable]
    
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
        backgroundColor = CGColorCodable(color: CGColor(gray: 0.0, alpha: 1.0))
        shouldFade = true
        fadeAlpha = 0.01
        fadeFrequency = 5
        xResolution = NSScreen.main!.frame.width
        yResolution = NSScreen.main!.frame.height
        population = 30
        colors = Array(count: 30) { CGColorCodable(color: CGColor.random()) }
        maximumSpeed = 10.0
        maximumForce = 0.1
        separationWeight = 1.0
        alignmentWeight = 1.7
        cohesionWeight = 1.5
        activeRange = 50.0
        activeRangeSquared = activeRange * activeRange
    }
    
    init(backgroundColor: CGColor, shouldFade: Bool, fadeAlpha: CGFloat, fadeFrequency: Int, xResolution: CGFloat, yResolution: CGFloat, population: Int, colors: [CGColor], alpha: CGFloat, maximumDepth: CGFloat, minimumDepth: CGFloat, maximumSpeed: CGFloat, maximumForce: CGFloat, separationWeight: CGFloat, alignmentWeight: CGFloat, cohesionWeight: CGFloat, activeRange: CGFloat) {
        self.backgroundColor = CGColorCodable(color: backgroundColor)
        self.shouldFade = shouldFade
        self.fadeAlpha = fadeAlpha
        self.fadeFrequency = fadeFrequency
        self.xResolution = xResolution
        self.yResolution = yResolution
        self.population = population
        self.colors = colors.map() { CGColorCodable(color: $0) }
        self.maximumSpeed = maximumSpeed
        self.maximumForce = maximumForce
        self.separationWeight = separationWeight
        self.alignmentWeight = alignmentWeight
        self.cohesionWeight = cohesionWeight
        self.activeRange = activeRange
        activeRangeSquared = activeRange * activeRange
    }
    
}
