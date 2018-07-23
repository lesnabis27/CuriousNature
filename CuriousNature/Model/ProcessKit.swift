//
//  ProcessKit.swift
//  CuriousNature
//
//  Created by Sam Richardson on 4/12/18.
//  Copyright © 2018 Sam Richardson. All rights reserved.
//

// ProcessKit (PK) is full of convenience functions and properties to ease drawing to the screen

import Cocoa

struct PK {
    
    public static func background(in context: CGContext, red: CGFloat, green: CGFloat, blue: CGFloat) {
        context.setFillColor(red: red, green: green, blue: blue, alpha: 1.0)
        context.fill(CGRect.init(x: 0, y: 0, width: state.xResolution, height: state.yResolution))
    }
    
    public static func background(in context: CGContext, gray: CGFloat) {
        context.setFillColor(gray: gray, alpha: 1.0)
        context.fill(CGRect.init(x: 0, y: 0, width: state.xResolution, height: state.yResolution))
    }
    
    public static func background(in context: CGContext) {
        context.setFillColor(state.backgroundColor)
        context.fill(CGRect.init(x: 0, y: 0, width: state.xResolution, height: state.yResolution))
    }
    
    public static func fadeBackground(in context: CGContext, gray: CGFloat, alpha: CGFloat) {
        context.setFillColor(gray: gray, alpha: alpha)
        context.fill(CGRect.init(x: 0, y: 0, width: state.xResolution, height: state.yResolution))
    }
    
    public static func fadeBackground(in context: CGContext) {
        context.setFillColor(state.backgroundColor)
        context.setAlpha(state.fadeAlpha)
        context.fill(CGRect.init(x: 0, y: 0, width: state.xResolution, height: state.yResolution))
    }
    
    public static func line(from begin: CGPoint, to end: CGPoint, in context: CGContext) {
        context.beginPath()
        context.move(to: begin)
        context.addLine(to: end)
        context.strokePath()
    }
    
    public static func polygon(from points: [CGPoint], in context: CGContext) {
        if points.count > 2 {
            let path = CGMutablePath()
            path.move(to: points.first!)
            for i in 1..<points.count {
                path.addLine(to: points[i])
            }
            path.closeSubpath()
            context.addPath(path)
            context.drawPath(using: .fill)
        }
    }
    
    public static func stroke(in context: CGContext, color: CGColor) {
        context.setStrokeColor(color)
    }
    
    public static func lineWeight(in context: CGContext, weight: CGFloat) {
        context.setLineWidth(weight)
    }
    
    // Generate random number from 0.0 to 1.0
    public static func randomCGFloat() -> CGFloat {
        return CGFloat(arc4random_uniform(UInt32(1.0)))
    }
    
    // Generate random number up to a specified number
    public static func randomCGFloat(upTo range: CGFloat) -> CGFloat {
        return CGFloat(arc4random_uniform(UInt32(range)))
    }
    
    // Generate random number between two numbers
    public static func randomCGFloat(from start: CGFloat, to end: CGFloat) -> CGFloat {
        return CGFloat(arc4random_uniform(UInt32(end-start))) + start
    }
    
}
