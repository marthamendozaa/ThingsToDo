//
//  NewTaskView.swift
//  ThingsToDo
//
//  Created by Martha Mendoza Alfaro on 10/12/24.
//

import SwiftUI
import SwiftData


struct EditTaskView: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(\.modelContext) private var modelContext
    @Bindable var task: Task // Bind the task to edit
    
    @Query(sort: \Folder.name) private var folders: [Folder]
    @State private var selectedFolder: Folder?

    var body: some View {
        NavigationView {
            Form {
                Section {
                    TextField("Write your task here", text: $task.text)
                        .padding(.top)
                        .padding(.bottom)
                }
                Section {
                    DatePicker("Due Date", selection: $task.dueDate, displayedComponents: .date)
                    
                }
                Section {
                    Picker("Folder", selection: $selectedFolder) {
                        //Text("No Folder").tag(nil as Folder?)
                        ForEach(folders) { folder in
                            Text(folder.name).tag(folder as Folder?)
                        }
                    }
                }
            }
            //.formStyle(.grouped)
            .navigationTitle("Edit Task")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Save") {
                        task.folder = selectedFolder
                        dismiss()
                    }
                }
                
                ToolbarItem(placement: .bottomBar) {
                    Button(role: .destructive, action: deleteTask) {
                        Label("Delete Task", systemImage: "trash")
                            .foregroundColor(.red)
                    }
                }
            }
            .onAppear {
                selectedFolder = task.folder
            }
        }
    }
    
    private func deleteTask() {
        modelContext.delete(task)
        dismiss()
    }
    
}




#Preview {
    let folder = Folder(name: "My To Do List", colorName: "blue", icon: "list.bullet")
    let task = Task(dueDate: .now, text: "Mock Task", completed: false, folder: folder)
    return NavigationStack {
        EditTaskView(task: task)
    }
    .modelContainer(for: [Folder.self, Task.self]) // Simulates SwiftData environment
}

