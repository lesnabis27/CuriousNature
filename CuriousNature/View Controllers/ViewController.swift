//
//  ViewController.swift
//  CuriousNature
//
//  Created by Sam Richardson on 4/7/18.
//  Copyright © 2018 Sam Richardson. All rights reserved.
//

import Cocoa

class ViewController: NSViewController {
    
    // MARK: - IBOutlets
    @IBOutlet weak var canvas: Canvas!
    
    // MARK: - IBActions
    @IBAction func exportMenuItemSelected(_ sender: Any) {
        showExportPanel()
    }
    @IBAction func startMenuItemSelected(_ sender: Any) {
        if timer.isValid {
            stopTimer()
        } else {
            startTimer()
        }
    }
    @IBAction func clearMenuItemSelected(_ sender: Any) {
        clearCanvas()
    }
    
    // MARK: - Properties
    var context: CGContext?
    var timer = Timer()
    var flock = Flock(with: 100)

    // MARK: - View stuff
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
        startTimer()
    }

    override var representedObject: Any? {
        didSet {
        }
    }
    
    // MARK: - Setup
    // Analogous to Processing's setup
    // Code to be executed on startup
    func setup() {
        createContext()
        PK.background(in: context!, gray: 0.0)
        canvas.update(from: context)
    }
    
    // MARK: - Update
    // Analogous to Processing's draw
    // Loops for the duration of the program
    @objc func update(_: Timer) {
        flock.updateFlock(to: context!)
        canvas.update(from: context)
    }
    
    // MARK: - Context
    func createContext() {
        context = CGContext(
            data: nil,
            width: Int(PK.width2x),
            height: Int(PK.height2x),
            bitsPerComponent: 8,
            bytesPerRow: 0,
            space: CGColorSpaceCreateDeviceRGB(),
            bitmapInfo: CGImageAlphaInfo.premultipliedFirst.rawValue)
    }
    
    func releaseContext() {
        context = nil
    }
    
    func clearCanvas() {
        releaseContext()
        createContext()
        PK.background(in: context!, gray: 0.05)
        canvas.update(from: context)
    }
    
    // MARK: - Saving and opening
    func showExportPanel() {
        guard let window = view.window else {return}
        let panel = NSSavePanel()
        panel.directoryURL = FileManager.default.homeDirectoryForCurrentUser
        panel.nameFieldStringValue = "frame.png"
        panel.beginSheetModal(for: window) { (result) in
            if result == NSApplication.ModalResponse.OK,
                let url = panel.url {
                let cgimage = self.context!.makeImage()
                let nsimage = NSImage(cgImage: cgimage!, size: NSZeroSize)
                nsimage.pngWrite(to: url, options: .withoutOverwriting)
            }
        }
    }
    
    // MARK: - Timer
    func startTimer() {
        timer = Timer.scheduledTimer(withTimeInterval: 0.01, repeats: true, block: self.update)
        //NotificationCenter.default.post(name: .timerStart, object: nil)
        //if startMenuItem != nil {startMenuItem.title = "Stop"}
    }
    
    func stopTimer() {
        timer.invalidate()
        //NotificationCenter.default.post(name: .timerStop, object: nil)
        //if startMenuItem != nil {startMenuItem.title = "Start"}
    }

}

