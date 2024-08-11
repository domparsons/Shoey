//
//  HealthKitConnectView.swift
//  Shoey
//
//  Created by Dom Parsons on 11/12/2023.
//

import SwiftUI

struct HealthKitConnectView: View {
    var body: some View {
        ScrollView {
            HStack {
                VStack(alignment: .leading) {
                    VStack(alignment: .leading, spacing: 20) {
                        Text("Allow Apple Health access so Shoey can access your workouts")
                            .foregroundStyle(.secondary)
                        
                        Text("1. Go to the Health App.")
                        
                        Image("Icon - Apple Health")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 100)
                            .shadow(radius: 4)
                        
                        HStack {
                            Text("2. Find your profile icon in the top right")
                            Image(systemName: "person.crop.circle")
                                .foregroundColor(.blue)
                        }
                        
                        Text("3. Under privacy, select Apps and Services")
                        
                        Text("4. Find Shoey, and select Turn On All")
                        
                        Text("5. Restart Shoey")
                    }
                }
                Spacer()
            }
            .padding(.horizontal)
            .navigationTitle("Apple Health Guide")
        }
    }
}

#Preview {
    HealthKitConnectView()
}
