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
    @State private var path = [Task]()
    
    @State private var showingFolderSheet = false
    @State private var showingTaskSheet = false
    @State private var expandedFolders: Set<UUID> = [] // Tracks which folders are expanded
    @State private var selectedFolder: Folder? = nil
    
    var body: some View {
        // 11 - bind it to the path of our nav stack
        NavigationStack(path: $path) {
            List {
                ForEach(tasksDueToday) { task in
                    
                    RowTaskView(task: task)
                    
                }
                .onDelete(perform: deleteTasks)
                // 7 - delete
            }
            .navigationTitle("Today")
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
                
                
                ToolbarItem(placement: .secondaryAction) {
                    Button(action: {
                        
                    }) {
                        Label("Create folder", systemImage: "plus")
                            .labelStyle(.titleAndIcon)
                        //Image(systemName: "plus")
                        //Text("Add task")
                    }
                }
            }
            .sheet(isPresented: $showingTaskSheet) {
                NewTaskView()
            }
        }
    }
    
    // 12 - add destination
    func addTask() {
        let task = Task()
        modelContext.insert(task)
        //show it in our nav stack RN
        path = [task]
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
}


#Preview(traits: .mockData) {
    ContentView()
}
