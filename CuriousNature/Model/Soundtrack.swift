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
    var cricketPlayer: AVAudioPlayer?
    
    var isNight: Bool
    
    init() {
        isNight = false
        checkForNight()
    }
    
    func checkForNight() {
        if ((Calendar.current.component(.hour, from: Date()) > 20 || Calendar.current.component(.hour, from: Date()) < 7) && !isNight) {
            playCrickets()
            player?.volume = 0.2
            isNight = true
        } else if (Calendar.current.component(.hour, from: Date()) < 20 && Calendar.current.component(.hour, from: Date()) > 7 && isNight) {
            stopCrickets()
            player?.volume = 1.0
            isNight = false
        }
        if (isNight && player?.volume != 0.2) {
            player?.volume = 0.2
        }
    }
    
    func playBackground() {
        let url = Bundle.main.url(forResource: "Background", withExtension: "mp3")!
        do {
            player = try AVAudioPlayer(contentsOf: url, fileTypeHint: AVFileType.mp3.rawValue)
            guard let player = player else { return }
            player.numberOfLoops = -1
            player.volume = 1.0
            player.play()
        } catch let error {
            print(error.localizedDescription)
        }
    }
    
    func playCrickets() {
        let url = Bundle.main.url(forResource: "Crickets", withExtension: "mp3")!
        do {
            cricketPlayer = try AVAudioPlayer(contentsOf: url, fileTypeHint: AVFileType.mp3.rawValue)
            guard let cricketPlayer = cricketPlayer else { return }
            cricketPlayer.numberOfLoops = -1
            cricketPlayer.volume = 1.0
            cricketPlayer.play()
        } catch let error {
            print(error.localizedDescription)
        }
    }
    
    func stopCrickets() {
        cricketPlayer?.stop()
    }
    
    func pause() {
        player?.pause()
    }
    
}
