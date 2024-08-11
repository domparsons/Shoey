//
//  ShoeListView.swift
//  Shoey
//
//  Created by Dom Parsons on 27/11/2023.
//

import SwiftUI

struct ShoeListView: View {
    
    @EnvironmentObject var viewModel: ViewModel
    
    @Environment(\.colorScheme) var colorScheme
    
    @State private var startAnimation: Bool = false
    
    var retired: Bool
    var shoes: [Shoe]
    
    var body: some View {
        ForEach(retired ? shoes.filter { $0.retired } : shoes.filter { !$0.retired }) { shoe in
            NavigationLink {
                ShoeDetailView(shoe: shoe)
                    .environmentObject(viewModel)
            } label: {
                ZStack {
                    if colorScheme == .dark {
                        LinearGradient(colors: [.white.opacity(0.6), .white.opacity(0.4)], startPoint: .topLeading, endPoint: .bottomTrailing)
                    } else {
                        LinearGradient(colors: [.black.opacity(0.3), .black.opacity(0.2)], startPoint: .topLeading, endPoint: .bottomTrailing)
                    }
                    
                    HStack {
                        VStack(alignment: .leading) {
                            Text(shoe.shoeNickname)
                                .font(.title2)
                            Text("\(String(format: "%.0f", abs(shoe.currentMileage))) km")
                        }
                        .foregroundStyle(.white)
                        
                        Spacer()
                        
                        CircularProgressView(progress: (shoe.currentMileage/shoe.mileageLimit), width: 8, color: .white)
                            .frame(width: 45, height: 45)
                            .padding(.trailing, 10)
                    }
                    .padding()
                    
                }
                .clipShape(RoundedRectangle(cornerRadius: 15))
            }
        }
        
        if !retired && (shoes.filter { !$0.retired } == []) {
            VStack {
                Text("No shoes")
                    .font(.title2)
                    .foregroundStyle(.secondary)
                HStack {
                    Text("Get started with the")
                        .foregroundStyle(.secondary)
                    Image(systemName: "plus")
                        .foregroundStyle(.secondary)
                }
            }
            .padding(.top, 50)
        }
        
        if retired && (shoes.filter { $0.retired } == []) {
            VStack {
                Text("No retired shoes")
                    .font(.title2)
                    .foregroundStyle(.secondary)
            }
            .padding(.top, 50)
        }
    }
}

#Preview {
    ShoeListView(retired: false, shoes: [Shoe(shoeNickname: "Nice", shoeModel: "Nike", colour: "Red", currentMileage: 150.0, mileageLimit: 400.0, retired: false, workouts: [])])
}
