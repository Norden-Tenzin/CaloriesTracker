//
//  Helper.swift
//  CaloriesTracker
//
//  Created by Tenzin Norden on 11/27/23.
//

import Foundation
import SwiftUI
import Combine

enum Meals: String {
    case breakfast = "Breakfast"
    case lunch = "Lunch"
    case dinner = "Dinner"
    case snack = "Snack"
}

//  Used to remove the zeros in double and give a good looking string
//  return: String "10.00000" -> "10"
extension Double {
    func string(maximumFractionDigits: Int = 2) -> String {
        let s = String(format: "%.\(maximumFractionDigits)f", self)
        for i in stride(from: 0, to: -maximumFractionDigits, by: -1) {
            if s[s.index(s.endIndex, offsetBy: i - 1)] != "0" {
                return String(s[..<s.index(s.endIndex, offsetBy: i)])
            }
        }
        return String(s[..<s.index(s.endIndex, offsetBy: -maximumFractionDigits - 1)])
    }
}

//  MARK: - Activity Ring View
struct ActivityRingView: View {
    var progress: Double
    var color: Color
    var width: Double = 0
    var lineWidth: Double = 18

    var body: some View {
        if width > 0 {
            ZStack {
                Circle()
                    .stroke(color.opacity(0.1), lineWidth: lineWidth)
                    .frame(width: width)
                Circle()
                    .trim(from: 0, to: progress)
                    .stroke(color, style: StrokeStyle(lineWidth: lineWidth, lineCap: .round))
                    .rotationEffect(.degrees(-90))
                    .frame(width: width)
            }
                .padding()
        } else {
            ZStack {
                Circle()
                    .stroke(color.opacity(0.1), lineWidth: lineWidth)
                Circle()
                    .trim(from: 0, to: progress)
                    .stroke(color, style: StrokeStyle(lineWidth: lineWidth, lineCap: .round))
                    .rotationEffect(.degrees(-90))
            }
                .padding()
        }
    }
}

//  MARK: - Progress Bar View
struct SimpleBarProgressView: View {
    let progress: CGFloat
    let color: Color

    var body: some View {
        VStack {
            GeometryReader { bounds in
                Capsule(style: .circular)
                    .fill(color.opacity(0.2))
                    .overlay {
                    HStack {
                        Capsule(style: .circular)
                            .fill(color)
                            .frame(width: bounds.size.width * progress)
                        Spacer(minLength: 0)
                    }
                }
                    .clipShape(Capsule(style: .circular))
            }
                .frame(height: 15)
        }
    }
}

func get24Time(date: Date) -> String {
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "HH:mm"
    return dateFormatter.string(from: date)
}
