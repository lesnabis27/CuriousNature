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
        print("Flock initialized")
    }
    
    func populate(with n: Int) {
        for _ in 0..<n {
            peas.append(Pea())
        }
    }
    
    func update(to context: CGContext) {
        for i in 0..<peas.count {
            peas[i].randomMotion()
            peas[i].draw(to: context)
        }
    }
    
}
