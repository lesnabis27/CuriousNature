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
    static let colorsChanged = Notification.Name("colorsChanged")
    static let populationChanged = Notification.Name("populationChanged")
    static let resolutionChanged = Notification.Name("resolutionChanged")
    static let backgroundColorChanged = Notification.Name("backgroundColorChanged")
    static let depthChanged = Notification.Name("depthChanged")
    static let vineAlphaChanged = Notification.Name("vineAlphaChanged")
    static let leafAlphaChanged = Notification.Name("leafAlphaChanged")
}

extension Array {
    init(count: Int, closure: () -> Element) {
        self = [Element]()
        for _ in 0..<count {
            self.append(closure())
        }
    }
    
    func randomItem() -> Element? {
        if isEmpty {
            return nil
        }
        let index = Int(arc4random_uniform(UInt32(self.count)))
        return self[index]
    }
}

extension CGFloat {
    static func random() -> CGFloat {
        return CGFloat(arc4random()) / CGFloat(UInt32.max)
    }
    static func random(from start: CGFloat, to end: CGFloat) -> CGFloat {
        return CGFloat(arc4random_uniform(UInt32(end-start))) + start
    }
    func truncate(places : Int) -> CGFloat {
        return CGFloat(floor(pow(10.0, CGFloat(places)) * self)/pow(10.0, CGFloat(places)))
    }
}

extension CGColor {
    static func random() -> CGColor {
        let red = CGFloat.random()
        let green = CGFloat.random()
        let blue = CGFloat.random()
        return CGColor(red: red, green: green, blue: blue, alpha: 1.0)
    }
}
