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
    
    deinit {
        self.serialPort = nil
    }
    
    // MARK: - ORSSerialPortDelegate
    
    func serialPortWasRemovedFromSystem(_ serialPort: ORSSerialPort) {
        self.serialPort = nil
    }
    
    func serialPort(_ serialPort: ORSSerialPort, didEncounterError error: Error) {
        print("Serial port \(serialPort) encountered an error: \(error)")
    }
    
    func serialPortWasOpened(_ serialPort: ORSSerialPort) {
        let descriptor = ORSSerialPacketDescriptor(prefixString: "!pos", suffixString: ";", maximumPacketLength: 8, userInfo: nil)
        serialPort.startListeningForPackets(matching: descriptor)
    }
    
    func serialPort(_ serialPort: ORSSerialPort, didReceivePacket packetData: Data, matching descriptor: ORSSerialPacketDescriptor) {
        if let dataAsString = NSString(data: packetData, encoding: String.Encoding.ascii.rawValue) {
            let valueString = dataAsString.substring(with: NSRange(location: 4, length: dataAsString.length-5))
            print(valueString)
        }
    }
    
    // MARK: - Properties
    
    @objc dynamic var serialPort: ORSSerialPort? {
        willSet {
            if let port = serialPort {
                port.close()
                port.delegate = nil
            }
        }
        didSet {
            if let port = serialPort {
                port.baudRate = 9600
                port.rts = true
                port.delegate = self
                port.open()
            }
        }
    }
    
}
