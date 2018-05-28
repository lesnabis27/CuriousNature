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
        environment.clearCanvas(view: canvas)
    }
    
    // MARK: - Properties
    lazy var environment = Environment()
    var timer = Timer()
    var mouseTimer = 0
    var mouseShouldBeHidden = false

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
        NotificationCenter.default.addObserver(self, selector: #selector(changePopulation), name: .populationChanged, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(changeColors), name: .colorsChanged, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(changeResolution), name: .resolutionChanged, object: nil)
        startTimer()
    }
    
    override func viewWillDisappear() {
        stopTimer()
    }

    override var representedObject: Any? {
        didSet {
        }
    }
    
    // MARK: - Methods
    @objc func changePopulation() {
        environment.flock.changePopulation()
    }
    
    @objc func changeColors() {
        environment.flock.color()
    }
    
    @objc func changeResolution() {
        environment.changeResolution()
    }
    
    // MARK: - NSWindowDelegate
    func windowDidEnterFullScreen(_ notification: Notification) {
        NSCursor.hide()
    }
    
    func windowDidExitFullScreen(_ notification: Notification) {
        NSCursor.unhide()
    }
    
    override func mouseMoved(with event: NSEvent) {
        super.mouseMoved(with: event)
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
                let cgimage = self.environment.context!.makeImage()
                let nsimage = NSImage(cgImage: cgimage!, size: NSZeroSize)
                nsimage.pngWrite(to: url, options: .withoutOverwriting)
            }
        }
    }
    
    // MARK: - Timer
    func startTimer() {
        timer = Timer.scheduledTimer(withTimeInterval: 0.03, repeats: true, block: update)
        timer.tolerance = 0.01
    }
    
    func stopTimer() {
        timer.invalidate()
    }
    
    @objc func update(_: Timer) {
        environment.update()
        canvas.update(from: environment.context)
    }
    
}

