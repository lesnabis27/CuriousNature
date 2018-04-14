//
//  Extensions.swift
//  CuriousNature
//
//  Created by Sam Richardson on 4/14/18.
//  Copyright © 2018 Sam Richardson. All rights reserved.
//

import Cocoa

extension NSImage {
    var pngData: Data? {
        guard let tiffRepresentation = tiffRepresentation, let bitmapImage = NSBitmapImageRep(data: tiffRepresentation) else { return nil }
        return bitmapImage.representation(using: .png, properties: [:])
    }
    func pngWrite(to url: URL, options: Data.WritingOptions = .atomic) {
        do {
            try pngData?.write(to: url, options: options)
            return
        } catch {
            print(error)
            return
        }
    }
}

extension Notification.Name {
    static let timerStart = Notification.Name("timerStart")
    static let timerStop = Notification.Name("timerStop")
}
