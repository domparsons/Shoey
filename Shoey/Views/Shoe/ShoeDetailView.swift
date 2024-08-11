//
//  ShoeDetailView.swift
//  Shoey
//
//  Created by Dom Parsons on 13/11/2023.
//

import SwiftUI

struct ShoeDetailView: View {
    
    @EnvironmentObject var viewModel: ViewModel
    
    @Environment(\.modelContext) var context
    @Environment(\.colorScheme) var colorScheme
    
    @State private var showingDeleteWorkoutAlert = false
    @State private var workoutToDelete: Workout?
    
    var shoe: Shoe
    
    var body: some View {
        GeometryReader { geo in
            ScrollView {
                VStack {
                    HStack(alignment: .top) {
                        VStack {
                            HStack {
                                VStack (alignment: .leading) {
                                    Text("\(shoe.shoeModel) · \(shoe.colour)")
                                        .foregroundStyle(.secondary)
                                }
                                Spacer()
                            }
                            ZStack {
                                CircularProgressView(progress: shoe.currentMileage / shoe.mileageLimit, width: 20, color: colorScheme == .dark ? .white : .gray)
                                    .frame(width: geo.size.width * 0.7)
                                
                                HStack(alignment: .center) {
                                    VStack(alignment: .center) {
                                        Text("\(String(format: "%.0f", abs(shoe.currentMileage))) km")
                                            .font(.title)
                                        if (shoe.mileageLimit - shoe.currentMileage <= 0) {
                                            Text("\(String(format: "%.0f", abs(shoe.mileageLimit - shoe.currentMileage))) over limit")
                                        } else {
                                            Text("\(String(format: "%.0f", shoe.mileageLimit - shoe.currentMileage)) km remaining")
                                        }
                                        Button {
                                            shoe.retired.toggle()
                                        } label: {
                                            Text(shoe.retired ? "Unretire Shoe" : "Retire Shoe")
                                                .foregroundStyle(.blue)
                                        }
                                    }
                                }
                            }
                            .padding(.vertical, 30)
                        }
                    }
                    .padding(.horizontal)
                    
                    VStack(spacing: 10) {
                        HStack {
                            if shoe.workouts != [] {
                                Text("Workouts")
                                    .font(.title2.bold())
                                Spacer()
                            }
                        }
                        ForEach(shoe.workouts ?? []) { workout in
                            HStack {
                                Image(systemName: "figure.run")
                                VStack(alignment: .leading) {
                                    Text("\(String(format: "%.2f", workout.distance)) km run")
                                    Text("\(workout.dateAndTime ?? Date(), formatter: AppDateFormatter.workoutFormatter)")
                                        .font(.caption)
                                        .foregroundStyle(.secondary)
                                }
                                .padding(.leading, 10)
                                Spacer()
                                
                                Button {
                                    workoutToDelete = workout
                                    showingDeleteWorkoutAlert = true
                                } label : {
                                    ZStack {
                                        Image(systemName: "link")
                                            .foregroundStyle(.red)
                                    }
                                }
                            }
                        }
                    }
                    .padding()
                }
            }
        }
        .navigationTitle(shoe.shoeNickname)
        .toolbar {
            ToolbarItem {
                Button {
                    viewModel.showingDeleteShoeAlert = true
                } label: {
                    Image(systemName: "trash")
                }
            }
            ToolbarItem {
                Button {
                    viewModel.showingEditShoeView = true
                } label: {
                    Image(systemName: "pencil")
                }
            }
        }
        .sheet(isPresented: $viewModel.showingEditShoeView) {
            EditShoeSheet(shoe: shoe)
        }
        .alert("Permanently delete shoe?", isPresented: $viewModel.showingDeleteShoeAlert) {
            Button("Delete shoe", role: .destructive) {
                context.delete(shoe)
                do {
                    try context.save()
                } catch {
                    viewModel.errorMessage = "An error occured when trying to delete shoe"
                    viewModel.showingError = true
                }
            }
            if !shoe.retired {
                Button("Retire shoe") {
                    shoe.retired = true
                }
            }
            Button("Cancel", role: .cancel) {}
        }
        .alert("Unlink workout from \(shoe.shoeNickname)?", isPresented: $showingDeleteWorkoutAlert) {
            Button("Unlink workout", role: .destructive) {
                if let shoe = workoutToDelete?.shoe,
                   let index = shoe.workouts?.firstIndex(where: { $0.id == workoutToDelete?.id }) {
                    shoe.workouts?.remove(at: index)
                    shoe.currentMileage -= workoutToDelete?.distance ?? 0
                }
                workoutToDelete?.shoe = nil
                workoutToDelete = nil
            }
            Button("Cancel", role: .cancel) {
                workoutToDelete = nil
            }
        }
        .alert("An error occurred", isPresented: $viewModel.showingError) {
            Button("Ok", role: .cancel) { }
        } message: {
            Text(viewModel.errorMessage)
        }
    }
}

//#Preview {
//    ShoeDetailView(shoe: Shoe(shoeNickname: "Peggies", shoeModel: "Nike Pegasus 39", colour: "White", currentMileage: 450, mileageLimit: 700, retired: false, workouts: []))
//}
