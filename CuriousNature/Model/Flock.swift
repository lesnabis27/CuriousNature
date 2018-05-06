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
    
    // MARK: - Initializers
    init(with n: Int) {
        peas = [Pea]()
        alpha = 1.0
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
    
    // MARK: - Updaters
    
    // Update peas based on random motion
    func updateRandom(to context: CGContext) {
        context.setAlpha(alpha)
        for pea in peas {
            pea.randomMotion()
            pea.draw(to: context)
        }
    }
    
    // Update peas based on interactions
    func updateFlock(to context: CGContext) {
        context.setAlpha(alpha)
        for pea in peas {
            pea.update(seeking: peas)
            pea.drawInteractionsWithPolygons(to: context, peas: peas)
            pea.draw(to: context)
        }
    }
    
}
