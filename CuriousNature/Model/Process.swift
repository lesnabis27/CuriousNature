//
//  Process.swift
//  CuriousNature
//
//  Created by Sam Richardson on 4/24/18.
//  Copyright © 2018 Sam Richardson. All rights reserved.
//

import Cocoa

class Process {
    
    var timer = Timer()
    var canvas: Canvas
    var flocks: [Flock]
    
    init(to canvas: Canvas) {
        self.canvas = canvas
        flocks = [Flock(with: 300)]
    }
    
}
