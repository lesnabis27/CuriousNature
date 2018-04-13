//
//  ProcessKit.swift
//  CuriousNature
//
//  Created by Sam Richardson on 4/12/18.
//  Copyright © 2018 Sam Richardson. All rights reserved.
//

import Cocoa

struct PK {
    
    public static var width: Double {
        return Double(NSScreen.main!.frame.width)
    }
    
    public static var height: Double {
        return Double(NSScreen.main!.frame.height)
    }
    
    public static func background(in context: CGContext, red: CGFloat, green: CGFloat, blue: CGFloat) {
        context.setFillColor(red: red, green: green, blue: blue, alpha: 1.0)
        context.fill(CGRect.init(x: 0, y: 0, width: width, height: height))
    }
    
    public static func background(in context: CGContext, gray: CGFloat) {
        context.setFillColor(gray: gray, alpha: 1.0)
        context.fill(CGRect.init(x: 0, y: 0, width: width, height: height))
    }
    
    public static func line(from begin: CGPoint, to end: CGPoint, in context: CGContext) {
        context.beginPath()
        context.move(to: begin)
        context.addLine(to: end)
        context.strokePath()
    }
    
    public static func stroke(in context: CGContext, color: CGColor) {
        context.setStrokeColor(color)
    }
    
    public static func lineWeight(in context: CGContext, weight: CGFloat) {
        context.setLineWidth(weight)
    }
    
}
