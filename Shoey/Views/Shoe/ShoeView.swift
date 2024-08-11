//
//  ShoeView.swift
//  Shoey
//
//  Created by Dom Parsons on 10/12/2023.
//

import SwiftUI
import SwiftData

struct ShoeView: View {
    
    @EnvironmentObject var viewModel: ViewModel
    
    @Environment(\.modelContext) private var context
    @Environment(\.colorScheme) var colorScheme
    
    @Query private var shoes: [Shoe]
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack {
                    Group {
                        ShoeListView(retired: false, shoes: shoes)
                    }
                    .padding(.bottom, 10)
                }
                .padding()
            }
            .navigationTitle("My Shoes")
            .toolbar {
                ToolbarItem {
                    Button {
                        viewModel.showingAddNewShoeView = true
                    } label: {
                        Image(systemName: "plus")
                    }
                }
            }
            .sheet(isPresented: $viewModel.showingAddNewShoeView) {
                NewShoeSheet()
                    .environmentObject(viewModel)
            }
            .sheet(isPresented: $viewModel.newWorkoutsOnLoad) {
                NewWorkoutsSheet()
                    .environmentObject(viewModel)
            }
        }
    }
}

#Preview {
    ShoeView()
}
