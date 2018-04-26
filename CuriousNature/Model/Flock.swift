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
            peas.append(Pea(atX: drand48() * PK.width2x, andY: drand48() * PK.height2x))
        }
    }
    
    func updateRandom(to context: CGContext) {
        for pea in peas {
            pea.randomMotion()
            pea.draw(to: context)
        }
    }
    
    func updateFlock(to context: CGContext) {
        for pea in peas {
            pea.update(seeking: peas)
            pea.draw(to: context)
        }
    }
    
}
