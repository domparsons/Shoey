//
//  AuthoriseHKView.swift
//  Shoey
//
//  Created by Dom Parsons on 11/12/2023.
//

import SwiftUI

struct AuthoriseHKView: View {
    @EnvironmentObject var healthKitManager: HealthKitManager
    @EnvironmentObject var viewModel: ViewModel
    
    
    var body: some View {
        ZStack {
            LinearGradient(colors: [.blue.opacity(0.8), .blue.opacity(0.5)], startPoint: .topLeading, endPoint: .bottomTrailing)
                .ignoresSafeArea()
            VStack {
                Spacer()
                HStack {
                    VStack(alignment: .leading) {
                        Image("Icon - Apple Health")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 100)
                            .padding(.bottom, 20)
                        
                        Text("Automatically sync your workouts from Apple Health")
                            .font(.title.bold())
                            .foregroundStyle(.white)
                    }
                    .padding(.horizontal, 20)
                    
                    Spacer()
                }
                Button("Authorise Health Access") {
                    healthKitManager.requestAuthorization()
                }
                .font(.title3.bold())
                .padding(.horizontal, 30)
                .padding(.vertical, 25)
                .background(.blue)
                .foregroundStyle(.white)
                .clipShape(RoundedRectangle(cornerRadius: 25))
                .padding(.top, 40)

                Spacer()
            }
        }
        .tint(.white)
    }
}

#Preview {
    AuthoriseHKView()
}
