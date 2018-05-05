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
    var peas: [Pea]
    
    init(with n: Int) {
        peas = [Pea]()
        populate(with: n)
    }
    
    
    func populate(with n: Int) {
        for _ in 0..<n {
            peas.append(Pea(atX: Double(arc4random_uniform(UInt32(PK.width2x))), andY: Double(arc4random_uniform(UInt32(PK.height2x)))))
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
    
    // Update peas based on random motion
    func updateRandom(to context: CGContext) {
        for pea in peas {
            pea.randomMotion()
            pea.draw(to: context)
        }
    }
    
    // Update peas based on interactions
    func updateFlock(to context: CGContext) {
        for pea in peas {
            pea.update(seeking: peas)
            pea.drawInteractionsWithPolygons(to: context, peas: peas)
            pea.draw(to: context)
        }
    }
    
}
