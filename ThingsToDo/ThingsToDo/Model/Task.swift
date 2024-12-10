//
//  TaskModel.swift
//  ThingsToDo
//
//  Created by Martha Mendoza Alfaro on 10/12/24.
//

import Foundation
// 1- ADD SWIFT DATA
import SwiftData


// 2- ADD MODEL save and load destination object inside its permanent storage
@Model
class Task {
    var id: UUID
    var date: Date
    var completed: Bool
    var text: String
    
    init(date: Date = .now, completed: Bool = false, text: String = "") {
        self.id = UUID()
        self.date = date
        self.completed = completed
        self.text = text
    }
    
}
