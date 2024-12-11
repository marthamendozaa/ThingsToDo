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
    //var id: UUID
    var dueDate: Date
    var text: String
    var completed: Bool
    
    init(dueDate: Date = .now, text: String = "", completed: Bool = false) {
        //self.id = UUID()
        self.dueDate = dueDate
        self.text = text
        self.completed = completed
    }
    
}
