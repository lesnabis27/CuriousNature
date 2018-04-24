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
    var loc, ploc, vel, acc: Vector
    let mass: Double
    let color: CGColor
    
    init() {
        loc = [PK.width, PK.height]
        ploc = [0, 0]
        vel = [0, 0]
        acc = [0, 0]
        mass = 1.0
        color = CGColor.init(red: CGFloat(drand48()), green: CGFloat(drand48()), blue: CGFloat(drand48()), alpha: 0.2)
    }
    
    init(atX x: Double, andY y: Double) {
        loc = [x, y]
        ploc = [x, y]
        vel = [0, 0]
        acc = [0, 0]
        mass = 1.0
        color = CGColor.init(red: CGFloat(drand48()), green: CGFloat(drand48()), blue: CGFloat(drand48()), alpha: 0.2)
    }
    
    func randomMotion() {
        acc = acc.random2D()
        vel += acc
        vel = vel.limit(10.0)
        ploc = loc
        loc += vel
        bounce()
    }
    
    func bounce() {
        if loc.x > PK.width2x || loc.x < 0 {vel.x *= -1}
        if loc.y > PK.height2x || loc.y < 0 {vel.y *= -1}
    }
    
    func draw(to context: CGContext) {
        context.setStrokeColor(color)
        context.setLineWidth(2.0)
        PK.line(from: ploc.toCGPoint(), to: loc.toCGPoint(), in: context)
    }
    
}
