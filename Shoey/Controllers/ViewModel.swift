//
//  ViewModel.swift
//  Shoey
//
//  Created by Dom Parsons on 12/11/2023.
//

import Foundation
import SwiftData
import HealthKit

class ViewModel: ObservableObject {
    
    let context: ModelContext
    
    init(context: ModelContext) {
        self.context = context
    }
    
    @Published var showingAddNewShoeView = false
    @Published var showingDeleteShoeAlert = false
    @Published var showingNoShoesAlert = false
    @Published var newWorkouts: [Workout] = []
    @Published var newWorkoutsOnLoad: Bool = false
    
    @Published var demoComplete = false
    
    @Published var updatingUI = false
    
    @Published var showingEditShoeView = false
    
    @Published var onboardingPhase = "onboardingScreen"
    
    @Published var showingError = false
    @Published var errorMessage = ""
    
    func assignNewShoe(shoe: Shoe, workout: Workout) {
        DispatchQueue.main.async {
            if let currentShoe = workout.shoe {
                if let index = currentShoe.workouts?.firstIndex(where: { $0.id == workout.id }) {
                    currentShoe.workouts?.remove(at: index)
                    currentShoe.currentMileage -= workout.distance
                }
            }
        
            workout.shoe = shoe
            shoe.workouts?.append(workout)
            shoe.currentMileage += workout.distance
        }
    }
    
    func assignNoShoe(workout: Workout) {
        DispatchQueue.main.async {
            if let currentShoe = workout.shoe {
                if let index = currentShoe.workouts?.firstIndex(where: { $0.id == workout.id }) {
                    currentShoe.workouts?.remove(at: index)
                    currentShoe.currentMileage -= workout.distance
                }
            }
            workout.shoe = nil
        }
    }
}
