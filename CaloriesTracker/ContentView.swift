//
//  ContentView.swift
//  CaloriesTracker
//
//  Created by Tenzin Norden on 11/25/23.
//

import SwiftUI
import SwiftData

struct ContentView: View {
    var body: some View {
        NavigationStack {
            Main()
        }
    }
}

#Preview {
    let config = ModelConfiguration(isStoredInMemoryOnly: true)
    let container = try! ModelContainer(for: Day.self, Item.self, configurations: config)

    let egg = Item(name: "Egg", desc: "boiled egg", calories: 10, protien: 10, carbs: 10, fat: 10, timestamp: Date())
    let rice = Item(name: "rice", desc: "boiled egg", calories: 10, protien: 10, carbs: 10, fat: 10, timestamp: Date())
    let chicken = Item(name: "chicken", desc: "boiled egg", calories: 10, protien: 10, carbs: 10, fat: 10, timestamp: Date())
    let day = Day(date: getDate(date: Date.now), timestamp: Date.now)
    container.mainContext.insert(egg)
    container.mainContext.insert(rice)
    container.mainContext.insert(chicken)
    
    day.breakfast = [egg, rice, chicken]
    day.lunch = [egg, rice, chicken]
    day.dinner = [egg, rice, chicken]
    day.snack = [egg, rice, chicken]
    container.mainContext.insert(day)

    return ContentView()
        .modelContainer(container)
}
