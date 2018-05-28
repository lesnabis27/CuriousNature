//
//  Environment.swift
//  CuriousNature
//
//  Created by Sam Richardson on 5/6/18.
//  Copyright © 2018 Sam Richardson. All rights reserved.
//

import Cocoa

// Global State

let state = Profile()

class Environment: Codable {
    
    // MARK: - Properties
    
    var context: CGContext?
    var subtimer = 0
    var flock: Flock

    // MARK: - Initializer
    
    init() {
        context = CGContext(
            data: nil,
            width: Int(state.xResolution),
            height: Int(state.yResolution),
            bitsPerComponent: 8,
            bytesPerRow: 0,
            space: CGColorSpaceCreateDeviceRGB(),
            bitmapInfo: CGImageAlphaInfo.premultipliedFirst.rawValue)
        
        // Flock setup
        flock = Flock()
        flock.alpha = 0.2
        
        // Visual setup
        PK.background(in: context!)
    }
    
    // MARK: - Enoding
    
    enum CodingKeys: String, CodingKey {
        case flock
    }
    
    required init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        flock = try values.decode(Flock.self, forKey: .flock)
        context = CGContext(
            data: nil,
            width: Int(state.xResolution),
            height: Int(state.yResolution),
            bitsPerComponent: 8,
            bytesPerRow: 0,
            space: CGColorSpaceCreateDeviceRGB(),
            bitmapInfo: CGImageAlphaInfo.premultipliedFirst.rawValue)
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(flock, forKey: .flock)
    }
    
    // MARK: - Update
    // Analogous to Processing's draw
    // Loops for the duration of the program
    func update() {
        if state.shouldFade {
            subtimer += 1
            if subtimer % state.fadeFrequency == 0 {
                PK.fadeBackground(in: context!)
                subtimer = 0
            }
        }
        flock.updateFlock(to: context!)
    }

    // MARK: - Context
    
    func changeResolution() {
        releaseContext()
        createContext()
        PK.background(in: context!)
    }
    
    func createContext() {
        context = CGContext(
            data: nil,
            width: Int(state.xResolution),
            height: Int(state.yResolution),
            bitsPerComponent: 8,
            bytesPerRow: 0,
            space: CGColorSpaceCreateDeviceRGB(),
            bitmapInfo: CGImageAlphaInfo.premultipliedFirst.rawValue)
    }
    
    func releaseContext() {
        context = nil
    }
    
    func clearCanvas(view: Canvas) {
        releaseContext()
        createContext()
        PK.background(in: context!)
        view.update(from: context)
    }
    
}
