//
//  Main.swift
//  CaloriesTracker
//
//  Created by Tenzin Norden on 11/25/23.
//

import SwiftUI
import SwiftData
import Combine

enum Meals: String {
    case breakfast = "Breakfast"
    case lunch = "Lunch"
    case dinner = "Dinner"
    case snack = "Snack"
}

let caloriesMax: Double = 2200
let protienMax: Double = 65
let carbsMax: Double = 325
let fatMax: Double = 90

struct Main: View {
    @Environment(\.modelContext) private var modelContext
    @Query private var days: [Day]

    @State var selection: Date = Date()
    @State var selectedDay: Day = Day(date: getDate(date: Date.now), timestamp: Date.now)
    @State var progress: CGFloat = 0.3

    @State var calories: Double = 0
    @State var protien: Double = 0
    @State var carbs: Double = 0
    @State var fat: Double = 0

    @State var presentSheet: Bool = false
    @State var presentPopover: Bool = false
    @State var sheetSelection: Meals = .breakfast

    var body: some View {
        GeometryReader { geo in
            VStack {
//                MARK: - TOP NAV BAR
                HStack(spacing: 15) {
                    Text(getTitle(selection: selection))
                        .font(.system(size: 34, weight: .bold))
                    Spacer()
                    Button(action: {
                        self.presentPopover = true
                    }) {
                        Image(systemName: "calendar")
                    }
                        .buttonStyle(.plain)
                        .popover(isPresented: $presentPopover) {
                        DatePicker(
                            "Start Date",
                            selection: $selection,
                            displayedComponents: [.date]
                        )
                            .datePickerStyle(.graphical)
                            .frame(width: 350)
                            .presentationCompactAdaptation(.popover)
                    }
                    Image(systemName: "gearshape")
                }
                    .font(.system(size: 24))
                    .padding()

//                MARK: - WEEK NAV BAR
                WeekBarView(selection: $selection)
                    .onChange(of: selection, { oldValue, newValue in
                    withAnimation {
                        if let selectedDate = days.first(where: { day in
                            return day.date == getDate(date: selection)
                        }) {
                            selectedDay = selectedDate
                        } else {
                            selectedDay = addDay()
                        }
                        calculateStats(selectedDay: selectedDay)
                    }
                })
                    .padding(.horizontal, 10)

//                MARK: - GRAPHS
                HStack(spacing: 0) {
                    let stats = calculateStatsProgress(selectedDay: selectedDay)
                    ZStack {
                        ActivityRingView(progress: stats.0 / caloriesMax, color: Color.calories, width: Double(160 - (0 * 36)))
                        ActivityRingView(progress: stats.1 / protienMax, color: Color.protien, width: Double(160 - (1 * 36)))
                        ActivityRingView(progress: stats.2 / carbsMax, color: Color.carbs, width: Double(160 - (2 * 36)))
                        ActivityRingView(progress: stats.3 / fatMax, color: Color.fat, width: Double(160 - (3 * 36)))
                    }
                        .frame(width: geo.size.width / 2)
                    VStack(spacing: 0) {
                        GraphDetails(title: "Calories", data: stats.0, dataMax: caloriesMax, color: Color.calories)
                        GraphDetails(title: "Protien", data: stats.1, dataMax: protienMax, color: Color.protien)
                        GraphDetails(title: "Carbs", data: stats.2, dataMax: carbsMax, color: Color.carbs)
                        GraphDetails(title: "Fat", data: stats.3, dataMax: fatMax, color: Color.fat)
                    }
                        .frame(width: geo.size.width / 2)
                        .padding(.vertical, 100)
                }
                    .frame(height: (geo.size.width / 2))
                    .padding(.top, 10)
                    .padding(.bottom, 20)

//                MARK: - CARDS
                ScrollView {
                    Card(selectedDay: $selectedDay, presentSheet: $presentSheet, sheetSelection: $sheetSelection, items: selectedDay.breakfast, meal: .breakfast)
                    Card(selectedDay: $selectedDay, presentSheet: $presentSheet, sheetSelection: $sheetSelection, items: selectedDay.lunch, meal: .lunch)
                    Card(selectedDay: $selectedDay, presentSheet: $presentSheet, sheetSelection: $sheetSelection, items: selectedDay.dinner, meal: .dinner)
                    Card(selectedDay: $selectedDay, presentSheet: $presentSheet, sheetSelection: $sheetSelection, items: selectedDay.snack, meal: .snack)
                        .padding(.bottom, 10)
                }
                    .scrollIndicators(.hidden)
                Spacer()
            }
                .padding(.top, 40)
                .background() {
                Color.bg
            }
        }
            .ignoresSafeArea()
            .onAppear() {
            do {
                try modelContext.delete(model: Item.self)
            } catch {
                print("Failed to delete students.")
            }
            do {
                try modelContext.delete(model: Day.self)
            } catch {
                print("Failed to delete students.")
            }

//                if date exists query and get
//                else create and add
            if let selectedDate = days.first(where: { day in
                return day.date == getDate(date: selection)
            }) {
                selectedDay = selectedDate
            } else {
                selectedDay = addDay()
            }
            calculateStats(selectedDay: selectedDay)
        }
            .sheet(isPresented: $presentSheet, content: {
            Sheet(presentSheet: $presentSheet, selectedDay: $selectedDay, sheetSelection: sheetSelection)
                .presentationDetents([.fraction(0.55)])
        })
    }

