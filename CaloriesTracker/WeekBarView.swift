//
//  WeekBarView.swift
//  CaloriesTracker
//
//  Created by Tenzin Norden on 11/25/23.
//

import SwiftUI

struct WeekBarView: View {
    @State var today: Date = Date()
    @State var week: [Date] = []
    @Binding var selection: Date

    var body: some View {
        HStack {
            ForEach(week, id: \.self) { date in
                WeekBarItem(date: date, selection: $selection, disabled: date == week.last!)
                if let last = week.last {
                    if last != date {
                        Spacer()
                    }
                }
            }
        }
            .onAppear() {
            today = Date.now
            let weekIndex = [-5, -4, -3, -2, -1, 0, 1]

            for index in weekIndex {
                let calendar = Calendar.current

                // Define the date components to subtract
                var dateComponents = DateComponents()
                dateComponents.day = index

                // Subtract days from the current date
                week.append(calendar.date(byAdding: dateComponents, to: today)!)
            }
        }
    }
}

struct WeekBarItem: View {
    @State var date: Date
    @Binding var selection: Date
    @State var weekDay: String = ""
    @State var dateNum: String = ""
    @State var disabled: Bool
    let grayif = "17"
    let selected = 16

    var body: some View {
        VStack {
            if getDate(date: date) == getDate(date: selection) {
                Text(weekDay)
                    .font(.system(size: 12))
                    .foregroundStyle(Color.white)
            }
            else if disabled {
                Text(weekDay)
                    .font(.system(size: 12))
                    .foregroundStyle(Color.secondary)
            }
            else {
                Text(weekDay)
                    .font(.system(size: 12))
                    .foregroundStyle(Color.black)
            }
            Text(dateNum)
                .fontWeight(.semibold)
                .padding(6)
                .foregroundStyle(disabled ? Color.secondary : Color.black)
                .background() {
                Circle()
                    .fill(getDate(date: date) == getDate(date: selection) ? Color.white : Color.clear)
            }
        }
            .padding(.top, 5)
            .padding(5)
            .background() {
            if getDate(date: date) == getDate(date: selection) {
                Capsule()
                    .fill(Color.black)
            }
        }
            .onTapGesture {
            selection = date
        }
            .onAppear() {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "eee"
            weekDay = dateFormatter.string(from: date)

            dateFormatter.dateFormat = "dd"
            dateNum = dateFormatter.string(from: date)
        }
    }
}

func getDate(date: Date) -> String {
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "MM/dd/yyyy"
    return dateFormatter.string(from: date)
}
