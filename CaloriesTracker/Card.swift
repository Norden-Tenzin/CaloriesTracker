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
    @Binding var sheetSelection: Meals
    @State var items: [Item]?
    var meal: Meals

    var body: some View {
        VStack {
            HStack {
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
                VStack(alignment: .leading) {
                    Text(meal.rawValue)
                        .fontWeight(.bold)
                    Text("Goal: 440 calories")
                        .font(.system(size: 14))
                }
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
                CardDescription(meal: meal, data: $selectedDay.breakfast)
            case .lunch:
                CardDescription(meal: meal, data: $selectedDay.lunch)
            case .dinner:
                CardDescription(meal: meal, data: $selectedDay.dinner)
            case .snack:
                CardDescription(meal: meal, data: $selectedDay.snack)
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
                VStack {
                    ForEach(data) { item in
                        if data.last == item {
                            CardDescriptionItem(item: item, removeItemFromCard: removeItemFromCard)
                        } else {
                            CardDescriptionItem(item: item, removeItemFromCard: removeItemFromCard)
                                .padding(.bottom, 15)
                        }
                    }
                }
                    .scrollDisabled(true)
                    .padding(.horizontal, 15)
                    .padding(.top, 10)
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
//            Circle()
//                .fill(Color.gray)
//                .frame(width: 35)
            VStack (alignment: .leading) {
                Text(item.name)
                    .fontWeight(.bold)
                if item.desc != "" {
                    Text(item.desc)
                        .font(.system(size: 12))
                        .foregroundStyle(Color.secondary)
                } else {
                    Text("")
                        .font(.system(size: 12))
                        .foregroundStyle(Color.clear)
                }
            }
            Spacer()
            Image(systemName: "x.circle")
                .foregroundStyle(Color.red)
                .onTapGesture {
                removeItemFromCard(item)
            }
        }
    }
}

struct CardDescriptionAddButton: View {
    var body: some View {
        HStack {
//            Circle()
//                .fill(Color.gray)
//                .frame(width: 35)
            VStack (alignment: .leading) {
                Text("add +")
                    .fontWeight(.bold)
                Text("Item Desc")
                    .font(.system(size: 12))
                    .foregroundStyle(Color.clear)
            }
            Spacer()
        }
    }
}
