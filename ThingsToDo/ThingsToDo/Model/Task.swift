//
//  TaskModel.swift
//  ThingsToDo
//
//  Created by Martha Mendoza Alfaro on 10/12/24.
//

import SwiftUI
// 1- ADD SWIFT DATA
import SwiftData

@Model
class Log {
    var date: Date
    var completedTasks: Int
    var gratitude: String
    var reflection: String

    init(date: Date = .now, completedTasks: Int, gratitude: String = "", reflection: String = "") {
        self.date = date
        self.completedTasks = completedTasks
        self.gratitude = gratitude
        self.reflection = reflection
    }
}


@Model
class Folder {
    var name: String
    var colorName: String
    var icon: String
    @Relationship(deleteRule: .cascade) var tasks: [Task] = [] // One-to-many relationship
    
    var color: Color {
        Folder.colorMap[colorName] ?? .blue // Fallback to .blue if not found
    }
    
    // Static mapping of color names to SwiftUI dynamic colors
    static let colorMap: [String: Color] = [
        "blue": .blue,
        "red": .red,
        "green": .green,
        "yellow": .yellow,
        "orange": .orange,
        "purple": .purple,
        "pink": .pink,
        "teal": .teal
    ]
    
    init(name: String, colorName: String = "blue", icon: String = "star.fill") {
        self.name = name
        self.colorName = colorName
        self.icon = icon
    }
}

// 2- ADD MODEL save and load destination object inside its permanent storage
@Model
class Task {
    //var id: UUID
    var dueDate: Date
    var text: String
    var completed: Bool
    var isEditing: Bool = false
    var folder: Folder? // Optional relationship to a folder
    
    init(dueDate: Date = .now, text: String = "", completed: Bool = false, isEditing: Bool = false, folder: Folder? = nil) {
        //self.id = UUID()
        self.dueDate = dueDate
        self.text = text
        self.completed = completed
        self.isEditing = isEditing
        self.folder = folder
    }
    
}

