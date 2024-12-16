//
//  NewTaskView.swift
//  ThingsToDo
//
//  Created by Martha Mendoza Alfaro on 10/12/24.
//

import SwiftUI

struct NewTaskView: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(\.modelContext) private var modelContext
    @State private var taskText: String = ""
    @State private var dueDate: Date = .now // Default to today
    
    var body: some View {
        NavigationView {
            Form {
                TextField("Task Description", text: $taskText)
                
                DatePicker("Due Date", selection: $dueDate, displayedComponents: .date)
                
            }
            .navigationTitle("New Task")
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
                
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Save Task") {
                        let newTask = Task(dueDate: dueDate, text: taskText)
                        modelContext.insert(newTask) // Save task to SwiftData
                        dismiss()
                    }
                    .disabled(taskText.isEmpty)
                }
            }
        }
    }
}

#Preview {
    NewTaskView()
}
