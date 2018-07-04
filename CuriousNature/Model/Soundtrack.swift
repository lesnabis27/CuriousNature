//
//  Soundtrack.swift
//  CuriousNature
//
//  Created by Sam Richardson on 6/3/18.
//  Copyright © 2018 Sam Richardson. All rights reserved.
//

import Cocoa
import AVFoundation

class Soundtrack {
    
    var player: AVAudioPlayer?
    
    init() {
        // There's nothing to initialize...
    }
    
    func playBackground() {
        let url = Bundle.main.url(forResource: "NPS", withExtension: "m4a")!
        do {
            player = try AVAudioPlayer(contentsOf: url, fileTypeHint: AVFileType.m4a.rawValue)
            guard let player = player else { return }
            player.numberOfLoops = -1
            player.volume = 1.0
            player.play()
        } catch let error {
            print(error.localizedDescription)
        }
    }
    
    func pause() {
        player?.pause()
    }
    
}
