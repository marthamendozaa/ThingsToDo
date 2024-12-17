//
//  Preview.swift
//  ThingsToDo
//
//  Created by Martha Mendoza Alfaro on 11/12/24.
//

import Foundation
import SwiftData
import SwiftUI



struct MockData: PreviewModifier {
    func body(content: Content, context: ModelContainer) -> some View {
        content
            .modelContainer(context)
    }
    
    static func makeSharedContext() async throws -> ModelContainer {
        let container = try! ModelContainer(
            for: Task.self, Folder.self,
            configurations: ModelConfiguration(isStoredInMemoryOnly: true)
        )
        
        container.mainContext.insert(Task(dueDate: Date(),text: "Unsalted butter"))
        container.mainContext.insert(Task(dueDate: Date(), text: "Dark chocolate"))
        container.mainContext.insert(Task(dueDate: Calendar.current.date(byAdding: .day, value: 1, to: Date())!, text: "Eggs"))
        container.mainContext.insert(Task(dueDate: Calendar.current.date(byAdding: .day, value: 1, to: Date())!, text: "Caster sugar"))
        container.mainContext.insert(Task(dueDate: Calendar.current.date(byAdding: .day, value: 1, to: Date())!, text: "Cocoa powder"))
        
        container.mainContext.insert(Folder(name: "Groceries", colorName: "blue", icon: "bag"))
        
        
        let folder = Folder(name: "Generic")
        container.mainContext.insert(folder)
        
        // Fetch the folder object
        let fetchDescriptor = FetchDescriptor<Folder>()
        if let groceriesFolder = try? container.mainContext.fetch(fetchDescriptor).first {
            
            // Insert the new task into the folder
            let newTask = Task(dueDate: Date(), text: "Cocoa sweets", folder: groceriesFolder)
            container.mainContext.insert(newTask)
            
            let newTask2 = Task(dueDate: Date(), text: "Cocoa cakes", folder: groceriesFolder)
            container.mainContext.insert(newTask2)
            
            // Fetch the folder again to verify
            if let updatedFolder = try? container.mainContext.fetch(fetchDescriptor).first {
                print("Folder: \(updatedFolder.name)")
                for task in updatedFolder.tasks {
                    print("Task: \(task.text), Due Date: \(task.dueDate)")
                }
            }
        }
        
        return container
    }
}

extension PreviewTrait where T == Preview.ViewTraits {
    static var mockData: Self = modifier(MockData())
}
