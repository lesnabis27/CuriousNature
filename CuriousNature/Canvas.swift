//
//  Canvas.swift
//  CuriousNature
//
//  Created by Sam Richardson on 4/7/18.
//  Copyright © 2018 Sam Richardson. All rights reserved.
//

//
// Canvas is the NSView that is drawn to in this application
//

import Cocoa

class Canvas: NSView {
    var image: CGImage?
    
    func update(from context: CGContext?) {
        image = context!.makeImage()
        display()
    }
    
    override func draw(_ rect: CGRect) {
        let displayContext = NSGraphicsContext.current?.cgContext
        displayContext!.draw(image!, in: bounds)
    }
    
}
