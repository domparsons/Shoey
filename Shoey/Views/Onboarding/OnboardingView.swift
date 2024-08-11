//
//  OnboardingView.swift
//  Shoey
//
//  Created by Dom Parsons on 13/12/2023.
//

import SwiftUI

struct OnboardingView: View {
    
    @EnvironmentObject var viewModel: ViewModel
    
    var body: some View {
        ZStack {
            LinearGradient(colors: [.blue.opacity(0.8), .blue.opacity(0.5)], startPoint: .topLeading, endPoint: .bottomTrailing)
                .ignoresSafeArea()
            
            VStack {
                
                VStack {
                    Text("Welcome To Shoey")
                        .font(.title.bold())
                }
                
                Spacer()
                
                VStack(alignment: .leading, spacing: 20) {
                    Text("Save your favourite shoes")
                    Image(systemName: "shoe.2")
                    Text("Import workouts from your Apple Watch")
                    Image(systemName: "applewatch")
                    Text("Track your shoe mileage")
                    Image(systemName: "figure.run")
                }
                
                Spacer()
                
                VStack {
                    Button {
                        viewModel.onboardingPhase = "AuthoriseHKView"
                    } label: {
                        Text("Get started")
                            
                    }
                    .font(.title3.bold())
                    .padding(.horizontal, 80)
                    .padding(.vertical, 25)
                    .background(.blue)
                    .foregroundStyle(.white)
                    .clipShape(RoundedRectangle(cornerRadius: 25))
                    .padding()
                }
            }
            .padding(.vertical, 40)
            .foregroundStyle(.white)
        }
        
        
    }
}

#Preview {
    OnboardingView()
}
