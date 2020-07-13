//
//  StreamView.swift
//  Nitro
//
//  Created by Luke Chambers on 6/28/20.
//

import SwiftUI

struct StreamView: View {
    @State private var isStreaming = false
    @State private var isPaused = false
    @State private var topImage = Image("DefaultTop")
    @State private var bottomImage = Image("DefaultBottom")
    
    @State private var isCaptureSheetShowing = false
    @State private var isCaptureErrorShowing = false
    
    @State private var ntrStream: NtrStream? = nil
    
    let captureSaver = CaptureSaver()
    
    var body: some View {
        VStack(spacing: 0) {
            topImage
                .resizable()
                .aspectRatio(contentMode: .fit)
                .layoutPriority(2)
            
            bottomImage
                .resizable()
                .aspectRatio(contentMode: .fit)
                .layoutPriority(1)
            
            Spacer()
            
            HStack(spacing: 20) {
                Button(action: {}) {
                    Image(systemName: "power")
                        .font(.system(size: 24, weight: .bold))
                }
                
                Button(action: {
                    isPaused = true
                    isCaptureSheetShowing = true
                }) {
                    Image(systemName: "camera")
                        .font(.system(size: 24, weight: .bold))
                }
                .alert(isPresented: $isCaptureErrorShowing) {
                    Alert(
                        title: Text("Failed to Capture"),
                        message: Text("An error occurred while capturing the screen. Make sure you gave Nitro permission to save images."),
                        dismissButton: .cancel(Text("OK"))
                    )
                }
                .actionSheet(isPresented: $isCaptureSheetShowing) {
                    ActionSheet(
                        title: Text("Capture"),
                        message: Text("Which screens do you want to save a capture of?"),
                        buttons: [
                            .default(Text("Both Screens")) {
                                isCaptureErrorShowing = captureSaver
                                    .saveBoth(from: ntrStream)
                                isPaused = false
                            },
                            .default(Text("Top Screen")) {
                                isCaptureErrorShowing = captureSaver
                                    .saveTop(from: ntrStream)
                                isPaused = false
                            },
                            .default(Text("Bottom Screen")) {
                                isCaptureErrorShowing = captureSaver
                                    .saveBottom(from: ntrStream)
                                isPaused = false
                            },
                            .cancel() { isPaused = false }
                        ]
                    )
                }
            }
            .padding(.horizontal, 20)
            .padding(.vertical, 10)
            .background(
                RoundedRectangle(cornerRadius: 15)
                    .foregroundColor(Color(.systemFill))
            )
            .padding()
        }
        .statusBar(hidden: true)
        .overlay(
            ZStack {
                if !isStreaming {
                    SettingsView(
                        isStreaming: $isStreaming,
                        isPaused: $isPaused,
                        topImage: $topImage,
                        bottomImage: $bottomImage,
                        ntrStream: $ntrStream
                    )
                }
            }
            .edgesIgnoringSafeArea(.all)
        )
    }
    
    init() {
        UITableView.appearance().backgroundColor = .clear
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        StreamView()
            .previewDevice(PreviewDevice(rawValue: "iPhone 11 Pro"))
    }
}
