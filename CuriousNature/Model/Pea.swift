//
//  Pea.swift
//  CuriousNature
//
//  Created by Sam Richardson on 4/7/18.
//  Copyright © 2018 Sam Richardson. All rights reserved.
//

//
// Pea is a particle objects containing vectors describing its location, velocity, and acceleration as well as its mass and visual qualities, methods for drawing and moving, etc.
//

import Cocoa

class Pea {
    
    // MARK: - Properties
    
    var loc, ploc, vel, acc: Vector
    let depth: CGFloat // PREF
    var color: CGColor // PREF
    var currentInteractions: Int
    
    // Flocking properties
    var sepWeight, aliWeight, cohWeight: CGFloat
    var activeRange: CGFloat {
        didSet {
            activeRangeSquared = activeRange * activeRange
        }
    }
    var activeRangeSquared: CGFloat
    
    // MARK: - Static Properties
    
    static let maximumSpeed: CGFloat = 10.0 // PREF
    static let maximumForce: CGFloat = 0.1 // PREF
    
    // MARK: - Initializers
    
    init(atX x: CGFloat, andY y: CGFloat) {
        loc = [x, y]
        ploc = [x, y]
        vel = Vector.random2D()
        acc = [0, 0]
        depth = CGFloat.random()
        color = CGColor.random()
        currentInteractions = 0
        sepWeight = 1.0
        aliWeight = 1.7
        cohWeight = 1.5
        activeRange = 50
        activeRangeSquared = activeRange * activeRange
    }
    
    convenience init() {
        self.init(atX: PK.randomCGFloat(upTo: PK.width), andY: PK.randomCGFloat(upTo: PK.height))
    }
    
    // MARK: - Motion
    
    func update(seeking peas: [Pea]) {
        flock(peas)
        move()
        wrap()
        //bounce()
    }
    
    func move() {
        vel += acc
        vel = vel.limit(Pea.maximumSpeed)
        ploc = loc
        loc += vel
    }
    
    func randomMotion() {
        acc = Vector.random2D()
        move()
        bounce()
    }
    
    func bounce() {
        if loc.x > PK.width || loc.x < 0 {vel.x *= -1}
        if loc.y > PK.height || loc.y < 0 {vel.y *= -1}
    }
    
    func wrap() {
        if (loc.x > PK.width && ploc.x > PK.width) {
            loc.x = 0
            ploc.x = loc.x
        }
        else if (loc.x < 0 && ploc.x < 0) {
            loc.x = PK.width
            ploc.x = loc.x
        }
        if (loc.y > PK.height && ploc.y > PK.height) {
            loc.y = 0
            ploc.y = loc.y
        }
        else if (loc.y < 0 && ploc.y < 0) {
            loc.y = PK.height
            ploc.y = loc.y
        }
    }
    
    // MARK: - Interaction
    
    func applyForce(force: Vector) {
        acc = acc + force
    }
    
    func flock(_ peas: [Pea]) {
        var sep = separate(peas)
        var ali = align(peas)
        var coh = cohesion(peas)
        sep *= sepWeight // PREF
        ali *= aliWeight // PREF
        coh *= cohWeight // PREF
        applyForce(force: sep)
        applyForce(force: ali)
        applyForce(force: coh)
    }
    
    // Steer away from nearby peas
    func separate(_ peas: [Pea]) -> Vector {
        var steer = Vector()
        var count = 0
        for pea in peas {
            let distance = loc.distanceTo(pea.loc)
            if distance < activeRange && distance > 0 {
                // Point away
                var difference = loc - pea.loc
                difference = difference.normalize()
                difference /= distance // Closer peas weight higher
                steer += difference
                count += 1
            }
        }
        // Average the steer vector
        if count > 0 {
            steer /= CGFloat(count)
        }
        if steer.magnitude > 0 {
            steer.magnitude = Pea.maximumSpeed
            steer -= vel
            steer = steer.limit(Pea.maximumForce)
        }
        // Tally interactions here to reduce cpu footprint
        tallyInteractions(count)
        return steer
    }
    
    // Calculate average velocity of nearby peas
    func align(_ peas: [Pea]) -> Vector {
        var sum = Vector()
        var count = 0
        for pea in peas {
            let distance = loc.simpleDistanceTo(pea.loc)
            if distance < activeRangeSquared && distance > 0 {
                // Move with
                sum += pea.vel
                count += 1
            }
        }
        // Average the sum vector
        if count > 0 {
            sum /= CGFloat(count)
            sum.magnitude = Pea.maximumSpeed
            var steer = sum - vel
            steer = steer.limit(Pea.maximumForce)
            return steer
        }
        return Vector()
    }
    
    // Steer toward nearby peas
    func cohesion(_ peas: [Pea]) -> Vector {
        var sum = Vector()
        var count = 0
        for pea in peas {
            let distance = loc.simpleDistanceTo(pea.loc)
            if distance < activeRangeSquared && distance > 0 {
                // Point toward
                sum += pea.loc
                count += 1
            }
        }
        // Average the sum vector
        if count > 0 {
            sum /= CGFloat(count)
            return seek(sum)
        }
        return Vector()
    }
    
    // Calculate a steering vector toward a target vector
    func seek(_ target: Vector) -> Vector {
        var heading = target - loc // Vector pointing toward target
        heading.magnitude = Pea.maximumSpeed
        var steer = heading - vel // Steering force
        steer = steer.limit(Pea.maximumForce)
        return steer
    }
    
    // Tally the number fo peas interacting this frame
    func tallyInteractions(_ count: Int) {
        currentInteractions = count
    }
    
    // MARK: - Display
    
    func drawPath(to context: CGContext) {
        context.setStrokeColor(color)
        context.setLineWidth(depth * 5)
        PK.line(from: ploc.toCGPoint(), to: loc.toCGPoint(), in: context)
    }
    
    func drawInteractionsWithLines(to context: CGContext, peas: [Pea]) {
        for pea in peas {
            let distance = loc.simpleDistanceTo(pea.loc)
            context.setLineCap(.round)
            if distance < activeRangeSquared && distance > 0 {
                context.setStrokeColor(color)
                context.setLineWidth(depth * 5)
                PK.line(from: loc.toCGPoint(), to: pea.loc.toCGPoint(), in: context)
            }
        }
    }
    
    func drawInteractionsWithPolygons(to context: CGContext, peas: [Pea]) {
        for pea in peas {
            let distance = loc.simpleDistanceTo(pea.loc)
            if distance < activeRangeSquared && distance > 0 {
                context.setFillColor(color)
                PK.polygon(from: [loc.toCGPoint(), pea.loc.toCGPoint(), pea.ploc.toCGPoint(), ploc.toCGPoint()], in: context)
            }
        }
    }
    
}
