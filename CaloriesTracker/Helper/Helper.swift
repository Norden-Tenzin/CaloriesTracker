//
//  Helper.swift
//  CaloriesTracker
//
//  Created by Tenzin Norden on 11/27/23.
//

import Foundation
import SwiftUI
import Combine

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

//MARK: - Parse and format decimal strings with remembered precision
class DecimalPrecision {
    private let validCharSet = CharacterSet(charactersIn: "1234567890.")

    var integerDigits : Int = -2
    var fractionDigits : Int = -2
    var defaultFormatter: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.alwaysShowsDecimalSeparator = false
        formatter.maximumFractionDigits = 10
        return formatter
    }()

    func parseDecimal(_ text: String) -> Decimal? {
        if text.rangeOfCharacter(from: validCharSet.inverted) != nil {
            return nil
        }
        if text.isEmpty {
            integerDigits = -1
            fractionDigits = -1
            return 0
        }
        if let value = Decimal(string: text) {
            let substring = text.split(separator: Character("."),
                                       maxSplits: 2,
                                       omittingEmptySubsequences: false)
            switch substring.count {
                case 1:
                    integerDigits = substring[0].count
                    fractionDigits = -1
                    return value
                case 2:
                    integerDigits = substring[0].count
                    fractionDigits = substring[1].count
                    return value
                default:
                    return nil
            }
        } else {
            return nil
        }
    }

    func formatDecimal(_ value: Decimal) -> String {
        if integerDigits == -2 && fractionDigits == -2 {
            let formatter = NumberFormatter()
            formatter.minimumIntegerDigits = 0
            formatter.alwaysShowsDecimalSeparator = false
            formatter.maximumFractionDigits = 10
            let result = formatter.string(from: value as NSDecimalNumber)!
            return result
        }
        if integerDigits == -1 && fractionDigits == -1 {
            return ""
        }
        if value == Decimal.zero && integerDigits == 0 && fractionDigits == 0 {
            return "."
        }
        let formatter = NumberFormatter()
        formatter.minimumIntegerDigits = integerDigits
        formatter.maximumIntegerDigits = integerDigits
        if fractionDigits >= 0 {
            formatter.alwaysShowsDecimalSeparator = true
            formatter.minimumFractionDigits = fractionDigits
            formatter.maximumFractionDigits = fractionDigits
        } else {
            formatter.alwaysShowsDecimalSeparator = false
            formatter.maximumFractionDigits = 0
        }
        return formatter.string(from: value as NSDecimalNumber)!
    }

    convenience init(using: NumberFormatter) {
        self.init()
        defaultFormatter = using
    }
}

//MARK: - Decimal Text Field with allowed external precision
struct DecimalTextField: View {
    private class DecimalTextModel: ObservableObject {
        var valueBinding: Binding<Decimal>
        var precision: DecimalPrecision
        @Published var text: String {
            didSet{
                if self.text != oldValue {
//                    print("set text: was: ", oldValue, "is:", self.text)
                    if let value = self.precision.parseDecimal(self.text) {
                        if value != self.valueBinding.wrappedValue {
                            self.valueBinding.wrappedValue = value
                        }
                    } else {
                        self.text = oldValue
                    }
                }
            }
        }
        init(value: Binding<Decimal>, precision: DecimalPrecision) {
            valueBinding = value
            self.precision = precision
            text = precision.formatDecimal(value.wrappedValue)
        }
    }

    @ObservedObject private var viewModel: DecimalTextModel
    private let placeHolder: String
    init(_ placeHolder: String = "", value: Binding<Decimal>, precision: DecimalPrecision) {
//        print("init field: value:", value.wrappedValue, "int dig:", precision.integerDigits, "frac dig:", precision.fractionDigits, "prec ptr:", Unmanaged.passUnretained(precision).toOpaque())
        self.placeHolder = placeHolder
        self.viewModel = DecimalTextModel(value: value, precision: precision)
    }
    init(_ placeHolder: String = "", value: Binding<Decimal>) {
        self.init(placeHolder, value: value, precision: DecimalPrecision())
    }

    var body: some View {
        TextField(placeHolder, text: $viewModel.text)
            .keyboardType(.decimalPad)
    }
}

func get24Time(date: Date) -> String {
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "HH:mm"
    return dateFormatter.string(from: date)
}
