//
//  CGColorCodable.swift
//  CuriousNature
//
//  Created by Sam Richardson on 5/8/18.
//  Copyright © 2018 Sam Richardson. All rights reserved.
//

import Foundation

// CGColor doesn't conform to Codable, this does
public struct CGColorCodable: Codable {
    
    var red, green, blue, alpha: CGFloat
    
    init(color: CGColor) {
        red = color.components![0]
        green = color.components![1]
        blue = color.components![2]
        alpha = color.components![3]
    }
    
    func toCGColor() -> CGColor {
        return CGColor(red: red, green: green, blue: blue, alpha: alpha)
    }
    
}
