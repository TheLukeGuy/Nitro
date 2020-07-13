//
//  StreamView.swift
//  Nitro
//
//  Created by Luke Chambers on 6/28/20.
//

import SwiftUI

struct StreamView: View {
    @State private var isStreaming = true
    @State private var topImage = Image("DefaultTop")
    @State private var bottomImage = Image("DefaultBottom")
    
    var body: some View {
        VStack(spacing: 0) {
            topImage
                .resizable()
                .aspectRatio(contentMode: .fit)
            
            bottomImage
                .resizable()
                .aspectRatio(contentMode: .fit)
            
            HStack {
                VStack(spacing: 15) {
                    Circle()
                        .frame(width: 75, height: 75)
                        .foregroundColor(Color(.systemFill))
                        .overlay(
                            Circle()
                                .frame(width: 50, height: 50)
                                .foregroundColor(Color(.lightGray))
                        )
                    
                    HStack(alignment: .center, spacing: 0) {
                        Rectangle()
                            .frame(width: 22.5, height: 22.5)
                            .foregroundColor(Color(.systemFill))
                        
                        VStack(spacing: 0) {
                            Rectangle()
                                .frame(width: 22.5, height: 22.5)
                                .foregroundColor(Color(.systemFill))
                            
                            Rectangle()
                                .frame(width: 22.5, height: 22.5)
                                .foregroundColor(Color(.systemFill))
                            
                            Rectangle()
                                .frame(width: 22.5, height: 22.5)
                                .foregroundColor(Color(.systemFill))
                        }
                        
                        Rectangle()
                            .frame(width: 22.5, height: 22.5)
                            .foregroundColor(Color(.systemFill))
                    }
                }
                
                Spacer()
            }
            .padding()
            
            Spacer()
        }
        .statusBar(hidden: true)
        .edgesIgnoringSafeArea(.bottom)
        .overlay(
            ZStack {
                if !isStreaming {
                    SettingsView(
                        isStreaming: $isStreaming,
                        topImage: $topImage,
                        bottomImage: $bottomImage
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
