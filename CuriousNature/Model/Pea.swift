//
//  Pea.swift
//  CuriousNature
//
//  Created by Sam Richardson on 4/7/18.
//  Copyright © 2018 Sam Richardson. All rights reserved.
//

//
// Pea is a particle object containing vectors describing its location, velocity, and acceleration as well as its mass and visual qualities, methods for drawing and moving, etc.
//

import Cocoa

class Pea: Codable {
    
    // MARK: - Properties
    
    var loc, ploc, vel, acc: Vector
    var depth: CGFloat
    var color: CGColor
    var currentInteractions: Int

    // MARK: - Initializers
    
    init(atX x: CGFloat, andY y: CGFloat) {
        loc = [x, y]
        ploc = [x, y]
        vel = Vector.random2D()
        acc = [0, 0]
        depth = CGFloat.random(from: state.minDepth, to: state.maxDepth)
        color = state.colors.randomItem()!.toCGColor()
        currentInteractions = 0
    }
    
    convenience init() {
        self.init(atX: PK.randomCGFloat(upTo: state.xResolution), andY: PK.randomCGFloat(upTo: state.yResolution))
    }
    
    // MARK: - Encoding
    
    enum CodingKeys: String, CodingKey {
        case loc
        case ploc
        case vel
        case acc
        case depth
        case color
    }
    
    required init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        loc = try values.decode(Vector.self, forKey: .loc)
        ploc = try values.decode(Vector.self, forKey: .ploc)
        vel = try values.decode(Vector.self, forKey: .vel)
        acc = try values.decode(Vector.self, forKey: .acc)
        depth = try values.decode(CGFloat.self, forKey: .depth)
        let codableColor = try values.decode(CGColorCodable.self, forKey: .color)
        color = codableColor.toCGColor()
        currentInteractions = 0
    }
    
    // Some properties are easily recalculated and don't need to be encoded
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(loc, forKey: .loc)
        try container.encode(ploc, forKey: .ploc)
        try container.encode(vel, forKey: .vel)
        try container.encode(acc, forKey: .acc)
        try container.encode(depth, forKey: .depth)
        try container.encode(CGColorCodable(color: color), forKey: .color)
    }
    
    // MARK: - Motion
    
    func update(seeking peas: [Pea]) {
        flock(peas)
        move()
        wrap()
    }
    
    func move() {
        vel += acc
        vel = vel.limit(state.maximumSpeed)
        ploc = loc
        loc += vel
    }
    
    func randomMotion() {
        acc = Vector.random2D()
        move()
        bounce()
    }
    
    func bounce() {
        if loc.x > state.xResolution || loc.x < 0 {vel.x *= -1}
        if loc.y > state.yResolution || loc.y < 0 {vel.y *= -1}
    }
    
    func wrap() {
        if (loc.x > state.xResolution && ploc.x > state.xResolution) {
            loc.x = 0
            ploc.x = loc.x
        }
        else if (loc.x < 0 && ploc.x < 0) {
            loc.x = state.xResolution
            ploc.x = loc.x
        }
        if (loc.y > state.yResolution && ploc.y > state.yResolution) {
            loc.y = 0
            ploc.y = loc.y
        }
        else if (loc.y < 0 && ploc.y < 0) {
            loc.y = state.yResolution
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
        sep *= state.separationWeight // PREF
        ali *= state.alignmentWeight // PREF
        coh *= state.cohesionWeight // PREF
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
            if distance < state.activeRange && distance > 0 {
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
            steer.magnitude = state.maximumSpeed
            steer -= vel
            steer = steer.limit(state.maximumForce)
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
            if distance < (state.activeRangeSquared) && distance > 0 {
                // Move with
                sum += pea.vel
                count += 1
            }
        }
        // Average the sum vector
        if count > 0 {
            sum /= CGFloat(count)
            sum.magnitude = state.maximumSpeed
            var steer = sum - vel
            steer = steer.limit(state.maximumForce)
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
            if distance < (state.activeRangeSquared) && distance > 0 {
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
        heading.magnitude = state.maximumSpeed
        var steer = heading - vel // Steering force
        steer = steer.limit(state.maximumForce)
        return steer
    }
    
    // Tally the number fo peas interacting this frame
    func tallyInteractions(_ count: Int) {
        currentInteractions = count
    }
    
    // MARK: - Display
    
    func drawPath(to context: CGContext) {
        context.setStrokeColor(color)
        context.setLineWidth(depth)
        PK.line(from: ploc.toCGPoint(), to: loc.toCGPoint(), in: context)
    }
    
    func drawInteractionsWithLines(to context: CGContext, peas: [Pea]) {
        for pea in peas {
            let distance = loc.simpleDistanceTo(pea.loc)
            context.setLineCap(.round)
            if distance < (state.activeRange * state.activeRange) && distance > 0 {
                context.setStrokeColor(color)
                context.setLineWidth(depth * 5)
                PK.line(from: loc.toCGPoint(), to: pea.loc.toCGPoint(), in: context)
            }
        }
    }
    
    func drawInteractionsWithPolygons(to context: CGContext, peas: [Pea]) {
        for pea in peas {
            let distance = loc.simpleDistanceTo(pea.loc)
            if distance < (state.activeRangeSquared) && distance > 0 {
                context.setFillColor(color)
                PK.polygon(from: [loc.toCGPoint(), pea.loc.toCGPoint(), pea.ploc.toCGPoint(), ploc.toCGPoint()], in: context)
            }
        }
    }
    
}
