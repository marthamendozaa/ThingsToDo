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
    // 4- Query marco from swiftdata, it'll read all destination objects currently being stored by our swiftdata database. It also watches the database for changes, refreshes its array and tells swiftui to iupdate
    //@Query(sort: \Task.text) var tasks: [Task]
    @Query(sort: \Task.text) private var allTasks: [Task]
   
    // 11 - now show this
    @State private var path = [Task]()
    
    @State private var showingTaskSheet = false
    
    var body: some View {
        // 11 - bind it to the path of our nav stack
        NavigationStack(path: $path) {
            List {
                ForEach(tasksDueToday) { task in
                    HStack {
                        Button {
                            withAnimation {
                                task.completed.toggle()
                            }
                        } label: {
                            Image(systemName: task.completed ? "checkmark.circle.fill": "circle")
                        }
                        .contentTransition(.symbolEffect(.replace))
                        
                        //Text(task.text)
                        
                        if task.isEditing {
                            TextField("Task Description", text: Binding(
                                get: { task.text },
                                set: { task.text = $0 }
                            )) { isEditing in
                                if !isEditing {
                                    task.isEditing = false
                                }
                            }
                            //.textFieldStyle(.roundedBorder)
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
                        
                        Label("Add task", systemImage: "plus.fill")
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
    
    // 6 - add sample data with modelContext
    func addSamples() {
        let rome = Task(text: "Rome")
        let florence = Task(text: "Florence")
        let naples = Task(text: "Naples")
        
        modelContext.insert(rome)
        modelContext.insert(florence)
        modelContext.insert(naples)
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

