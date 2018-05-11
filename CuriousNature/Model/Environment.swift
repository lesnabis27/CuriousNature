//
//  Environment.swift
//  CuriousNature
//
//  Created by Sam Richardson on 5/6/18.
//  Copyright © 2018 Sam Richardson. All rights reserved.
//

import Cocoa

class Environment: Codable {
    
    // TODO: - Initialize context from a stored image during decoding
    
    // MARK: - Properties
    var context: CGContext?
    var subtimer = 0 // PREF
    var flock: Flock // PREF

    // MARK: - Initializer
    init() {
        context = CGContext(
            data: nil,
            width: Int(PK.width),
            height: Int(PK.height),
            bitsPerComponent: 8,
            bytesPerRow: 0,
            space: CGColorSpaceCreateDeviceRGB(),
            bitmapInfo: CGImageAlphaInfo.premultipliedFirst.rawValue)
        
        // Flock setup
        flock = Flock(with: 30)
        flock.setFlockingParameters(separate: nil, align: nil, cohesion: nil, range: 50)
        flock.alpha = 0.2
        
        // Visual setup
        PK.background(in: context!, gray: 0.0)
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
            width: Int(PK.width),
            height: Int(PK.height),
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
        subtimer += 1
        if subtimer % 5 == 0 {
            PK.fadeBackground(in: context!, gray: 0.0, alpha: 0.01)
            subtimer = 0
        }
        flock.updateFlock(to: context!)
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
    
    func clearCanvas(view: Canvas) {
        releaseContext()
        createContext()
        PK.background(in: context!, gray: 0.05)
        view.update(from: context)
    }
    
}
