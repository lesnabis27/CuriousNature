//
//  ViewController.swift
//  CuriousNature
//
//  Created by Sam Richardson on 4/7/18.
//  Copyright © 2018 Sam Richardson. All rights reserved.
//

import Cocoa

class ViewController: NSViewController, NSWindowDelegate {
    
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
    var subtimer = 0;
    var flock = Flock(with: 30) //PREF

    // MARK: - View stuff
    override func viewWillAppear() {
        super.viewWillAppear()
        
        // Window delegate
        self.view.window?.delegate = self
        
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
    
    override func viewWillDisappear() {
        stopTimer()
    }

    override var representedObject: Any? {
        didSet {
        }
    }
    
    // MARK: - NSWindowDelegate
    func windowDidEnterFullScreen(_ notification: Notification) {
        NSCursor.hide()
    }
    
    func windowDidExitFullScreen(_ notification: Notification) {
        NSCursor.unhide()
    }
    
    // MARK: - Setup
    // Analogous to Processing's setup
    // Code to be executed on startup
    func setup() {
        flock.color(Array(count: 12){CGColor.random()})
        flock.setFlockingParameters(separate: nil, align: nil, cohesion: nil, range: 50)
        flock.alpha = 0.2
        createContext()
        PK.background(in: context!, gray: 0.0)
        canvas.update(from: context)
    }
    
    // MARK: - Update
    // Analogous to Processing's draw
    // Loops for the duration of the program
    @objc func update(_: Timer) {
        subtimer += 1
        if subtimer % 5 == 0 {
            PK.fadeBackground(in: context!, gray: 0.0, alpha: 0.01)
            subtimer = 0
        }
        flock.updateFlock(to: context!)
        canvas.update(from: context)
    }
    
    // MARK: - Context
    func createContext() {
        context = CGContext(
            data: nil,
            width: Int(PK.width),
            height: Int(PK.height),
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
        timer = Timer.scheduledTimer(withTimeInterval: 0.03, repeats: true, block: self.update)
        //NotificationCenter.default.post(name: .timerStart, object: nil)
        //if startMenuItem != nil {startMenuItem.title = "Stop"}
    }
    
    func stopTimer() {
        timer.invalidate()
        //NotificationCenter.default.post(name: .timerStop, object: nil)
        //if startMenuItem != nil {startMenuItem.title = "Start"}
    }

}

