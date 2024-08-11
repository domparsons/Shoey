//
//  WorkoutView.swift
//  Shoey
//
//  Created by Dom Parsons on 12/11/2023.
//

import SwiftUI
import HealthKit
import SwiftData

struct WorkoutView: View {
    
    @EnvironmentObject var viewModel: ViewModel
    @StateObject var healthKitManager: HealthKitManager
    
    @Environment(\.modelContext) var context
    @Environment(\.presentationMode) var presentationMode
    
    @Query(sort: \Workout.dateAndTime, order: .reverse) var savedWorkouts: [Workout]
    @Query(sort: \Shoe.shoeNickname, order: .forward) var shoes: [Shoe]
    
    var filteredWorkouts: [Workout] {
        switch selectedFilter {
        case .all:
            return savedWorkouts
        case .run:
            return savedWorkouts.filter { $0.activityType.lowercased() == "run" }
        case .walk:
            return savedWorkouts.filter { $0.activityType.lowercased() == "walk" }
        case .hike:
            return savedWorkouts.filter { $0.activityType.lowercased() == "hike" }
        }
    }
    
    enum WorkoutFilter: String, CaseIterable {
        case all = "All"
        case run = "Run"
        case walk = "Walk"
        case hike = "Hike"
    }
    
    @State private var selectedFilter: WorkoutFilter = .all
    
    enum WorkoutSort: String, CaseIterable {
        case date = "Date"
        case distance = "Distance"
    }
    
    @State private var selectedSort: WorkoutSort = .date
    
    var sortedWorkouts: [Workout] {
        switch selectedSort {
        case .date:
            return filteredWorkouts.sorted(by: { $0.dateAndTime ?? Date.now > $1.dateAndTime ?? Date.now })
        case .distance:
            return filteredWorkouts.sorted(by: { $0.distance > $1.distance })
        }
    }
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack {
                    if !savedWorkouts.isEmpty && Set(savedWorkouts.map { $0.activityType.lowercased() }).count >= 2 {
                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack(spacing: 10) {
                                ForEach(WorkoutFilter.allCases, id: \.self) { filter in
                                    let filteredWorkoutsForType = savedWorkouts.filter { $0.activityType.lowercased() == filter.rawValue.lowercased() }

                                    if !filteredWorkoutsForType.isEmpty || (filter == .all) {

                                        Button(action: {
                                            selectedFilter = filter
                                        }) {
                                            HStack {
                                                if filter.rawValue != "All" {
                                                    if filter.rawValue.lowercased() == "run" {
                                                        Text("Runs")
                                                        Image(systemName: "figure.run")
                                                    } else if filter.rawValue.lowercased() == "walk" {
                                                        Text("Walks")
                                                        Image(systemName: "figure.walk")
                                                    } else if filter.rawValue.lowercased() == "hike" {
                                                        Text("Hikes")
                                                        Image(systemName: "figure.hiking")
                                                    }
                                                } else {
                                                    Text("All")
                                                }
                                            }
                                            .padding(.horizontal, 20)
                                            .padding(.vertical, 10)
                                            .background(selectedFilter == filter ? Color.blue : Color.gray.opacity(0.8))
                                            .foregroundColor(.white)
                                            .cornerRadius(100)
                                        }
                                    }
                                }
                            }
                            .padding()
                        }
                    }
                    
                    ForEach(sortedWorkouts) { workout in
                        HStack {
                            if workout.activityType == "run" {
                                Image(systemName: "figure.run")
                            } else if workout.activityType == "walk" {
                                Image(systemName: "figure.walk")
                            } else if workout.activityType == "hike" {
                                Image(systemName: "figure.hiking")
                            }
                            
                            VStack(alignment: .leading) {
                                Text("\(String(format: "%.2f", workout.distance)) km \(workout.activityType)")
                                Text("\(workout.dateAndTime ?? Date(), formatter: AppDateFormatter.workoutFormatter)")
                                    .font(.caption)
                                    .foregroundStyle(.secondary)
                            }
                            .padding(.leading, 10)
                            Spacer()
                            
                            Menu {
                                ForEach(shoes) { shoe in
                                    if shoe != workout.shoe && !shoe.retired {
                                        Button(shoe.shoeNickname) {
                                            viewModel.assignNewShoe(shoe: shoe, workout: workout)
                                        }
                                    }
                                }
                                if workout.shoe != nil {
                                    Button("No shoe") {
                                        viewModel.assignNoShoe(workout: workout)
                                    }
                                }
                            } label: {
                                HStack {
                                    Text(String(workout.shoe?.shoeNickname ?? ""))
                                    workout.shoe != nil ? Image(systemName: "chevron.down") : Image(systemName: "link")
                                }
                            }
                            .onTapGesture {
                                if shoes == [] {
                                    viewModel.showingNoShoesAlert = true
                                }
                            }
                        }
                    }
                    .padding(.horizontal)
                }
                if savedWorkouts == [] {

                    Text("It looks like you might not have Apple Health access enabled")
                        .multilineTextAlignment(.center)
                        .font(.title2)
                        .foregroundStyle(.secondary)
                        .padding(.bottom, 10)
                        .padding(.top, 50)
                    NavigationLink {
                        HealthKitConnectView()
                    } label: {
                        Text("How to enable Apple Health access")
                    }
                }
            }
            .navigationTitle("Workouts")
            .alert("You have no shoes to add!", isPresented: $viewModel.showingNoShoesAlert) {
                Button("Add a new shoe") {
                    self.presentationMode.wrappedValue.dismiss()
                    viewModel.showingAddNewShoeView = true
                }
                Button("Cancel", role: .cancel) {}
            }
            .toolbar {
                if savedWorkouts != [] {
                    ToolbarItem {
                        Menu {
                            Button(action: {
                                selectedSort = .date
                            }) {
                                HStack {
                                    Text("Sort by Date")
                                    Spacer()
                                    if selectedSort == .date {
                                        Image(systemName: "checkmark")
                                    }
                                }
                            }
                            
                            Button(action: {
                                selectedSort = .distance
                            }) {
                                HStack {
                                    Text("Sort by Distance")
                                    Spacer()
                                    if selectedSort == .distance {
                                        Image(systemName: "checkmark")
                                    }
                                }
                            }
                        } label: {
                            Image(systemName: "arrow.up.arrow.down")
                        }
                    }
                }
            }
        }
    }
}
