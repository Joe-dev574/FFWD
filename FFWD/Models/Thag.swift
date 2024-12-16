//
//  Thag.swift
//  FFWD
//
//  Created by Joseph DeWeese on 12/15/24.
//

import SwiftUI
import SwiftData

@Model
class Thag {
    var name: String = ""
    var color: String = "FF0000"
    var items: [Item]?
    
    init(name: String, color: String) {
        self.name = name
        self.color = color
    }
    
    var hexColor: Color {
        Color(hex: self.color) ?? .blue
    }
}