    func getTitle(selection: Date) -> String {
        if getDate(date: selection) == getDate(date: Date.now) {
            return "Today"
        } else {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "MM/dd"
            return dateFormatter.string(from: selection)
        }
    }

    func addDay() -> Day {
        let day = Day(date: getDate(date: selection), timestamp: selection)
        modelContext.insert(day)
        return day
    }

    func calculateStats(selectedDay: Day) {
        calories = 0
        protien = 0
        carbs = 0
        fat = 0
        for item in selectedDay.breakfast {
            calories = calories + item.calories
            protien = protien + item.protien
            carbs = carbs + item.carbs
            fat = fat + item.fat
        }
        for item in selectedDay.lunch {
            calories = calories + item.calories
            protien = protien + item.protien
            carbs = carbs + item.carbs
            fat = fat + item.fat
        }
        for item in selectedDay.dinner {
            calories = calories + item.calories
            protien = protien + item.protien
            carbs = carbs + item.carbs
            fat = fat + item.fat
        }
        for item in selectedDay.snack {
            calories = calories + item.calories
            protien = protien + item.protien
            carbs = carbs + item.carbs
            fat = fat + item.fat
        }
    }

    func calculateStatsProgress(selectedDay: Day) -> (Double, Double, Double, Double) {
        var calories: Double = 0
        var protien: Double = 0
        var carbs: Double = 0
        var fat: Double = 0

        for item in selectedDay.breakfast {
            calories = calories + item.calories
            protien = protien + item.protien
            carbs = carbs + item.carbs
            fat = fat + item.fat
        }
        for item in selectedDay.lunch {
            calories = calories + item.calories
            protien = protien + item.protien
            carbs = carbs + item.carbs
            fat = fat + item.fat
        }
        for item in selectedDay.dinner {
            calories = calories + item.calories
            protien = protien + item.protien
            carbs = carbs + item.carbs
            fat = fat + item.fat
        }
        for item in selectedDay.snack {
            calories = calories + item.calories
            protien = protien + item.protien
            carbs = carbs + item.carbs
            fat = fat + item.fat
        }
        return (calories, protien, carbs, fat)
    }
}

struct GraphDetails: View {
    var title: String
    var data: Double
    var dataMax: Double
    var color: Color

    var body: some View {
        Group {
            HStack(spacing: 5) {
                Image(systemName: "circle.fill")
                    .font(.system(size: 10))
                    .foregroundStyle(color)
                Text(title)
                    .font(.system(size: 16))
                Spacer()
                Text(data.string())
                    .fontWeight(.bold)
                Text("/")
                Text(dataMax.string())
            }
                .font(.system(size: 12))
            SimpleBarProgressView(progress: (data / dataMax), color: color)
                .padding(.bottom, 10)
        }
            .padding(.trailing, 10)
    }
}
