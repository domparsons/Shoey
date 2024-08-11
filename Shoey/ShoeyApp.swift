//
//  ShoeyApp.swift
//  Shoey
//
//  Created by Dom Parsons on 12/11/2023.
//

import SwiftUI
import SwiftData

@main
struct ShoeyApp: App {
    
//    @Environment(\.modelContext) private var context
    
    let shoeModelContainer: ModelContainer
    let workoutModelContainer: ModelContainer
    
    init() {
        do {
            shoeModelContainer = try ModelContainer(for: Shoe.self)
            workoutModelContainer = try ModelContainer(for: Workout.self)
        } catch let error {
            fatalError("Could not initialise ModelContainer: \(error)")
        }
    }

    
    var body: some Scene {
        WindowGroup {
            ContentView(healthKitManager: HealthKitManager(context: context), viewModel: ViewModel(context: context))
                .modelContainer(for: [Shoe.self, Workout.self])
        }
    }
}
