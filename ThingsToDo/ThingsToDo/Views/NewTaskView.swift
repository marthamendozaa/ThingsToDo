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
    
    var body: some View {
        NavigationView {
            Form {
                TextField("Task Description", text: $taskText)
                
                Section {
                    Button("Save Task") {
                        let newTask = Task(text: taskText)
                        modelContext.insert(newTask) // Save task to SwiftData
                        dismiss() // Close the sheet
                    }
                    .disabled(taskText.isEmpty) // Disable button if no text
                }
            }
            .navigationTitle("New Task")
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
            }
        }
    }
}

#Preview {
    NewTaskView()
}
