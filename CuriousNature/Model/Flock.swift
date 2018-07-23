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

class Flock: Codable {
    
    // MARK: - Properties
    var peas: [Pea]
    var currentInteractions: Int
    
    // MARK: - Initializers
    init() {
        peas = [Pea]()
        currentInteractions = 0
        populate()
    }
    
    // MARK: - Methods
    func populate() {
        for _ in 0..<state.population {
            peas.append(Pea())
        }
    }
    
    func changePopulation() {
        let difference = state.population - peas.count
        if difference > 0 {
            addPeas(count: difference)
            print("Added", difference, "peas")
        } else if difference < 0 {
            removePeas(count: abs(difference))
            print("Removed", abs(difference), "peas")
        }
    }
    
    func addPeas(count: Int) {
        for _ in 0..<count {
            peas.append(Pea())
        }
    }
    
    func removePeas(count: Int) {
        peas.removeLast(count)
    }
    
    // Give peas new depths
    func updateDepth() {
        for pea in peas {
            pea.depth = CGFloat.random(from: state.minDepth, to: state.maxDepth)
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
    
    // Recolor peas from state
    func color() {
        for pea in peas {
            pea.color = CGColor.random()
        }
    }
    
    // MARK: - Updater
    
    // Update peas based on interactions
    func updateFlock(to context: CGContext) {
        currentInteractions = 0
        for pea in peas {
            pea.update(seeking: peas)
            currentInteractions += pea.currentInteractions
            pea.drawInteractionsWithPolygons(to: context, peas: peas)
            pea.drawPath(to: context)
        }
        // Peas interact in pairs, so halve the counted interactions
        currentInteractions /= 2
        //print(currentInteractions, "current interactions")
    }
    
}
