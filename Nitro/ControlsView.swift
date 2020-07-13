//
//  ControlsView.swift
//  Nitro
//
//  Created by Luke Chambers on 7/2/20.
//

import SwiftUI

/*
 This file is unused! I ran into issues when trying to fit
 all of this onto a small iPhone screen, so for now there
 are no touch controls.
 */
struct ControlsView: View {
    var body: some View {
        VStack {
            HStack(alignment: .top) {
                RoundedRectangle(cornerRadius: 10)
                    .frame(width: 50, height: 30)
                    .foregroundColor(Color(.systemFill))
                    .overlay(
                        Text("L")
                            .foregroundColor(Color(.systemBackground))
                            .font(.system(size: 22, weight: .bold))
                    )
                
                RoundedRectangle(cornerRadius: 10)
                    .frame(width: 50, height: 25)
                    .foregroundColor(Color(.systemFill))
                    .overlay(
                        Text("ZL")
                            .foregroundColor(Color(.systemBackground))
                            .font(.system(size: 18, weight: .bold))
                    )
                
                Spacer()
                
                RoundedRectangle(cornerRadius: 10)
                    .frame(width: 50, height: 25)
                    .foregroundColor(Color(.systemFill))
                    .overlay(
                        Text("ZR")
                            .foregroundColor(Color(.systemBackground))
                            .font(.system(size: 18, weight: .bold))
                    )
                
                RoundedRectangle(cornerRadius: 10)
                    .frame(width: 50, height: 30)
                    .foregroundColor(Color(.systemFill))
                    .overlay(
                        Text("R")
                            .foregroundColor(Color(.systemBackground))
                            .font(.system(size: 22, weight: .bold))
                    )
            }
            
            Spacer()
            
            HStack(alignment: .top) {
                VStack {
                    CirclePad()
                    DPad()
                }
                
                Spacer()
                ABXY()
            }
            
            HStack {
                RoundedRectangle(cornerRadius: 25)
                    .frame(width: 75, height: 25)
                    .foregroundColor(Color(.systemFill))
                    .overlay(
                        Text("SELECT")
                            .foregroundColor(Color(.systemBackground))
                            .font(.system(size: 14, weight: .bold))
                    )
                
                RoundedRectangle(cornerRadius: 25)
                    .frame(width: 50, height: 25)
                    .foregroundColor(Color(.systemFill))
                    .overlay(
                        VStack(spacing: 0) {
                            Triangle()
                                .frame(width: 20, height: 10)
                                .foregroundColor(Color(.systemBackground))
                            
                            Rectangle()
                                .frame(width: 15, height: 10)
                                .foregroundColor(Color(.systemBackground))
                                .overlay(
                                    Rectangle()
                                        .frame(width: 7.5, height: 6.25)
                                        .foregroundColor(Color(.systemFill)),
                                    alignment: .top
                                )
                        }
                    )
                
                RoundedRectangle(cornerRadius: 25)
                    .frame(width: 75, height: 25)
                    .foregroundColor(Color(.systemFill))
                    .overlay(
                        Text("START")
                            .foregroundColor(Color(.systemBackground))
                            .font(.system(size: 14, weight: .bold))
                    )
            }
        }
        .padding(.horizontal)
        .padding(.vertical, 5)
    }
}

struct CirclePad: View {
    var body: some View {
        Circle()
            .frame(width: 125, height: 125)
            .foregroundColor(.clear)
            .overlay(
                Circle()
                    .frame(width: 75, height: 75)
                    .foregroundColor(Color(.lightGray))
            )
    }
}

struct DPad: View {
    var body: some View {
        HStack(spacing: 0) {
            Rectangle()
                .frame(width: 35, height: 35)
                .foregroundColor(Color(.systemFill))
                .overlay(
                    Rectangle()
                        .frame(width: 22.5, height: 3)
                        .foregroundColor(Color(.lightGray)),
                    alignment: .trailing
                )
            
            VStack(spacing: 0) {
                Rectangle()
                    .frame(width: 35, height: 35)
                    .foregroundColor(Color(.systemFill))
                    .overlay(
                        Rectangle()
                            .frame(width: 3, height: 22.5)
                            .foregroundColor(Color(.lightGray)),
                        alignment: .bottom
                    )
                
                Rectangle()
                    .frame(width: 35, height: 35)
                    .foregroundColor(Color(.systemFill))
                
                Rectangle()
                    .frame(width: 35, height: 35)
                    .foregroundColor(Color(.systemFill))
                    .overlay(
                        Rectangle()
                            .frame(width: 3, height: 22.5)
                            .foregroundColor(Color(.lightGray)),
                        alignment: .top
                    )
            }
            
            Rectangle()
                .frame(width: 35, height: 35)
                .foregroundColor(Color(.systemFill))
                .overlay(
                    Rectangle()
                        .frame(width: 22.5, height: 3)
                        .foregroundColor(Color(.lightGray)),
                    alignment: .leading
                )
        }
    }
}

struct ABXY: View {
    var body: some View {
        VStack(spacing: 0) {
            Circle()
                .frame(width: 50, height: 50)
                .foregroundColor(Color(.systemFill))
                .overlay(
                    Text("X")
                        .font(.system(size: 28, weight: .bold))
                        .foregroundColor(
                            Color(red: 63 / 255, green: 124 / 255, blue: 185 / 255)
                        )
                )
            
            HStack(spacing: 0) {
                Circle()
                    .frame(width: 50, height: 50)
                    .foregroundColor(Color(.systemFill))
                    .overlay(
                        Text("Y")
                            .font(.system(size: 28, weight: .bold))
                            .foregroundColor(
                                Color(red: 34 / 255, green: 120 / 255, blue: 94 / 255)
                            )
                    )
                
                Rectangle()
                    .frame(width: 50, height: 50)
                    .foregroundColor(.clear)
                
                Circle()
                    .frame(width: 50, height: 50)
                    .foregroundColor(Color(.systemFill))
                    .overlay(
                        Text("A")
                            .font(.system(size: 28, weight: .bold))
                            .foregroundColor(
                                Color(red: 214 / 255, green: 120 / 255, blue: 128 / 255)
                            )
                    )
            }
            
            Circle()
                .frame(width: 50, height: 50)
                .foregroundColor(Color(.systemFill))
                .overlay(
                    Text("B")
                        .font(.system(size: 28, weight: .bold))
                        .foregroundColor(
                            Color(red: 185 / 255, green: 173 / 255, blue: 78 / 255)
                        )
                )
        }
    }
}

struct Triangle: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        
        path.move(to: CGPoint(x: rect.midX, y: rect.minY))
        path.addLine(to: CGPoint(x: rect.minX, y: rect.maxY))
        path.addLine(to: CGPoint(x: rect.maxX, y: rect.maxY))
        path.addLine(to: CGPoint(x: rect.midX, y: rect.minY))
        
        return path
    }
}

struct ControlsView_Previews: PreviewProvider {
    static var previews: some View {
        VStack {
            Spacer()
            ControlsView()
        }
        .edgesIgnoringSafeArea(.bottom)
        .previewDevice(PreviewDevice(rawValue: "iPhone 11 Pro"))
    }
}
