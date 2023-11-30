//
//  Card.swift
//  CaloriesTracker
//
//  Created by Tenzin Norden on 11/25/23.
//

import SwiftUI
import SwiftData

struct Card: View {
    @Binding var selectedDay: Day
    @Binding var presentSheet: Bool
    @Binding var presentCardSheet: Bool
    @Binding var sheetSelection: Meals
    @State var items: [Item]?
    var meal: Meals

    var body: some View {
        VStack {
            HStack {
                Group {
                    switch (meal) {
                    case .breakfast:
                        Image(systemName: "sun.horizon")
                            .font(.system(size: 30))
                            .foregroundStyle(Color.orange)
                    case .lunch:
                        Image(systemName: "sun.max")
                            .font(.system(size: 30))
                            .foregroundStyle(Color.orange)
                    case .dinner:
                        Image(systemName: "moon.haze")
                            .font(.system(size: 30))
                            .foregroundStyle(Color.orange)
                    case .snack:
                        Image(systemName: "carrot")
                            .font(.system(size: 30))
                            .foregroundStyle(Color.orange)
                    }
                }
                .frame(width: 50)
                Text(meal.rawValue)
                    .fontWeight(.bold)
                Spacer()
                Image(systemName: "plus.circle")
                    .font(.system(size: 30))
                    .onTapGesture {
                    presentSheet = true
                    sheetSelection = meal
                }
            }
                .padding(.horizontal, 10)
            switch(meal) {
            case .breakfast:
                CardDescription(meal: meal, data: $selectedDay.breakfast, presentSheet: $presentSheet, presentCardSheet: $presentCardSheet, selectedDay: $selectedDay, sheetSelection: sheetSelection)
            case .lunch:
                CardDescription(meal: meal, data: $selectedDay.lunch, presentSheet: $presentSheet, presentCardSheet: $presentCardSheet, selectedDay: $selectedDay, sheetSelection: sheetSelection)
            case .dinner:
                CardDescription(meal: meal, data: $selectedDay.dinner, presentSheet: $presentSheet, presentCardSheet: $presentCardSheet, selectedDay: $selectedDay, sheetSelection: sheetSelection)
            case .snack:
                CardDescription(meal: meal, data: $selectedDay.snack, presentSheet: $presentSheet, presentCardSheet: $presentCardSheet, selectedDay: $selectedDay, sheetSelection: sheetSelection)
            }
        }
            .padding()
            .background() {
            Color.white
                .clipShape(.rect(cornerRadius: 20))
                .padding(.horizontal, 15)
        }
    }
}

struct CardDescription: View {
    var meal: Meals
    @Binding var data: [Item]
    @Binding var presentSheet: Bool
    @Binding var presentCardSheet: Bool
    @Binding var selectedDay: Day
    var sheetSelection: Meals

    @State var calories: Double = 0
    @State var protien: Double = 0
    @State var carbs: Double = 0
    @State var fat: Double = 0

    var body: some View {
        if !data.isEmpty {
            VStack {
                Divider()
                HStack {
                    VStack {
                        Text("Calories")
                            .font(.system(size: 14))
                            .foregroundStyle(Color.secondary)
                        Text(data.reduce(0, { partialResult, item in
                            partialResult + item.calories
                        }).string())
                    }
                    Spacer()
                    VStack {
                        Text("Protien")
                            .font(.system(size: 14))
                            .foregroundStyle(Color.secondary)
                        Text(data.reduce(0, { partialResult, item in
                            partialResult + item.protien
                        }).string())
                    }
                    Spacer()
                    VStack {
                        Text("Carbs")
                            .font(.system(size: 14))
                            .foregroundStyle(Color.secondary)
                        Text(data.reduce(0, { partialResult, item in
                            partialResult + item.carbs
                        }).string())
                    }
                    Spacer()
                    VStack {
                        Text("Fat")
                            .font(.system(size: 14))
                            .foregroundStyle(Color.secondary)
                        Text(data.reduce(0, { partialResult, item in
                            partialResult + item.fat
                        }).string())
                    }
                }
                    .padding(.horizontal, 20)
                    .padding(.vertical, 10)
                Divider()
                VStack (spacing: 10) {
                    ForEach(data) { item in
                        CardDescriptionItem(item: item, removeItemFromCard: removeItemFromCard)
                            .onTapGesture {
                            presentCardSheet = true
                        }
                            .sheet(isPresented: $presentCardSheet, content: {
                            SheetForm(presentSheet: $presentSheet, presentCardSheet: $presentCardSheet, selectedDay: $selectedDay, sheetSelection: sheetSelection, itemName: item.name, calories: Int(item.calories).description, protien: Int(item.protien).description, carbs: Int(item.carbs).description, fat: Int(item.fat).description, date: item.timestamp, isEditing: true, item: item)
                                .presentationDetents([.fraction(0.55)])
                        })
                    }
                        .scrollDisabled(true)
                        .padding(.horizontal, 15)
                        .padding(.top, 10)
                }
            }
                .onAppear() {
                for item in data {
                    calories = calories + item.calories
                    protien = protien + item.protien
                    carbs = carbs + item.carbs
                    fat = fat + item.fat
                }
            }
        }
    }
    func removeItemFromCard(item: Item) {
        withAnimation {
            if let itemIndex = data.firstIndex(of: item) {
                data.remove(at: itemIndex)
            }
        }
    }
}

struct CardDescriptionItem: View {
    var item: Item
    var showCross: Bool = true
    var removeItemFromCard: (Item) -> Void
    var body: some View {
        HStack {
//            TODO: Image
//            Circle()
//                .fill(Color.gray)
//                .frame(width: 35)
            VStack (alignment: .leading, spacing: 5) {
                Text(item.name)
                    .fontWeight(.bold)
                Text(get24Time(date: item.timestamp))
                    .font(.system(size: 12))
                    .foregroundStyle(Color.secondary)
                    .padding(.leading, 5)
            }
            Spacer()
            Image(systemName: "x.circle")
                .foregroundStyle(Color.red)
                .onTapGesture {
                removeItemFromCard(item)
            }
        }
            .contentShape(Rectangle())
    }
}
