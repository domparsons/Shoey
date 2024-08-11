//
//  LoadWorkoutsView.swift
//  Shoey
//
//  Created by Dom Parsons on 11/12/2023.
//

import SwiftUI
import HealthKit
import SwiftData

struct LoadWorkoutsView: View {
    
    @EnvironmentObject var healthKitManager: HealthKitManager
    @EnvironmentObject var viewModel: ViewModel
    
    @Query(sort: \Workout.dateAndTime, order: .reverse) var savedWorkouts: [Workout]
    
    @Environment(\.modelContext) var context
    
    var body: some View {
        ZStack {
            LinearGradient(colors: [.blue.opacity(0.8), .blue.opacity(0.5)], startPoint: .topLeading, endPoint: .bottomTrailing)
                .ignoresSafeArea()
            VStack {
                Spacer()
                HStack {
                    VStack(alignment: .leading) {
                        Image(systemName: "figure.run")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 100)
                            .padding(.bottom, 20)
                            .foregroundStyle(.white)
                        
                        Text("Apple Health Authorised")
                            .font(.title.bold())
                            .foregroundStyle(.white)
                    }
                    .padding(.horizontal, 20)
                    
                    Spacer()
                }
                Button("Load Workouts") {
                    getRunningActivities()
                    UserDefaults.standard.set(true, forKey: "onboardingComplete")
                    viewModel.updatingUI.toggle()
                }
                .font(.title3.bold())
                .padding(.horizontal, 80)
                .padding(.vertical, 25)
                .background(.blue)
                .foregroundStyle(.white)
                .clipShape(RoundedRectangle(cornerRadius: 25))
                .padding(.top, 40)

                Spacer()
            }
        }
        .tint(.white)
        .alert("An error occurred", isPresented: $viewModel.showingError) {
            Button("Ok", role: .cancel) { }
        } message: {
            Text(viewModel.errorMessage)
        }
    }
    
    func getRunningActivities() {
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
                            viewModel.errorMessage = "Could not save new workouts"
                            viewModel.showingError = true
                        }
                    }
                }
            } else {
                viewModel.errorMessage = "Could not find new workouts"
                viewModel.showingError = true
            }
        }
        UserDefaults.standard.set(true, forKey: "InitialWorkoutsFetched")
        healthKitManager.healthStore.execute(query)
    }
}

#Preview {
    LoadWorkoutsView()
}
