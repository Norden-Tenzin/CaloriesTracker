//
//  PopupSheetView.swift
//  CaloriesTracker
//
//  Created by Tenzin Norden on 11/27/23.
//

import SwiftUI
import SwiftData
import Combine

struct Sheet: View {
    @Environment(\.modelContext) private var modelContext
    @Query var items: [Item]
    @Query var days: [Day]
    @Binding var presentSheet: Bool
    @Binding var selectedDay: Day
    var sheetSelection: Meals

    var body: some View {
        NavigationStack {
            VStack(alignment: .leading) {
                Button(action: {
                    presentSheet = false
                }, label: {
                        HStack(spacing: 5) {
                            Image(systemName: "chevron.left")
                            Text("back")
                        }
                            .font(.system(size: 12))
                    })
                    .buttonStyle(.plain)
                    .padding(.top, 10)
                    .padding(.leading, 10)
                Text("Items")
                    .fontWeight(.bold)
                    .padding(.top, 15)
                    .padding(.leading, 15)
                List {
                    ForEach(items) { item in
                        Button(action: {
                            presentSheet = false
                            withAnimation {
                                switch(sheetSelection) {
                                case .breakfast:
                                    selectedDay.breakfast.append(item)
                                    print(selectedDay.breakfast)
                                case .lunch:
                                    selectedDay.lunch.append(item)
                                    print(selectedDay.lunch)
                                case .dinner:
                                    selectedDay.dinner.append(item)
                                    print(selectedDay.dinner)
                                case .snack:
                                    selectedDay.snack.append(item)
                                    print(selectedDay.snack)
                                }
                            }
                        }, label: {
                                SheetItem(item: item)
                            })
                            .listRowSeparator(.hidden)
                            .listRowInsets(EdgeInsets(.init(top: 30, leading: 20, bottom: 30, trailing: 20)))
                            .swipeActions(allowsFullSwipe: false) {
                            Button(role: .destructive, action: {
                                for day in days {
                                    if let index = day.breakfast.firstIndex(of: item) {
                                        day.breakfast.remove(at: index)
                                    }
                                    if let index = day.lunch.firstIndex(of: item) {
                                        day.lunch.remove(at: index)
                                    }
                                    if let index = day.dinner.firstIndex(of: item) {
                                        day.dinner.remove(at: index)
                                    }
                                }
                                modelContext.delete(item)
                            }, label: {
                                    Image(systemName: "trash")
                                })
                            NavigationLink(destination: SheetForm(itemName: item.name, itemDesc: item.desc, calories: Decimal(item.calories), protien: Decimal(item.protien), carbs: Decimal(item.carbs), fat: Decimal(item.fat), isEditing: true, item: item)) {
                                Image(systemName: "applepencil")
                            }
                                .tint(.blue)
                        }
                    }
                    CardDescriptionAddButton()
                        .background(
                        NavigationLink("", destination: SheetForm(itemName: "", itemDesc: "", calories: Decimal(0), protien: Decimal(0), carbs: Decimal(0), fat: Decimal(0)))
                            .opacity(0)
                    )
                        .listRowSeparator(.hidden)
                        .listRowInsets(EdgeInsets(.init(top: 30, leading: 20, bottom: 30, trailing: 20)))
                }
                    .listStyle(.plain)
            }
        }
    }
}

struct SheetForm: View {
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    @Environment(\.modelContext) private var modelContext
    @Query var items: [Item]
//    @State var calories: String = "0"
//    @State var protien: String = "0"
//    @State var carbs: String = "0"
//    @State var fat: String = "0"

    @State var itemName: String
    @State var itemDesc: String

    @State var calories: Decimal
    @State private var caloriesPrecision = DecimalPrecision()

    @State var protien: Decimal
    @State private var protienPrecision = DecimalPrecision()

    @State var carbs: Decimal
    @State private var carbsPrecision = DecimalPrecision()

    @State var fat: Decimal
    @State private var fatPrecision = DecimalPrecision()

    @State var date: Date = Date.now
    @State var displayFormError: Bool = false

    var isEditing: Bool = false
    var item: Item?

