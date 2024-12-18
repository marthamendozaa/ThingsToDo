//
//  NewTaskView.swift
//  ThingsToDo
//
//  Created by Martha Mendoza Alfaro on 10/12/24.
//

import SwiftUI
import SwiftData

struct NewLogView: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(\.modelContext) private var modelContext
    @Query(sort: \Task.dueDate) private var tasks: [Task] // Fetch tasks

    @State private var gratitude: String = ""
    @State private var reflection: String = ""
    @State private var completedTaskCount = 0 // Dynamically calculated

    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Completed Tasks")) {
                    Text("You completed \(completedTaskCount) tasks today.")
                        .font(.headline)
                }
                
                Section(header: Text("Reflection")) {
                    TextField("What did you do today?", text: $reflection)
                }
                
                Section(header: Text("Gratitude")) {
                    TextField("What are you grateful for today?", text: $gratitude)
                }
                
            }
            .navigationTitle("New Log")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Save") {
                        saveLog()
                        dismiss()
                    }
                }
            }
            .onAppear {
                calculateCompletedTasks()
            }
        }
    }

    private func calculateCompletedTasks() {
        let today = Calendar.current.startOfDay(for: Date())
        completedTaskCount = tasks.filter {
            $0.completed && Calendar.current.isDate($0.dueDate, inSameDayAs: today)
        }.count
    }

    private func saveLog() {
        let newLog = Log(
            date: Date(),
            completedTasks: completedTaskCount,
            gratitude: gratitude,
            reflection: reflection
        )
        modelContext.insert(newLog)
    }
}

#Preview {
    NewLogView()
}


/*
struct NewLogView: View {
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
    NewLogView()
}


*/
