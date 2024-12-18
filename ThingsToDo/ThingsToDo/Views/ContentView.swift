//
//  ContentView.swift
//  ThingsToDo
//
//  Created by Martha Mendoza Alfaro on 10/12/24.
//

import SwiftUI
// 4- add swiftdata
import SwiftData


struct ContentView: View {
    
    // 5 - its save to be done in any. store our objects
    @Environment(\.modelContext) var modelContext
    // 4-  It also watches the database for changes, refreshes its array and tells swiftui to iupdate
    //@Query(sort: \Task.text) var tasks: [Task]
    @Query private var allTasks: [Task]
    @Query(sort: \Folder.name) private var folders: [Folder]
    
   
    // 11 - now show this
    @State private var path = [Folder]()
    
    @State private var showingFolderSheet = false
    @State private var showingTaskSheet = false
    @State private var expandedFolders: Set<UUID> = [] // Tracks which folders are expanded
    @State private var selectedFolder: Folder? = nil
    
    var body: some View {
        // 11 - bind it to the path of our nav stack
        NavigationStack(path: $path) {
            List {
                
                ForEach(folders) { folder in
                    let tasksDueToday = tasksForToday(in: folder)
                    if !tasksDueToday.isEmpty {
                        FolderRow(folder: folder, tasks: tasksDueToday)
                            .listRowBackground(Color(UIColor.systemGray6)) // Keep gray background
                            .foregroundStyle(Color.primary) // Ensure text has no white outline
                    }
                }
                .onDelete(perform: deleteFolders) // Enable swipe-to-delete for folders
            }
            .buttonStyle(BorderlessButtonStyle())
            .scrollContentBackground(.hidden) // Hide white content background
            //.background(Color(UIColor.systemGray6)) // Set overall background to gray
            //.background(Color.clear)
            .navigationTitle("Today ☻♡")
            
            .toolbar {
                // 12 - add new button destination
                ToolbarItem(placement: .primaryAction) {
                    Button(action: {
                        showingTaskSheet.toggle()
                    }) {
                        
                        Label("Add task", systemImage: "plus")
                            .labelStyle(.titleAndIcon)
                        //Image(systemName: "plus")
                        //Text("Add task")
                    }
                }
                
                
                ToolbarItem() {
                    Button(action: {
                        showingFolderSheet.toggle()
                    }) {
                        Label("Create folder", systemImage: "folder.badge.plus")
                            .labelStyle(.titleAndIcon)
                        //Image(systemName: "plus")
                        //Text("Add task")
                    }
                }
            }
            .sheet(isPresented: $showingTaskSheet) {
                NewTaskView()
            }
            .sheet(isPresented: $showingFolderSheet) {
                NewFolderView()
            }
        }
        .onAppear { createDefaultFolderIfNeeded() }
    }
    
    // Filter tasks due today for a specific folder
    private func tasksForToday(in folder: Folder) -> [Task] {
        let today = Calendar.current.startOfDay(for: Date())
        return folder.tasks.filter {
            Calendar.current.isDate($0.dueDate, inSameDayAs: today)
        }
    }
    
    // Computed property to filter tasks
    private var tasksDueToday: [Task] {
        let today = Calendar.current.startOfDay(for: Date()) // Start of today
        return allTasks.filter {
            Calendar.current.isDate($0.dueDate, inSameDayAs: today)
        }
    }
    
    func deleteTasks(_ indexSet: IndexSet) {
        for index in indexSet {
            let task = tasksDueToday[index] // Use filtered tasks
            modelContext.delete(task)
        }
    }
    
    
    // Function to ensure the built-in folder exists
    private func createDefaultFolderIfNeeded() {
        if !folders.contains(where: { $0.name == "My To Do List" }) {
            let defaultFolder = Folder(name: "My To Do List", colorName: "blue", icon: "list.bullet")
            modelContext.insert(defaultFolder)
        }
    }
    
    // Delete folders
    private func deleteFolders(at offsets: IndexSet) {
        for index in offsets {
            let folder = folders[index]
            modelContext.delete(folder)
        }
    }
}


#Preview(traits: .mockData) {
    ContentView()
}
