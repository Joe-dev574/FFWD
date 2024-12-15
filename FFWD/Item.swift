//
//  Item.swift
//  FFWD
//
//  Created by Joseph DeWeese on 12/15/24.
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
