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
    @Query var tasks: [Task]
    // 11 - now show this
    @State private var path = [Task]()
    
    @State private var showingTaskSheet = false
    
    var body: some View {
        // 11 - bind it to the path of our nav stack
        NavigationStack(path: $path) {
            List {
                ForEach(tasks) { task in
                    HStack {
                        Button {
                            withAnimation {
                                task.completed.toggle()
                            }
                        } label: {
                            Image(systemName: task.completed ? "checkmark.circle.fill": "circle")
                        }
                        .contentTransition(.symbolEffect(.replace))
                        
                        Text(task.text)
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
                        Image(systemName: "plus")
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
    
    // 7 - delete data
    func deleteTasks(_ indexSet: IndexSet) {
        for index in indexSet {
            let task = tasks[index]
            modelContext.delete(task)
        }
        
    }
}
    

#Preview {
    ContentView()
}
