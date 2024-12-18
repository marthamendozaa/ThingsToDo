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
                    .foregroundColor(.pink)
                }
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Save") {
                        task.folder = selectedFolder
                        dismiss()
                    }
                    .disabled(task.text.isEmpty)
                    .foregroundColor(.pink)
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




