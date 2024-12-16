//
//  ContentViewWFolders.swift
//  ThingsToDo
//
//  Created by Martha Mendoza Alfaro on 16/12/24.
//

import SwiftUI
// 4- add swiftdata
import SwiftData
/*
struct ContentView: View {
    @Environment(\.modelContext) var modelContext
    @Query(sort: \Folder.name) private var folders: [Folder]
    @Query(sort: \Task.text) private var allTasks: [Task]

    @State private var showingFolderSheet = false
    @State private var showingTaskSheet = false
    @State private var expandedFolders: Set<UUID> = [] // Tracks expanded folders
    @State private var selectedFolder: Folder? = nil // Folder to add tasks

    var body: some View {
        NavigationStack {
            List {
                // Show folders with tasks due today
                ForEach(foldersWithTasksDueToday) { folder in
                    Section(
                        header: FolderHeader(
                            folder: folder,
                            isExpanded: isFolderExpanded(folder),
                            toggleAction: { toggleFolder(folder) } // Pass the toggle action
                        )
                    ) {
                        if isFolderExpanded(folder) {
                            ForEach(tasksDueToday(in: folder)) { task in
                                TaskRow(task: task)
                            }
                            .onDelete { indexSet in
                                deleteTasks(at: indexSet, from: folder)
                            }
                        }
                    }
                }
                .onDelete(perform: deleteFolders)
            }
            .listStyle(.insetGrouped)
            .navigationTitle("Today's Tasks")
            .toolbar {
                ToolbarItem(placement: .primaryAction) {
                    Button {
                        showingTaskSheet = true
                        selectedFolder = nil // Global task creation without a folder
                    } label: {
                        Label("Add Task", systemImage: "plus.circle")
                    }
                }
                ToolbarItem(placement: .secondaryAction) {
                    Button {
                        showingFolderSheet = true
                    } label: {
                        Label("Create Folder", systemImage: "folder.badge.plus")
                    }
                }
            }
            .sheet(isPresented: $showingTaskSheet) {
                NewTaskView(folder: selectedFolder)
            }
            .sheet(isPresented: $showingFolderSheet) {
                NewFolderView()
            }
        }
    }

    // MARK: - Filter Folders with Tasks Due Today
    private var foldersWithTasksDueToday: [Folder] {
        folders.filter { folder in
            !tasksDueToday(in: folder).isEmpty
        }
    }

    private func tasksDueToday(in folder: Folder) -> [Task] {
        let today = Calendar.current.startOfDay(for: Date())
        return folder.tasks.filter {
            Calendar.current.isDate($0.dueDate, inSameDayAs: today)
        }
    }

    // MARK: - Folder Expansion
    private func isFolderExpanded(_ folder: Folder) -> Bool {
        expandedFolders.contains(folder.id)
    }

    private func toggleFolder(_ folder: Folder) {
        if isFolderExpanded(folder) {
            expandedFolders.remove(folder.id)
        } else {
            expandedFolders.insert(folder.id)
        }
    }

    // MARK: - Deletion Logic
    private func deleteFolders(at offsets: IndexSet) {
        for index in offsets {
            let folder = foldersWithTasksDueToday[index]

            // Delete all tasks in the folder
            for task in folder.tasks {
                modelContext.delete(task)
            }

            // Delete the folder itself
            modelContext.delete(folder)
        }
    }

    private func deleteTasks(at offsets: IndexSet, from folder: Folder) {
        for index in offsets {
            let task = tasksDueToday(in: folder)[index]
            modelContext.delete(task)
        }
    }
}


struct FolderHeader: View {
    let folder: Folder
    let isExpanded: Bool
    var toggleAction: () -> Void

    var body: some View {
        HStack {
            Text(folder.name)
                .font(.headline)

            Spacer()

            Button {
                toggleAction()
            } label: {
                Image(systemName: isExpanded ? "chevron.down" : "chevron.right")
                    .foregroundColor(.blue)
            }
            .buttonStyle(.borderless)
        }
        .contentShape(Rectangle())
        .onTapGesture {
            toggleAction()
        }
    }
}


struct TaskRow: View {
    @State private var task: Task

    init(task: Task) {
        _task = State(wrappedValue: task)
    }

    var body: some View {
        HStack {
            Button {
                withAnimation {
                    task.completed.toggle()
                }
            } label: {
                Image(systemName: task.completed ? "checkmark.circle.fill" : "circle")
            }

            if task.isEditing {
                TextField("Task Description", text: Binding(
                    get: { task.text },
                    set: { task.text = $0 }
                )) { isEditing in
                    if !isEditing {
                        task.isEditing = false
                    }
                }
                .onSubmit {
                    task.isEditing = false
                }
            } else {
                Text(task.text)
                    .onTapGesture {
                        task.isEditing = true
                    }
            }
        }
    }
}



struct NewFolderView: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(\.modelContext) private var modelContext
    @State private var folderName: String = ""

    var body: some View {
        NavigationView {
            Form {
                TextField("Folder Name", text: $folderName)

                Section {
                    Button("Create Folder") {
                        let newFolder = Folder(name: folderName)
                        modelContext.insert(newFolder)
                        dismiss()
                    }
                    .disabled(folderName.isEmpty)
                }
            }
            .navigationTitle("New Folder")
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
                TextField("Task Description", text: $taskText)
                DatePicker("Due Date", selection: $dueDate, displayedComponents: .date)

                Picker("Folder", selection: $selectedFolder) {
                    Text("No Folder").tag(nil as Folder?)
                    ForEach(folders) { folder in
                        Text(folder.name).tag(folder as Folder?)
                    }
                }
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
                        let newTask = Task(dueDate: dueDate, text: taskText, folder: selectedFolder ?? folder)
                        modelContext.insert(newTask)
                        dismiss()
                    }
                    .disabled(taskText.isEmpty)
                }
            }
            .onAppear {
                selectedFolder = folder
            }
        }
    }
}



*/
