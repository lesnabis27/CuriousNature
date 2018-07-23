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
    
    // MARK: - Keys
    enum CodingKeys: String, CodingKey {
        case shouldFade
        case fadeAlpha
        case fadeFrequency
        case xResolution
        case yResolution
        case border
        case population
        case minDepth
        case maxDepth
        case vineAlpha
        case leafAlpha
        case maxSaturation
        case minSaturation
        case maxBrightness
        case minBrightness
        case maximumSpeed
        case maximumForce
        case separationWeight
        case alignmentWeight
        case cohesionWeight
        case activeRange
    }
    
    // MARK: - Initializer
    
    init() {
        backgroundColor = CGColor(gray: 0.0, alpha: 1.0)
        shouldFade = true
        fadeAlpha = 0.005
        fadeFrequency = 20
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
        separationWeight = 1.5
        alignmentWeight = 1.2
        cohesionWeight = 1.5
        activeRange = 50.0
        activeRangeSquared = activeRange * activeRange
    }
    
    init(shouldFade: Bool, fadeAlpha: CGFloat, fadeFrequency: Int, xResolution: CGFloat, yResolution: CGFloat, border: CGFloat, population: Int, minDepth: CGFloat, maxDepth: CGFloat, vineAlpha: CGFloat, leafAlpha: CGFloat, maxSaturation: CGFloat, minSaturation: CGFloat, maxBrightness: CGFloat, minBrightness: CGFloat, maximumSpeed: CGFloat, maximumForce: CGFloat, separationWeight: CGFloat, alignmentWeight: CGFloat, cohesionWeight: CGFloat, activeRange: CGFloat) {
        self.shouldFade = shouldFade
        self.fadeAlpha = fadeAlpha
        self.fadeFrequency = fadeFrequency
        self.xResolution = xResolution
        self.yResolution = yResolution
        self.border = border
        self.population = population
        self.minDepth = minDepth
        self.maxDepth = maxDepth
        self.vineAlpha = vineAlpha
        self.leafAlpha = leafAlpha
        self.maxSaturation = maxSaturation
        self.minSaturation = minSaturation
        self.maxBrightness = maxBrightness
        self.minBrightness = minBrightness
        self.maximumSpeed = maximumSpeed
        self.maximumForce = maximumForce
        self.separationWeight = separationWeight
        self.alignmentWeight = alignmentWeight
        self.cohesionWeight = cohesionWeight
        self.activeRange = activeRange
        backgroundColor = CGColor(gray: 0.0, alpha: 1.0)
        activeRangeSquared = activeRange * activeRange
    }
    
    required init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        shouldFade = try values.decode(Bool.self, forKey: .shouldFade)
        fadeAlpha = try values.decode(CGFloat.self, forKey: .fadeAlpha)
        fadeFrequency = try values.decode(Int.self, forKey: .fadeFrequency)
        xResolution = try values.decode(CGFloat.self, forKey: .xResolution)
        yResolution = try values.decode(CGFloat.self, forKey: .yResolution)
        border = try values.decode(CGFloat.self, forKey: .border)
        population = try values.decode(Int.self, forKey: .population)
        minDepth = try values.decode(CGFloat.self, forKey: .minDepth)
        maxDepth = try values.decode(CGFloat.self, forKey: .maxDepth)
        vineAlpha = try values.decode(CGFloat.self, forKey: .vineAlpha)
        leafAlpha = try values.decode(CGFloat.self, forKey: .leafAlpha)
        maxSaturation = try values.decode(CGFloat.self, forKey: .maxSaturation)
        minSaturation = try values.decode(CGFloat.self, forKey: .minSaturation)
        maxBrightness = try values.decode(CGFloat.self, forKey: .maxBrightness)
        minBrightness = try values.decode(CGFloat.self, forKey: .minBrightness)
        maximumSpeed = try values.decode(CGFloat.self, forKey: .maximumSpeed)
        maximumForce = try values.decode(CGFloat.self, forKey: .maximumForce)
        separationWeight = try values.decode(CGFloat.self, forKey: .separationWeight)
        alignmentWeight = try values.decode(CGFloat.self, forKey: .alignmentWeight)
        cohesionWeight = try values.decode(CGFloat.self, forKey: .cohesionWeight)
        activeRange = try values.decode(CGFloat.self, forKey: .activeRange)
        activeRangeSquared = activeRange * activeRange
        backgroundColor = CGColor(gray: 0.0, alpha: 1.0)
    }
    
}