    private static let formatter: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        return formatter
    }()

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            Button(action: {
                presentationMode.wrappedValue.dismiss()
            }, label: {
                    HStack(spacing: 5) {
                        Image(systemName: "chevron.left")
                        Text("back")
                    }
                        .font(.system(size: 12))
                })
                .buttonStyle(.plain)
                .padding(.top, 10)
                .padding(.leading, 10)
            TextField("Item Name", text: $itemName)
                .fontWeight(.bold)
                .padding(.top, 15)
                .padding(.leading, 15)
                .padding(.bottom, 5)
            TextField("Item Desc", text: $itemDesc)
                .padding(.bottom, 15)
                .padding(.leading, 15)
                .font(.system(size: 14, weight: .regular))
            HStack {
                VStack(spacing: 0) {
                    Text("Calories")
                        .font(.system(size: 14))
                    ZStack {
//                        DecimalTextField("0", value: $calories, precision: caloriesPrecision)
//                            .keyboardType(.decimalPad)
//                            .multilineTextAlignment(.center)
                        DecimalTextField("0", value: $calories)
                            .multilineTextAlignment(.center)
                        ActivityRingView(progress: Double(calories.description)! / caloriesMax, color: Color.calories, lineWidth: 10)
                    }
                }
                    .font(.system(size: 12))
                    .fontWeight(.regular)
                VStack(spacing: 0) {
                    Text("Protien")
                        .font(.system(size: 14))
                    ZStack {
                        DecimalTextField("0", value: $protien, precision: protienPrecision)
                            .multilineTextAlignment(.center)
                        ActivityRingView(progress: Double(protien.description)! / protienMax, color: Color.protien, lineWidth: 10)
                    }
                }
                    .font(.system(size: 12))
                    .fontWeight(.regular)
                VStack(spacing: 0) {
                    Text("Carbs")
                        .font(.system(size: 14))
                    ZStack {
                        DecimalTextField("0", value: $carbs, precision: carbsPrecision)
                            .multilineTextAlignment(.center)
                        ActivityRingView(progress: Double(carbs.description)! / carbsMax, color: Color.carbs, lineWidth: 10)
                    }
                }
                    .font(.system(size: 12))
                    .fontWeight(.regular)
                VStack(spacing: 0) {
                    Text("Fat")
                        .font(.system(size: 14))
                    ZStack {
                        DecimalTextField("0", value: $fat, precision: fatPrecision)
                            .multilineTextAlignment(.center)
                        ActivityRingView(progress: Double(fat.description)! / fatMax, color: Color.fat, lineWidth: 10)
                    }
                }
                    .font(.system(size: 12))
                    .fontWeight(.regular)
            }
                .padding(.bottom, 10)
            Divider()
                .padding(.bottom, 20)
            DatePicker("Date & Time", selection: $date, in: Date.now...)
                .padding(.horizontal, 10)
                .fontWeight(.bold)
            Spacer()

//            MARK: - ADD ITEM BUTTON
            if displayFormError {
                HStack {
                    Spacer()
                    Text("*Item Name field is required.")
                        .foregroundStyle(Color.red)
                        .font(.system(size: 14))
                    Spacer()
                }
            }
            Button {
                if itemName == "" {
                    displayFormError = true
                    DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                        withAnimation {
                            displayFormError = false
                        }
                    }
                } else {
                    if isEditing {
                        item?.name = itemName
                        item?.desc = itemDesc
                        item?.calories = Double(calories.description)!
                        item?.protien = Double(protien.description)!
                        item?.carbs = Double(carbs.description)!
                        item?.fat = Double(fat.description)!
                        presentationMode.wrappedValue.dismiss()
                    } else {
                        let newItem = Item(name: itemName, desc: itemDesc, calories: Double(calories.description)!, protien: Double(protien.description)!, carbs: Double(carbs.description)!, fat: Double(fat.description)!, timestamp: date)
                        modelContext.insert(newItem)
                        presentationMode.wrappedValue.dismiss()
                    }
                }
            } label: {
                RoundedRectangle(cornerRadius: 10)
                    .overlay {
                    VStack {
                        Text(isEditing ? "Save Edit" : "Add Item")
                    }
                        .foregroundStyle(Color.white)
                        .padding(.vertical, 10)
                }
                    .frame(height: 50)
                    .foregroundStyle(Color.black)
                    .padding(.horizontal, 10)
                    .padding(.top, 10)
            }
        }
            .navigationBarBackButtonHidden()
    }
}

struct SheetItem: View {
    var item: Item
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
        }
    }
}
