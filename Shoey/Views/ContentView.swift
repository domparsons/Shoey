//
//  ContentView.swift
//  Shoey
//
//  Created by Dom Parsons on 12/11/2023.
//

import SwiftUI
import SwiftData
import HealthKit

struct ContentView: View {
    
    @StateObject var healthKitManager: HealthKitManager
    @StateObject var viewModel: ViewModel
    
    @Environment(\.modelContext) private var context
    @Environment(\.colorScheme) var colorScheme
    
    @Query(sort: \Shoe.currentMileage, order: .reverse) private var shoes: [Shoe]
    @Query(sort: \Workout.dateAndTime, order: .reverse) var savedWorkouts: [Workout]
    
    @State private var tabSelection = 1
    // some new features
    var body: some View {
        ZStack {
            if UserDefaults.standard.bool(forKey: "onboardingComplete") {
                TabView(selection: $tabSelection) {
                    ShoeView()
                        .environmentObject(viewModel)
                        .tabItem {
                            Label("Shoes", systemImage: "shoe.2")
                        }
                        .tag(1)
                    
                    RetiredShoesView()
                        .environmentObject(viewModel)
                        .tabItem {
                            Label("Retired", systemImage: "shippingbox.fill")
                        }
                        .tag(2)
                    
                    WorkoutView(healthKitManager: HealthKitManager(context: context))
                        .environmentObject(viewModel)
                        .tabItem {
                            Label("Workouts", systemImage: "figure.run")
                        }
                        .tag(3)
                }
            } else {
                if viewModel.onboardingPhase == "onboardingScreen" {
                    OnboardingView()
                        .environmentObject(viewModel)
                } else if viewModel.onboardingPhase == "AuthoriseHKView" && !healthKitManager.HKAuthorised {
                    AuthoriseHKView()
                        .environmentObject(healthKitManager)
                        .environmentObject(viewModel)
                } else if UserDefaults.standard.bool(forKey: "HKAuthorised") && healthKitManager.HKAuthorised {
                    LoadWorkoutsView()
                        .environmentObject(healthKitManager)
                        .environmentObject(viewModel)
                }
            }
        }
        .onAppear {
            let currentCount = UserDefaults.standard.integer(forKey: "launchCount")
            UserDefaults.standard.set(currentCount+1, forKey:"launchCount")
            
            if UserDefaults.standard.integer(forKey: "launchCount") == 1 {
                UserDefaults.standard.set(false, forKey: "HKAuthorised")
            }
             
            if UserDefaults.standard.bool(forKey: "HKAuthorised") && UserDefaults.standard.bool(forKey: "InitialWorkoutsFetched"){
                getNewRunningActivities()
            }
        }
        .alert(viewModel.errorMessage, isPresented: $viewModel.showingError) {
            Button("Ok", role: .cancel) { }
        } message: {
            Text("Please try again later")
        }
    }
    
    func getNewRunningActivities() {
        let runningPredicate = HKQuery.predicateForWorkouts(with: .running)
        let walkingPredicate = HKQuery.predicateForWorkouts(with: .walking)
        let hikingPredicate = HKQuery.predicateForWorkouts(with: .hiking)
        let compoundPredicate = NSCompoundPredicate(orPredicateWithSubpredicates: [runningPredicate, walkingPredicate, hikingPredicate])
        let sortDescriptors = [NSSortDescriptor(key: HKSampleSortIdentifierStartDate, ascending: false)]
        let existingUUIDs = savedWorkouts.compactMap { $0.id }
        let query = HKSampleQuery(sampleType: HKObjectType.workoutType(), predicate: compoundPredicate, limit: 0, sortDescriptors: sortDescriptors) { (query, samples, error) in
            if let workouts = (samples as? [HKWorkout])?.sorted(by: { $0.startDate > $1.startDate }) {
                for workout in workouts {
                    let distanceInKilometers = (workout.totalDistance?.doubleValue(for: HKUnit.meter()) ?? 0) / 1000
                    let activityType: String
                    if workout.workoutActivityType == .running {
                        activityType = "run"
                    } else if workout.workoutActivityType == .walking {
                        activityType = "walk"
                    } else if workout.workoutActivityType == .hiking {
                        activityType = "hike"
                    } else {
                        activityType = "Unknown"
                    }
                    
                    if !(existingUUIDs.contains(workout.uuid)) {
                        DispatchQueue.main.async {
                            let newWorkout = Workout(
                                id: workout.uuid,
                                activityType: activityType,
                                distance: distanceInKilometers,
                                dateAndTime: workout.startDate,
                                shoe: nil
                            )
                            self.context.insert(newWorkout)
                        }
                    }
                    if self.context.hasChanges {
                        do {
                            try self.context.save()
                        } catch {
                            viewModel.errorMessage = "An error occured when trying to save workouts."
                            viewModel.showingError = true
                        }
                    }
                }
            } else {
                viewModel.errorMessage = "Error fetching activities from Health"
                viewModel.showingError = true
            }
        }
        healthKitManager.healthStore.execute(query)
    }
}

//#Preview {
//    ContentView(healthKitManager: HealthKitManager(context: context), viewModel: ViewModel(context: context))
//        .modelContainer(for: [Shoe.self, Workout.self], inMemory: true)
//}
