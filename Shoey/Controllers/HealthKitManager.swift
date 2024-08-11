//
//  HealthKitManager.swift
//  Shoey
//
//  Created by Dom Parsons on 12/11/2023.
//

import Foundation
import HealthKit
import SwiftData

class HealthKitManager: ObservableObject {

    let healthStore = HKHealthStore()
    
    let context: ModelContext

    init(context: ModelContext) {
        self.context = context
    }
    
    @Published var HKAuthorised = false
    
    
    func requestAuthorization() {
        // Check if HealthKit is available on the device
        if HKHealthStore.isHealthDataAvailable() {
            // Request authorization to read running data
            let typesToRead: Set<HKObjectType> = [
                HKObjectType.workoutType(),
                HKObjectType.quantityType(forIdentifier: .distanceWalkingRunning)!
            ]

            healthStore.requestAuthorization(toShare: nil, read: typesToRead) { (success, error) in
                DispatchQueue.main.async {
                    if success {
                        UserDefaults.standard.set(true, forKey: "HKAuthorised")
                        self.HKAuthorised = true
                    } else {
                        print("Authorization failed: \(error?.localizedDescription ?? "")")
                    }
                }
            }
        }
    }
}
