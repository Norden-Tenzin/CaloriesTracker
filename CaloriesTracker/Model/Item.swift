//
//  Item.swift
//  CaloriesTracker
//
//  Created by Tenzin Norden on 11/25/23.
//

import Foundation
import SwiftData

@Model
final class Item {
    @Attribute(.unique)
    let id: UUID = UUID()
    var name: String
    var desc: String
    var calories: Double
    var protien: Double
    var carbs: Double
    var fat: Double
    var timestamp: Date

    init(name: String, desc: String, calories: Double, protien: Double, carbs: Double, fat: Double, timestamp: Date) {
        self.name = name
        self.desc = desc
        self.calories = calories
        self.protien = protien
        self.carbs = carbs
        self.fat = fat
        self.timestamp = timestamp
    }
}

