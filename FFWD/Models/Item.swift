//
//  Item.swift
//  FFWD
//
//  Created by Joseph DeWeese on 12/15/24.
//

import SwiftUI
import SwiftData


@Model
final class Item {
    var title: String = ""
    var remarks: String = ""
    var category: String = ""
    var dateAdded: Date = Date.now
    var dateStarted: Date = Date.distantPast
    var dateCompleted: Date = Date.distantPast
    var status: Status.RawValue = Status.Task.rawValue
    @Relationship(deleteRule: .cascade)
    var notes: [Note]?
    @Relationship(deleteRule: .cascade)
    var objectives: [Objective]?
    @Relationship(inverse: \Thag.items)
    var thags: [Thag]?
    
    
    init(
        title: String = "",
        remarks: String = "",
        dateAdded: Date = Date.now,
        dateStarted: Date = Date .distantPast,
        dateCompleted: Date = Date.distantPast,
        category: String = "",
        status: Status = .Task,
        thags: [Thag]? = nil
    ) {
        self.title = title
        self.remarks = remarks
        self.dateAdded = dateAdded
        self.dateStarted = dateStarted
        self.dateCompleted = dateCompleted
        self.category = category
        self.status = status.rawValue
        self.thags = thags
    }
    
    var icon: Image {
        switch Status(rawValue: status)! {
        case .Objective:
            Image(systemName: "list.bullet.rectangle.fill")
        case .Task:
            Image("task")
        case .Note:
            Image(systemName: "applepencil.tip")
        case .Idea:
            Image(systemName: "lightbulb.min.fill")
        case .Journal:
            Image(systemName: "bookmark.square.fill")
        case .Wiki:
            Image(systemName: "memorychip")
        }
    }
}
enum Status: Int, Codable, Identifiable, CaseIterable {
    case Task, Objective, Idea, Journal, Wiki, Note
    var id: Self {
        self
    }
    var descr: LocalizedStringResource {
        switch self {
        case .Task:
            "Task"
        case .Idea:
            "Idea"
        case .Journal:
            "Journal"
        case .Wiki:
            "Wiki"
        case .Note:
            "Note"
        case .Objective:
            "Objective / Project"
        }
    }
}
