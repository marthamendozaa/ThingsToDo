//
//  NewTaskView.swift
//  ThingsToDo
//
//  Created by Martha Mendoza Alfaro on 10/12/24.
//

import SwiftUI
import SwiftData


struct NewTaskView: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(\.modelContext) private var modelContext
    @State private var taskText: String = ""
    @State private var dueDate: Date = .now
    @Query(sort: \Folder.name) private var folders: [Folder]
    @State private var selectedFolder: Folder?

    var folder: Folder?

    var body: some View {
        NavigationView {
            Form {
                Section {
                    TextField("Write your task here", text: $taskText)
                        .padding(.top)
                        .padding(.bottom)
                }
                Section {
                    DatePicker("Due Date", selection: $dueDate, displayedComponents: .date)
                    
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
            .navigationTitle("New Task")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Add") {
                        let newTask = Task(dueDate: dueDate, text: taskText, folder: selectedFolder ?? folder)
                        modelContext.insert(newTask)
                        dismiss()
                    }
                    .disabled(taskText.isEmpty)
                }
            }
            .onAppear {
                selectedFolder = defaultFolder()
            }
        }
    }
    
    private func defaultFolder() -> Folder? {
        return folders.first(where: { $0.name == "My To Do List" })
    }
}

#Preview {
    NewTaskView()
}


