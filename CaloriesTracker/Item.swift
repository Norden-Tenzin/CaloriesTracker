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
    var timestamp: Date
    
    init(timestamp: Date) {
        self.timestamp = timestamp
    }
}
