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
            for: Task.self,
            configurations: ModelConfiguration(isStoredInMemoryOnly: true)
        )
        
        container.mainContext.insert(Task(text: "Unsalted butter"))
        container.mainContext.insert(Task(text: "Dark chocolate"))
        container.mainContext.insert(Task(text: "Eggs"))
        container.mainContext.insert(Task(text: "Caster sugar"))
        container.mainContext.insert(Task(text: "Cocoa powder"))
        container.mainContext.insert(Task(text: "All-purpose flour"))
        
        return container
    }
}

extension PreviewTrait where T == Preview.ViewTraits {
    static var mockData: Self = modifier(MockData())
}
