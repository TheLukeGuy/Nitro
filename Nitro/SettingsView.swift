//
//  SettingsView.swift
//  Nitro
//
//  Created by Luke Chambers on 7/2/20.
//

import SwiftUI
import UIKit

struct SettingsView: View {
    @Binding var isStreaming: Bool
    @Binding var isPaused: Bool
    @Binding var topImage: Image
    @Binding var bottomImage: Image
    
    @Binding var ntrStream: NtrStream?
    
    @AppStorage("ipAddress") private var ipAddress = ""
    @AppStorage("quality") private var quality = 90.0
    @AppStorage("screenPriority") private var screenPriority = 1
    @AppStorage("priorityFactor") private var priorityFactor = 5
    
    @State private var connectMessage = "Ready to connect."
    
    var body: some View {
        List {
            Section(footer: Text(connectMessage)) {
                HStack {
                    TextField("IP Address", text: $ipAddress)
                    
                    Button("Connect") {
                        DispatchQueue.global(qos: .background).async {
                            connect()
                        }
                    }
                    .buttonStyle(BorderlessButtonStyle())
                    .disabled(ipAddress.trimmingCharacters(in: .whitespaces) == "")
                }
            }
            
            Section {}
            
            Section(header: Text("Stream Quality")) {
                HStack {
                    Text(String(format: "%.0f", quality) + "%")
                    
                    Slider(value: $quality, in: 1...100, step: 1)
                }
            }
            
            Section(header: Text("Screen Priority")) {
                Picker("Priority", selection: $screenPriority) {
                    Text("Top").tag(1)
                    Text("Bottom").tag(0)
                }
                .pickerStyle(SegmentedPickerStyle())
                
                Stepper(value: $priorityFactor) {
                    Text("Priority Factor:")
                    Text(String(priorityFactor))
                }
            }
        }
        .listStyle(InsetGroupedListStyle())
        .background(Color(.systemGroupedBackground).opacity(0.8))
    }
    
    private func connect() {
        connectMessage = "Preparing to connect to NTR..."
        let connection = NtrConnection(ipAddress: ipAddress)
        
        connectMessage = "Connecting to NTR..."
        if !connection.connect() {
            connectMessage = "Failed to connect to NTR. Ensure the 3DS is on and booted into NTR CFW."
            return
        }
        
        connectMessage = "Sending remote play packet to NTR..."
        if !connection.sendRemotePlay(
            quality: UInt32(quality),
            screenPriority: UInt32(screenPriority),
            priorityFactor: UInt32(priorityFactor)
        ) {
            connectMessage = "Failed to send the remote play packet to NTR."
            return
        }
        
        connectMessage = "Disconnecting from NTR..."
        connection.disconnect()
        
        connectMessage = "Waiting 3 seconds before reconnecting to NTR..."
        sleep(3)
        
        connectMessage = "Reconnecting to NTR..."
        if !connection.connect() {
            connectMessage = "Failed to reconnect to NTR. Ensure the 3DS is still on and booted into NTR CFW."
            return
        }
        
        connectMessage = "Disconnecting from NTR again to save bandwidth..."
        connection.disconnect()
        
        connectMessage = "Preparing to stream..."
        ntrStream = NtrStream(ipAddress: ipAddress)
        
        connectMessage = "Starting to listen for stream packets..."
        if !ntrStream!.startListening() {
            connectMessage = "Failed to start listening for stream packets."
            return
        }
        
        connectMessage = "Starting stream..."
        ntrStream!.stream(
            isStreaming: $isStreaming,
            isPaused: $isPaused,
            topImage: $topImage,
            bottomImage: $bottomImage
        )
        
        while !isStreaming { continue }
        connectMessage = "Ready to connect."
    }
}

struct SettingView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView(
            isStreaming: Binding.constant(false),
            isPaused: Binding.constant(false),
            topImage: Binding.constant(Image("DefaultTop")),
            bottomImage: Binding.constant(Image("DefaultBottom")),
            ntrStream: Binding.constant(nil)
        )
        .previewDevice(PreviewDevice(rawValue: "iPhone 11 Pro"))
    }
}
