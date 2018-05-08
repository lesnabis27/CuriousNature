//
//  Flock.swift
//  CuriousNature
//
//  Created by Sam Richardson on 4/7/18.
//  Copyright © 2018 Sam Richardson. All rights reserved.
//

//
// Flock contains an array of Peas, methods for populating and managing the array, and methods to have the peas interact
//

import Foundation

class Flock {
    
    // MARK: - Properties
    var peas: [Pea]
    var alpha: CGFloat
    var currentInteractions: Int
    
    // MARK: - Initializers
    init(with n: Int) {
        peas = [Pea]()
        alpha = 1.0
        currentInteractions = 0
        populate(with: n)
    }
    
    // MARK: - Methods
    func populate(with n: Int) {
        for _ in 0..<n {
            peas.append(Pea())
        }
    }
    
    // Give peas a singular color
    func color(_ color: CGColor) {
        for pea in peas {
            pea.color = color
        }
    }
    
    // Give peas a random color from an array
    func color(_ colors: [CGColor]) {
        if !colors.isEmpty {
            for pea in peas {
                pea.color = colors.randomItem()!
            }
        }
    }
    
    // Set flocking properties
    func setFlockingParameters(separate: CGFloat?, align: CGFloat?, cohesion: CGFloat?, range: CGFloat?) {
        for pea in peas {
            if let sep = separate {
                pea.sepWeight = sep
            }
            if let ali = align {
                pea.aliWeight = ali
            }
            if let coh = cohesion {
                pea.cohWeight = coh
            }
            if let rng = range {
                pea.activeRange = rng
            }
        }
    }
    
    // MARK: - Updater
    
    // Update peas based on interactions
    func updateFlock(to context: CGContext) {
        currentInteractions = 0
        context.setAlpha(alpha)
        for pea in peas {
            pea.update(seeking: peas)
            currentInteractions += pea.currentInteractions
            pea.drawInteractionsWithPolygons(to: context, peas: peas)
            pea.drawPath(to: context)
        }
        // Peas interact in pairs, so halve the counted interactions
        currentInteractions /= 2
        print(currentInteractions, "current interactions")
    }
    
}
