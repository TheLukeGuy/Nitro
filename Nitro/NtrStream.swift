//
//  NtrStream.swift
//  Nitro
//
//  Created by Luke Chambers on 6/29/20.
//

import Foundation
import SwiftUI
import Socket

class NtrStream {
    let ipAddress: String
    var socket: Socket
    
    var uiTopImage: UIImage? = nil
    var uiBottomImage: UIImage? = nil
    
    init(ipAddress: String) {
        self.ipAddress = ipAddress
        socket = try! Socket.create(family: .inet, type: .datagram, proto: .udp)
    }
    
    func startListening() -> Bool {
        do {
            try socket.listen(on: 8001)
            print("Stream: Started listening!")
        } catch {
            return false
        }
        
        return true
    }
    
    func stopListening() {
        socket.close()
        socket = try! Socket.create(family: .inet, type: .datagram, proto: .udp)
        print("Stream: Stopped listening!")
    }
    
    func stream(
        isStreaming: Binding<Bool>,
        isPaused: Binding<Bool>,
        topImage: Binding<Image>,
        bottomImage: Binding<Image>
    ) {
        withAnimation {
            isStreaming.wrappedValue = true
        }
        
        var secondsWithoutUpdate = 0
        DispatchQueue.global(qos: .background).async {
            while true {
                sleep(1)
                secondsWithoutUpdate += 1
                
                if secondsWithoutUpdate >= 5 {
                    withAnimation {
                        isStreaming.wrappedValue = false
                    }
                    
                    isPaused.wrappedValue = false
                    break
                }
            }
        }
        
        while true {
            var jpeg = Data()
            var returned = -1
            
            var stillConnected = true
            while returned == -1 {
                jpeg.removeAll()
                
                func readJpeg() throws -> Int {
                    var buffer = Data()
                    
                    var bytes = try socket.readDatagram(into: &buffer).bytesRead
                    
                    let currentId = buffer.first
                    var expkt = 0
                    repeat {
                        jpeg.append(buffer.suffix(bytes - 4))
                        
                        if (buffer[1] & 0xf0) == 0x10 { break }
                        
                        buffer.removeAll()
                        bytes = try socket.readDatagram(into: &buffer).bytesRead
                        
                        expkt += 1
                        if expkt != buffer[3] { return -1 }
                    } while buffer[0] == currentId
                    
                    if jpeg.prefix(2) != Data([255, 216]) || jpeg.suffix(2) != Data([255, 217]) {
                        return -1
                    }
                    
                    return Int(buffer[1] & 0x0f)
                }
                
                do {
                    returned = try readJpeg()
                } catch {
                    stillConnected = false
                    break
                }
            }
            
            if (!stillConnected) { break }
            
            secondsWithoutUpdate = 0
            if (isPaused.wrappedValue) { continue }
            
            var uiImage = UIImage(data: jpeg)
            uiImage = UIImage(
                cgImage: uiImage!.cgImage!,
                scale: 1,
                orientation: .left
            )
            
            if returned == 1 {
                topImage.wrappedValue = Image(uiImage: uiImage!)
                uiTopImage = uiImage
            } else if returned == 0 {
                bottomImage.wrappedValue = Image(uiImage: uiImage!)
                uiBottomImage = uiImage
            } else {
                break
            }
        }
        
        stopListening()
        
        withAnimation {
            isStreaming.wrappedValue = false
        }
        
        isPaused.wrappedValue = false
    }
}
