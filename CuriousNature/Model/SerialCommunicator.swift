//
//  Serial.swift
//  Thirty Objects
//
//  Created by Sam Richardson on 7/1/18.
//  Copyright © 2018 Sam Richardson. All rights reserved.
//

import Cocoa
import ORSSerial

class SerialCommunicator: NSObject, ORSSerialPortDelegate {

    static let kTimeoutDuration = 0.5
    
    enum SerialBoardRequestType: Int {
        case readDistance = 1
    }
    
    // MARK: - Private Methods
    
    func pollingTimerFired() {
        self.readDistance()
    }
    
    // MARK: Sending Commands
    
    fileprivate func readDistance() {
        let command = "$DIST?;".data(using: String.Encoding.ascii)!
        let responseDescriptor = ORSSerialPacketDescriptor(prefixString: "!DIST", suffixString: ";", maximumPacketLength: 40, userInfo: nil)
        let request = ORSSerialRequest(dataToSend: command, userInfo: SerialBoardRequestType.readDistance.rawValue, timeoutInterval: 0.5, responseDescriptor: responseDescriptor)
        self.serialPort?.send(request)
    }
    
    // MARK: - Parsing Responses
    
    fileprivate func distanceFromResponsePacket(_ data: Data) {
        let dataAsString = NSString(data: data, encoding: String.Encoding.ascii.rawValue)!
        if dataAsString.length < 6 || !dataAsString.hasPrefix("!DIST") || !dataAsString.hasSuffix(";") {
            print("Invalid serial data")
            return
        }
        
        let distanceString = dataAsString.substring(with: NSRange(location: 5, length: dataAsString.length - 6))
        let distanceArray = distanceString.components(separatedBy: ".")
        for i in 0..<distanceArray.count {
            sensorData[i] = Int(distanceArray[i])!
        }
        
//        let idString = dataAsString.substring(with: NSRange(location: 5, length: 1))
//        let distanceString = dataAsString.substring(with: NSRange(location: 6, length: dataAsString.length - 7))
//        sensorData[Int(idString)!] = Int(distanceString)!
    }
    
    // MARK: - ORSSerialPortDelegate
    
    func serialPortWasRemovedFromSystem(_ serialPort: ORSSerialPort) {
        self.serialPort = nil
    }
    
    func serialPort(_ serialPort: ORSSerialPort, didEncounterError error: Error) {
        print("Serial port \(serialPort) encountered an error: \(error)")
    }
    
    func serialPort(_ serialPort: ORSSerialPort, didReceiveResponse responseData: Data, to request: ORSSerialRequest) {
        let requestType = SerialBoardRequestType(rawValue: request.userInfo as! Int)!
        if requestType == .readDistance {
            self.distanceFromResponsePacket(responseData)
        }
    }
    
    func serialPortWasOpened(_ serialPort: ORSSerialPort) {
        print("Serial port was opened")
        return
    }
    
    func serialPortWasClosed(_ serialPort: ORSSerialPort) {
        return
    }
    
    // MARK: - Input Monitoring
    
    func checkIfInRange() -> Bool {
        var anyInRange = false
        for i in 0..<sensorData.count {
            if sensorData[i] <= sensorRange && sensorData[i] > 0 {
                sensorInRange[i] = true
                anyInRange = true
            } else {
                sensorInRange[i] = false
            }
        }
        return anyInRange
    }
    
    func triggerInteraction() {
        if averageSensorInput != 0 {
            if averageSensorInput <= sensorRange {
                //allTriggerState.setState()
                if (state.activeRange < 300) {
                    state.activeRange += 1
                    state.activeRangeSquared = state.activeRange * state.activeRange
                }
            } else if checkIfInRange() {
                //singleTriggerState.setState()
                if (state.activeRange < 100) {
                    state.activeRange += 3
                    state.activeRangeSquared = state.activeRange * state.activeRange
                }
            } else {
                //defaultState.setState()
                if (state.activeRange > 75) {
                    state.activeRange -= 2
                    state.activeRangeSquared = state.activeRange * state.activeRange
                }
            }
            print(state.activeRange)
        }
    }
    
    // MARK: - Properties
    
    var sensorData: [Int] = [0, 0, 0, 0, 0]
    var sensorInRange: [Bool] = [false, false, false, false, false]
    let sensorRange = 200
    var defaultState = FlockProperties()
    var singleTriggerState = FlockProperties(sep: 2.0, ali: 0.0, coh: 1.0)
    var allTriggerState = FlockProperties(sep: 3.0, ali: -1.0, coh: 1.0)
    
    lazy var averageSensorInput: Int = {
        let sum = sensorData.reduce(0, +)
        var count = 0
        for i in 0..<sensorData.count {
            if sensorData[i] > 0 {
                count += 1
            }
        }
        if count != 0 {
            return sum / count
        } else {
            return 400
        }
    }()
    
    var serialPort: ORSSerialPort? {
        willSet {
            if let port = serialPort {
                port.close()
                port.delegate = nil
            }
        }
        didSet {
            if let port = serialPort {
                // /dev/cu.usbmodem1411
                port.baudRate = 57600
                port.delegate = self
                port.rts = true
                port.open()
                print("Serial port was set")
            }
        }
    }
    
}
