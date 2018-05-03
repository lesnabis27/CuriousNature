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
    let color: CGColor // PREF
    
    // MARK: - Static Properties
    
    static let maximumSpeed = 10.0 // PREF
    static let maximumForce = 0.1 // PREF
    
    // MARK: - Initializers
    
    init() {
        loc = [PK.width, PK.height]
        ploc = [0, 0]
        vel = [0, 0]
        acc = [0, 0]
        depth = CGFloat(drand48())
        color = CGColor.init(red: CGFloat(drand48()), green: CGFloat(drand48()), blue: CGFloat(drand48()), alpha: 0.2)
    }
    
    init(atX x: Double, andY y: Double) {
        loc = [x, y]
        ploc = [x, y]
        vel = [0, 0]
        acc = [0, 0]
        depth = CGFloat(drand48())
        color = CGColor.init(red: CGFloat(drand48()), green: CGFloat(drand48()), blue: CGFloat(drand48()), alpha: 0.2)
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
        acc = acc.random2D()
        move()
        bounce()
    }
    
    func bounce() {
        if loc.x > PK.width2x || loc.x < 0 {vel.x *= -1}
        if loc.y > PK.height2x || loc.y < 0 {vel.y *= -1}
    }
    
    func wrap() {
        if (loc.x > PK.width2x && ploc.x > PK.width2x) {
            loc.x = 0
            ploc.x = loc.x
        }
        else if (loc.x < 0 && ploc.x < 0) {
            loc.x = PK.width2x
            ploc.x = loc.x
        }
        if (loc.y > PK.height2x && ploc.y > PK.height2x) {
            loc.y = 0
            ploc.y = loc.y
        }
        else if (loc.y < 0 && ploc.y < 0) {
            loc.y = PK.height2x
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
        sep *= 1.0 // PREF
        ali *= 1.7 // PREF
        coh *= 1.5 // PREF
        applyForce(force: sep)
        applyForce(force: ali)
        applyForce(force: coh)
    }
    
    // Steer away from nearby peas
    func separate(_ peas: [Pea]) -> Vector {
        let spacing = 25.0 // PREF
        var steer = Vector()
        var count = 0
        for pea in peas {
            let distance = loc.distanceTo(pea.loc)
            let depthDifference = 1 - abs(depth - pea.depth)
            if distance < spacing && distance > 0 {
                // Point away
                var difference = loc - pea.loc
                difference = difference.normalize()
                difference /= distance // Closer peas weight higher
                //difference *= Double(depthDifference)
                steer += difference
                count += 1
            }
        }
        // Average the steer vector
        if count > 0 {
            steer /= Double(count)
        }
        if steer.magnitude > 0 {
            steer.magnitude = Pea.maximumSpeed
            steer -= vel
            steer = steer.limit(Pea.maximumForce)
        }
        return steer
    }
    
    // Calculate average velocity of nearby peas
    func align(_ peas: [Pea]) -> Vector {
        let spacing = 50.0 // PREF
        var sum = Vector()
        var count = 0
        for pea in peas {
            let distance = loc.distanceTo(pea.loc)
            let depthDifference = 1 - abs(depth - pea.depth)
            if distance < spacing && distance > 0 {
                // Move with
                //sum += (pea.vel * Double(depthDifference))
                sum += pea.vel
                count += 1
            }
        }
        // Average the sum vector
        if count > 0 {
            sum /= Double(count)
            sum.magnitude = Pea.maximumSpeed
            var steer = sum - vel
            steer = steer.limit(Pea.maximumForce)
            return steer
        }
        return Vector()
    }
    
    // Steer toward nearby peas
    func cohesion(_ peas: [Pea]) -> Vector {
        let spacing = 50.0 // PREF
        var sum = Vector()
        var count = 0
        for pea in peas {
            let distance = loc.distanceTo(pea.loc)
            if distance < spacing && distance > 0 {
                // Point toward
                sum += pea.loc
                count += 1
            }
        }
        // Average the sum vector
        if count > 0 {
            sum /= Double(count)
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
    
    // MARK: - Display
    
    func draw(to context: CGContext) {
        context.setStrokeColor(color)
        context.setLineWidth(depth * 10)
        PK.line(from: ploc.toCGPoint(), to: loc.toCGPoint(), in: context)
    }
    
    func drawInteractionsWithLines(to context: CGContext, peas: [Pea]) {
        for pea in peas {
            let distance = loc.distanceTo(pea.loc)
            context.setLineCap(.round)
            if distance < 50 && distance > 0 {
                context.setStrokeColor(color)
                context.setLineWidth(depth * 10)
                PK.line(from: loc.toCGPoint(), to: pea.loc.toCGPoint(), in: context)
            }
        }
    }
    
    func drawInteractionsWithPolygons(to context: CGContext, peas: [Pea]) {
        for pea in peas {
            let distance = loc.distanceTo(pea.loc)
            if distance < 100 && distance > 0 {
                //let alpha: CGFloat = 1.0 - 0.02 * CGFloat(distance)
                context.setFillColor(color)
                //context.setAlpha(alpha)
                PK.polygon(from: [loc.toCGPoint(), pea.loc.toCGPoint(), pea.ploc.toCGPoint(), ploc.toCGPoint()], in: context)
            }
        }
    }
    
}
