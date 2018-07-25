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
        let responseDescriptor = ORSSerialPacketDescriptor(prefixString: "!DIST", suffixString: ";", maximumPacketLength: 10, userInfo: nil)
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
        let idString = dataAsString.substring(with: NSRange(location: 5, length: 1))
        let distanceString = dataAsString.substring(with: NSRange(location: 6, length: dataAsString.length - 7))
        sensorData[Int(idString)!] = Int(distanceString)!
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
    
    // MARK: - Properties
    
    var sensorData: [Int] = [0, 0, 0, 0, 0]
    
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
