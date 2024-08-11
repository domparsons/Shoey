//
//  Workout.swift
//  Shoey
//
//  Created by Dom Parsons on 15/11/2023.
//

import Foundation
import SwiftData

@Model
class Workout {
    var id: UUID?
    var activityType: String = "Run"
    var distance: Double = 0.0
    var dateAndTime: Date?
    var shoe: Shoe?
    
    init(id: UUID, activityType: String, distance: Double, dateAndTime: Date? = nil, shoe: Shoe? = nil) {
        self.id = id
        self.activityType = activityType
        self.distance = distance
        self.dateAndTime = dateAndTime
        self.shoe = shoe
    }
}
