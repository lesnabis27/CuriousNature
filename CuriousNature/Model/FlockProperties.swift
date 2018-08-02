//
//  FlockProperties.swift
//  Thirty Objects
//
//  Created by Sam Richardson on 7/30/18.
//  Copyright © 2018 Sam Richardson. All rights reserved.
//

import Foundation

struct FlockProperties {
    public let separationWeight, alignmentWeight, cohesionWeight: CGFloat
    
    init() {
        separationWeight = state.separationWeight
        alignmentWeight = state.alignmentWeight
        cohesionWeight = state.cohesionWeight
    }
    
    init(sep: CGFloat, ali: CGFloat, coh: CGFloat) {
        separationWeight = sep
        alignmentWeight = ali
        cohesionWeight = coh
    }
    
    public func setState() {
        state.separationWeight = separationWeight
        state.alignmentWeight = alignmentWeight
        state.cohesionWeight = cohesionWeight
    }
}
