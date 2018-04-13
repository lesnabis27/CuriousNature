//
//  ViewController.swift
//  CuriousNature
//
//  Created by Sam Richardson on 4/7/18.
//  Copyright © 2018 Sam Richardson. All rights reserved.
//

import Cocoa

class ViewController: NSViewController {
    @IBOutlet weak var canvas: Canvas!
    var context: CGContext?
    var timer = Timer()
    var flock = Flock(with: 12)

    override func viewWillAppear() {
        super.viewWillAppear()
        
        // Invisible title bar
        self.view.window?.styleMask.insert(NSWindow.StyleMask.unifiedTitleAndToolbar)
        self.view.window?.styleMask.insert(NSWindow.StyleMask.fullSizeContentView)
        self.view.window?.styleMask.insert(NSWindow.StyleMask.titled)
        self.view.window?.toolbar?.isVisible = false
        self.view.window?.titleVisibility = .hidden
        self.view.window?.titlebarAppearsTransparent = true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        scheduledTimerWithTimeInterval()
    }

    override var representedObject: Any? {
        didSet {
        }
    }
    
    // Analogous to Processing's setup
    // Code to be executed on startup
    func setup() {
        createContext()
        PK.background(in: context!, gray: 0.05)
        canvas.update(from: context)
    }
    
    // Analogous to Processing's draw
    // Loops for the duration of the program
    @objc func update(_: Timer) {
        flock.update(to: context!)
        canvas.update(from: context)
    }
    
    func createContext() {
        context = CGContext(
            data: nil,
            width: Int((NSScreen.main?.frame.width)!),
            height: Int((NSScreen.main?.frame.height)!),
            bitsPerComponent: 8,
            bytesPerRow: 0,
            space: CGColorSpaceCreateDeviceRGB(),
            bitmapInfo: CGImageAlphaInfo.premultipliedFirst.rawValue)
        context?.scaleBy(x: 1.0, y: 1.0)
    }

    func background() {
        
    }
    
    func releaseContext() {
        context = nil
    }
    
    func scheduledTimerWithTimeInterval() {
        timer = Timer.scheduledTimer(withTimeInterval: 0.03, repeats: true, block: self.update)
    }

}

