//
//  NtrConnection.swift
//  Nitro
//
//  Created by Luke Chambers on 6/28/20.
//

import Foundation
import Socket

class NtrConnection {
    let ipAddress: String
    var socket: Socket
    
    var sequence: UInt32 = 0
    
    init(ipAddress: String) {
        self.ipAddress = ipAddress
        socket = try! Socket.create()
    }
    
    func connect() -> Bool {
        do {
            try socket.connect(to: ipAddress, port: 8000)
            print("NTR: Connected!")
        } catch {
            return false
        }
        
        return true
    }
    
    func disconnect() {
        socket.close()
        socket = try! Socket.create()
        print("NTR: Disconnected!")
    }
    
    func sendRemotePlay(quality: UInt32, screenPriority: UInt32, priorityFactor: UInt32) -> Bool {
        let priority = (screenPriority << 8) | priorityFactor
        
        if sendPacket(command: 901, args: [priority, quality, 1966080, 0]) {
            print("NTR: Sent remote play packet!")
            return true
        }
        
        return false
    }
    
    func sendPacket(command: UInt32, args: [UInt32]) -> Bool {
        sequence += 1000
        
        var packet = Data(capacity: 84)
        packet.append(contentsOf: UInt32(0x12345678).bytes)
        packet.append(contentsOf: sequence.bytes)
        packet.append(contentsOf: UInt32(0).bytes)
        packet.append(contentsOf: command.bytes)
        
        for index in 0..<16 {
            let bytes = args.count > index ? args[index].bytes : UInt32(0).bytes
            packet.append(contentsOf: bytes)
        }
        
        packet.append(contentsOf: UInt32(0).bytes)

        do {
            try socket.write(from: packet)
        } catch {
            return false
        }
        
        return true
    }
}

extension UInt32 {
    var bytes: [UInt8] {
        var mutableBigEndian = bigEndian
        let count = MemoryLayout<UInt32>.size
        
        let bytePtr = withUnsafePointer(to: &mutableBigEndian) {
            $0.withMemoryRebound(to: UInt8.self, capacity: count) {
                UnsafeBufferPointer(start: $0, count: count)
            }
        }
        
        return Array(bytePtr).reversed()
    }
}
