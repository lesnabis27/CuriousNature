//
//  Vector.swift
//  CuriousNature
//
//  Created by Sam Richardson on 4/7/18.
//  Copyright © 2018 Sam Richardson. All rights reserved.
//

import Foundation

precedencegroup DotProductPrecedence {
    lowerThan: AdditionPrecedence
    associativity: left
}
infix operator •: DotProductPrecedence

extension FloatingPoint {
    var degreesToRadians: Self {return self * .pi / 180}
    var radiansToDegrees: Self {return self * 180 / .pi}
}

public struct Vector: ExpressibleByArrayLiteral, CustomStringConvertible, Equatable {
    public var x: Double, y: Double, z: Double
    
    public var description: String {
        return "(\(x), \(y), \(z))"
    }
    
    public init() {
        x = 0.0
        y = 0.0
        z = 0.0
    }
    
    public init(_ x: Double, _ y: Double) {
        self.x = x
        self.y = y
        self.z = -0.0
    }
    
    public init(_ x: Double, _ y: Double, _ z: Double) {
        self.x = x
        self.y = y
        self.z = z
    }
    
    public init(arrayLiteral: Double...) {
        let count = arrayLiteral.count
        assert(count == 2 || count == 3, "Must initialize vector with two or three values")
        x = arrayLiteral[0]
        y = arrayLiteral[1]
        z = count == 3 ? arrayLiteral[2] : 0.0
    }
    
    public init(fromAngle theta: Double, magnitude: Double) {
        x = magnitude * cos(theta)
        y = magnitude * sin(theta)
        z = 0.0;
    }
    
    public static func +(left: Vector, right: Vector) -> Vector {
        return [left.x + right.x, left.y + right.y, left.z + right.z]
    }
    
    public static func +=(left: inout Vector, right: Vector) {
        left = left + right
    }
    
    public static prefix func +(vector: Vector) -> Vector {
        return [vector.x, vector.y]
    }
    
    public static prefix func -(vector: Vector) -> Vector {
        return [-vector.x, -vector.y, -vector.z]
    }
    
    public static func -(left: Vector, right: Vector) -> Vector {
        return left + -right
    }
    
    public static func -=(left: inout Vector, right: Vector) {
        left = left - right
    }
    
    public static func *(left: Vector, right: Double) -> Vector {
        return [left.x * right, left.y * right, left.z * right]
    }
    
    public static func *(left: Double, right: Vector) -> Vector {
        return right * left
    }
    
    public static func *=(left: inout Vector, right: Double) {
        left = left * right
    }
    
    public static func *(left: Vector, right: Vector) -> Vector {
        return [left.y * right.z - left.z * right.y, left.z * right.x - left.x * right.z, left.x * right.y - left.y * right.x]
    }
    
    public static func *=(left: inout Vector, right: Vector) {
        left = left * right
    }
    
    public static func •(left: Vector, right: Vector) -> Double {
        return left.x * right.x + left.y * right.y + left.z * right.z
    }
    
    public static func /(left: Vector, right: Double) -> Vector {
        return [left.x/right, left.y/right, left.z/right]
    }
    
    public static func /=(left: inout Vector, right: Double) {
        left = left/right
    }
    
    public static func ==(left: Vector, right: Vector) -> Bool {
        return left.x == right.x && left.y == right.y && left.z == right.z
    }
    
    public var isZero: Bool {
        return x == 0.0 && y == 0.0 && z == 0.0
    }
    
    public var magnitude: Double {
        get {
            return sqrt(x * x + y * y + z * z)
        }
        set(newMagnitude) {
            self = normalize() * newMagnitude
        }
    }
    
    public var magnitudeSquared: Double {
        return x * x + y * y + z * z
    }
    
    public var heading: Double {
        get {
            if isZero {
                return 0.0
            }
            return atan(x/y)
        }
        set(newHeading) {
            let theta = heading - newHeading
            self = self.rotate(theta)
        }
    }
    
    public func normalize() -> Vector {
        if !isZero {
            return [x/magnitude, y/magnitude, z/magnitude]
        }
        return [x, y, z]
    }
    
    public func limit(_ max: Double) -> Vector {
        if magnitude > max {
            return normalize() * max
        }
        return self
    }
    
    public func rotate(_ theta: Double) -> Vector {
        var result: Vector = [x, y, z]
        result.x = x * cos(theta) - y * sin(theta)
        result.y = x * sin(theta) + y * cos(theta)
        return result
    }
    
    public func angleBetween(_ other: Vector) -> Double {
        if isZero || other.isZero {
            return 0.0
        }
        return other.heading - heading
    }
    
    public func linearInterpolate(to other: Vector, amount: Double) -> Vector {
        let x = self.x + (other.x - self.x) * amount
        let y = self.y + (other.y - self.y) * amount
        let z = self.z + (other.z - self.z) * amount
        return [x, y, z]
    }
    
    public func distanceTo(_ other: Vector) -> Double {
        let temp: Vector = [x - other.x, y - other.y]
        return temp.magnitude
    }
    
    public func random2D() -> Vector {
        let tau = UInt32(Double.pi * 2)
        return Vector(fromAngle: Double(arc4random_uniform(tau)), magnitude: Double(arc4random_uniform(tau)))
    }
    
    public func toCGPoint() -> CGPoint {
        return CGPoint(x: x, y: y)
    }
    
}
