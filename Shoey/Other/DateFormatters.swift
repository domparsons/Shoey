//
//  DateFormatters.swift
//  Shoey
//
//  Created by Dom Parsons on 26/11/2023.
//

import Foundation

struct AppDateFormatter {
    static let workoutFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .short
        return formatter
    }()
}

