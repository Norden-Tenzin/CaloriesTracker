//
//  PopupSheetView.swift
//  CaloriesTracker
//
//  Created by Tenzin Norden on 11/27/23.
//

import SwiftUI
import SwiftData
import Combine

//  MARK: - Sheet Form
struct SheetForm: View {
    @Environment(\.modelContext) private var modelContext
    @Query var items: [Item]

    @Query var days: [Day]
    @Binding var presentSheet: Bool
    @Binding var selectedDay: Day
    var sheetSelection: Meals

    @State var itemName: String
    @State var calories: String
    @State var protien: String
    @State var carbs: String
    @State var fat: String
    @State var date: Date

    @State var displayFormError: Bool = false

    var isEditing: Bool = false
    @Binding var item: Item?

    private static let formatter: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        return formatter
    }()

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
//            MARK: Back Button
            Button(action: {
                presentSheet = false
                item = nil
            }, label: {
                    HStack(spacing: 5) {
                        Image(systemName: "chevron.left")
                        Text("back")
                    }
                })
                .buttonStyle(.plain)
                .padding(.top, 10)
                .padding(.leading, 10)
                .padding(.bottom, 10)

//            MARK: Stats Form
            HStack(alignment: .top) {
                VStack(spacing: 10) {
                    Text("Calories")
                        .font(.system(size: 14))
                    ZStack {
                        TextField("0", text: $calories)
                            .keyboardType(.numberPad)
                            .onReceive(Just(calories)) { newValue in
                            let filtered = newValue.filter { "0123456789".contains($0) }
                            if filtered != newValue {
                                self.calories = filtered
                            }
                        }
                            .multilineTextAlignment(.center)
                        ActivityRingView(progress: (Double(calories.description) ?? 0) / CALORIES_MAX, color: Color.calories, lineWidth: 10)
                    }
                        .frame(height: 60)
                }
                    .font(.system(size: 12))
                    .fontWeight(.regular)
                VStack(spacing: 10) {
                    Text("Protien")
                        .font(.system(size: 14))
                    ZStack {
                        TextField("0", text: $protien)
                            .keyboardType(.numberPad)
                            .onReceive(Just(protien)) { newValue in
                            let filtered = newValue.filter { "0123456789".contains($0) }
                            if filtered != newValue {
                                self.protien = filtered
                            }
                        }
                            .multilineTextAlignment(.center)
                        ActivityRingView(progress: (Double(protien.description) ?? 0) / PROTIEN_MAX, color: Color.protien, lineWidth: 10)
                    }
                        .frame(height: 60)
                }
                    .font(.system(size: 12))
                    .fontWeight(.regular)
                VStack(spacing: 10) {
                    Text("Carbs")
                        .font(.system(size: 14))
                    ZStack {
                        TextField("0", text: $carbs)
                            .keyboardType(.numberPad)
                            .onReceive(Just(carbs)) { newValue in
                            let filtered = newValue.filter { "0123456789".contains($0) }
                            if filtered != newValue {
                                self.carbs = filtered
                            }
                        }
                            .multilineTextAlignment(.center)
                        ActivityRingView(progress: (Double(carbs.description) ?? 0) / CARBS_MAX, color: Color.carbs, lineWidth: 10)
                    }
                        .frame(height: 60)
                }
                    .font(.system(size: 12))
                    .fontWeight(.regular)
                VStack(spacing: 10) {
                    Text("Fat")
                        .font(.system(size: 14))
                    ZStack {
                        TextField("0", text: $fat)
                            .keyboardType(.numberPad)
                            .onReceive(Just(fat)) { newValue in
                            let filtered = newValue.filter { "0123456789".contains($0) }
                            if filtered != newValue {
                                self.fat = filtered
                            }
                        }
                            .multilineTextAlignment(.center)
                        ActivityRingView(progress: (Double(fat.description) ?? 0) / FAT_MAX, color: Color.fat, lineWidth: 10)
                    }
                        .frame(height: 60)
                }
                    .font(.system(size: 12))
                    .fontWeight(.regular)
            }
                .padding(.bottom, 20)
            Divider()
                .padding(.bottom, 15)

//            MARK: Name Field
            TextField("Item Name", text: $itemName)
                .fontWeight(.bold)
                .padding(.leading, 15)
                .padding(.bottom, 10)
            
//            MARK: DatePicker Field
            DatePicker("Date & Time", selection: $date, displayedComponents: [.date, .hourAndMinute])
                .fontWeight(.bold)
                .padding(.horizontal, 15)
                .padding(.bottom, 10)

//            MARK: ADD ITEM BUTTON
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
                        presentSheet = false
                        item?.name = itemName
                        item?.calories = Double(calories.description) ?? 0
                        item?.protien = Double(protien.description) ?? 0
                        item?.carbs = Double(carbs.description) ?? 0
                        item?.fat = Double(fat.description) ?? 0
                        item?.timestamp = date
                        item = nil
                    } else {
                        presentSheet = false
                        let newItem = Item(name: itemName, calories: Double(calories.description) ?? 0, protien: Double(protien.description) ?? 0, carbs: Double(carbs.description) ?? 0, fat: Double(fat.description) ?? 0, timestamp: date)
                        modelContext.insert(newItem)
                        withAnimation {
                            switch(sheetSelection) {
                            case .breakfast:
                                selectedDay.breakfast.append(newItem)
                            case .lunch:
                                selectedDay.lunch.append(newItem)
                            case .dinner:
                                selectedDay.dinner.append(newItem)
                            case .snack:
                                selectedDay.snack.append(newItem)
                            }
                        }
                        item = nil
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
            Spacer()
        }
            .navigationBarBackButtonHidden()
            .onAppear() {
            if item != nil {
                itemName = item!.name
                calories = Int(item!.calories).description
                protien = Int(item!.protien).description
                carbs = Int(item!.carbs).description
                fat = Int(item!.fat).description
                date = item!.timestamp
            }
        }
    }
}

#Preview {
    SheetForm(presentSheet: .constant(true), selectedDay: .constant(Day(date: "", timestamp: Date())), sheetSelection: .breakfast, itemName: "", calories: "10", protien: "10", carbs: "10", fat: "10", date: Date(), item: .constant(Item(name: "", calories: 1000, protien: 10, carbs: 10, fat: 10, timestamp: Date())))
}
