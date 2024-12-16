//
//  Objective.swift
//  FFWD
//
//  Created by Joseph DeWeese on 12/15/24.
//

import SwiftUI
import SwiftData

@Model
class Objective {
    var creationDate: Date = Date.now
    var dueDate: Date = Date.distantPast
    var completeDate: Date = Date.distantPast
    var objectiveName: String = ""
    var objectiveDescription: String? = ""
    var objectiveStatus: ObjectiveStatus.RawValue = ObjectiveStatus.Hold.rawValue
    
    init(
        creationDate: Date,
        dueDate: Date,
        completeDate: Date,
        objectiveName: String,
        objectiveDescription: String? = nil,
        objectiveStatus: ObjectiveStatus.RawValue,
        item: Item? = nil
    ) {
        self.creationDate = creationDate
        self.dueDate = dueDate
        self.completeDate = completeDate
        self.objectiveName = objectiveName
        self.objectiveDescription = objectiveDescription
        self.objectiveStatus = objectiveStatus
    }
    var objectiveIcon: Image {
        switch ObjectiveStatus(rawValue: objectiveStatus)! {
        case .Hold:
            Image("task")
        case .Active:
            Image(systemName: "item.fill")
        case .Completed:
            Image(systemName: "books.vertical.fill")
        }
    }

enum ObjectiveStatus: Int, Codable, Identifiable, CaseIterable {
    case Hold, Active, Completed
    var id: Self {
        self
    }
    var descr: LocalizedStringResource {
        switch self {
        case .Hold:
            "On Shelf"
        case .Active:
            "Idea"
        case .Completed:
            "Journal"
        }
    }
}
    var item: Item?
}

