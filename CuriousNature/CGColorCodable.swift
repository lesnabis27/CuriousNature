//
//  CGColorCodable.swift
//  CuriousNature
//
//  Created by Sam Richardson on 5/8/18.
//  Copyright © 2018 Sam Richardson. All rights reserved.
//

import Cocoa

// CGColor doesn't conform to Codable, this does
public struct CGColorCodable: Codable {
    
    var red, green, blue, alpha: CGFloat
    
    init(color: CGColor) {
        if color.numberOfComponents == 4 {
            red = color.components![0]
            green = color.components![1]
            blue = color.components![2]
            alpha = color.components![3]
        }
        else {
            red = color.components![0]
            green = color.components![0]
            blue = color.components![0]
            alpha = color.components![1]
        }
    }
    
    func toCGColor() -> CGColor {
        return CGColor(red: red, green: green, blue: blue, alpha: alpha)
    }
    
    func toNSColor() -> NSColor {
        return NSColor(red: red, green: green, blue: blue, alpha: alpha)
    }
    
}
