//
//  EditTaskView.swift
//  ThingsToDo
//
//  Created by Martha Mendoza Alfaro on 10/12/24.
//

// 1 - Add needed frameworks
import SwiftUI
import SwiftData
import AVFoundation

struct EditTaskView: View {
    
    // only for reading
    /*var destination: Destination */
    // 8 - bind them to text fields, pickers, sp we can edit the values overtime. Add property wrapper. add any kind of bindings.
    @Bindable var task: Task
    
    var body: some View {
        Form {
            //$ bound to
            TextField("Name", text: $task.text)

            DatePicker("Date", selection: $task.date)
            
            Section("Priority") {
                Picker("Priority", selection: $task.completed) {
                    Text("Yes").tag(true)
                    Text("No").tag(false)
                }
                .pickerStyle(.segmented)
            }
        }
        .navigationTitle("Edit Task")
        .navigationBarTitleDisplayMode(.inline)
    }
}

#Preview {
    // 9 -
    do {
        //conf for the preview if you dont have it the preview will struggle
        let config = ModelConfiguration(isStoredInMemoryOnly: true)
        let container = try ModelContainer(for: Task.self, configurations: config)
        
        let example = Task(text: "Example Task")
        return EditTaskView(task: example)
            .modelContainer(container)
    } catch {
        fatalError("Could not create model container: \(error)")
    }
}
