//
//  RetiredShoesView.swift
//  Shoey
//
//  Created by Dom Parsons on 26/11/2023.
//

import SwiftUI
import SwiftData

struct RetiredShoesView: View {
    
    @EnvironmentObject var viewModel: ViewModel
    
    @Environment(\.modelContext) private var context
    
    @Query private var shoes: [Shoe]
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack {
                    Group {
                        ShoeListView(retired: true, shoes: shoes)
                    }
                    .padding(.bottom, 10)
                }
                .padding()
            }
            .navigationTitle("Retired Shoes")
        }
    }
}

#Preview {
    RetiredShoesView()
}
