//
//  Shoe.swift
//  Shoey
//
//  Created by Dom Parsons on 12/11/2023.
//

import Foundation
import SwiftData

@Model
class Shoe {
    var shoeNickname: String = "Unknown nickname"
    var shoeModel: String = "Unknown model"
    var colour: String = "Unknown colour"
    var currentMileage: Double = 0.0
    var mileageLimit: Double = 600.0
    var retired: Bool = false
    var workouts: [Workout]?
    
    init(shoeNickname: String, shoeModel: String, colour: String, currentMileage: Double, mileageLimit: Double, retired: Bool, workouts: [Workout]) {
        self.shoeNickname = shoeNickname
        self.shoeModel = shoeModel
        self.colour = colour
        self.currentMileage = currentMileage
        self.mileageLimit = mileageLimit
        self.retired = retired
        self.workouts = workouts
    }
}
