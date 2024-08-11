//
//  CircularProgressView.swift
//  Shoey
//
//  Created by Dom Parsons on 12/11/2023.
//

import SwiftUI

struct CircularProgressView: View {
    
    @State var displayedProgress: Double = 0
    
    let progress: Double
    let width: CGFloat
    let color: Color
    
    var body: some View {
        ZStack {
            Circle()
                .stroke(
                    color.opacity(0.5),
                    lineWidth: width
                )
            Circle()
                .trim(from: 0, to: displayedProgress < 0.01 ? 0.01 : displayedProgress)
                .stroke(
                    color,
                    style: StrokeStyle(
                        lineWidth: width,
                        lineCap: .round
                    )
                )
                .rotationEffect(.degrees(-90))
                
                .onAppear {
                    withAnimation(.easeInOut(duration: 0.7)) {
                        displayedProgress = progress
                    }
                }
        }
    }
}

#Preview {
    CircularProgressView(progress: 0.5, width: 8, color: .white)
}
