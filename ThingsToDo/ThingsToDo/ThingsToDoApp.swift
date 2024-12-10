//
//  ThingsToDoApp.swift
//  ThingsToDo
//
//  Created by Martha Mendoza Alfaro on 10/12/24.
//

import SwiftUI
import SwiftData

@main
struct ThingsToDoApp: App {
    var body: some Scene {
        WindowGroup {
            TabView {
                Tab("Today", systemImage: "checklist") {
                    ContentView()
                }
                
                Tab("Calendar", systemImage: "calendar") {
                    CalendarView()
                }
                
                Tab("Log", systemImage: "text.book.closed.fill") {
                    LogView()
                }
            }
        }
        .modelContainer(for: Task.self)
        // 3 - View modifier to our window view when the app launches from 1 to 3 it gives us a complete swift data stack
        // create the storage for the destination object. use that storage for all the data inside the windowgroup
    }
}
