//
//  ThingsToDoApp.swift
//  ThingsToDo
//
//  Created by Martha Mendoza Alfaro on 10/12/24.
//

import SwiftUI
import SwiftData
import UserNotifications

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
            .onAppear {
                requestNotificationPermission()
            }
        }
        .modelContainer(for: [Task.self, Log.self])
    }

    private func requestNotificationPermission() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { granted, error in
            if let error = error {
                print("Notification permission error: \(error.localizedDescription)")
            } else {
                print("Notification permission granted: \(granted)")
                if granted {
                    scheduleLogReminder()
                } else {
                    print("User denied notifications.")
                }
            }
        }
    }

    private func scheduleLogReminder() {
        let content = UNMutableNotificationContent()
        content.title = "Daily Log Reminder"
        content.body = "Don't forget to log your day and track your progress!"
        content.sound = UNNotificationSound.default

        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 10, repeats: false)
        let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)

        UNUserNotificationCenter.current().add(request) { error in
            if let error = error {
                print("Error adding notification: \(error.localizedDescription)")
            } else {
                print("Notification added successfully.")
                listPendingNotifications() // Debug: List all pending notifications
            }
        }
    }

    private func listPendingNotifications() {
        UNUserNotificationCenter.current().getPendingNotificationRequests { requests in
            for request in requests {
                print("Pending Notification: \(request.identifier), Trigger: \(String(describing: request.trigger))")
            }
        }
    }
}


/*
@main
struct ThingsToDoApp: App {
    
    @Environment(\.scenePhase) private var scenePhase
    
    var body: some Scene {
        WindowGroup {
            TabView {
                Tab("Today", systemImage: "checklist") {
                    ContentView()
                       // .modelContainer(for: Task.self)
                }
                
                Tab("Calendar", systemImage: "calendar") {
                    CalendarView()
                }
                
                Tab("Log", systemImage: "text.book.closed.fill") {
                    //LogView()
                    LogView()
                }
            }
            .onAppear {
                requestNotificationPermission()
               // scheduleLogReminder() // Schedule the daily log reminder
            }
        }
        .modelContainer(for: [Task.self, Log.self])
        // 3 - View modifier to our window view when the app launches from 1 to 3 it gives us a complete swift data stack
        // create the storage for the destination object. use that storage for all the data inside the windowgroup
    }
    
    
    // Request notification permissions
    private func requestNotificationPermission() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { granted, error in
            if let error = error {
                print("Notification permission error: \(error.localizedDescription)")
            } else {
                print("Notification permission granted: \(granted)")
                scheduleLogReminder() // Schedule the daily log reminder
            }
        }
    }

    // Schedule a daily log reminder notification
    private func scheduleLogReminder() {
        let content = UNMutableNotificationContent()
        content.title = "Daily Log Reminder"
        content.body = "Don't forget to log your day and track your progress!"
        content.sound = UNNotificationSound.default

        // Schedule the notification for 8 PM daily
        /*var dateComponents = DateComponents()
        dateComponents.hour = Calendar.current.component(.hour, from: Date())
        dateComponents.minute = Calendar.current.component(.minute, from: Date()) + 1*/
        //dateComponents.hour = 20 // 8 PM

       // let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: true)
        //let request = UNNotificationRequest(identifier: "logReminder", content: content, trigger: trigger)
        
        
        // show this notification five seconds from now
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 5, repeats: false)

        // choose a random identifier
        let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)

        UNUserNotificationCenter.current().add(request)
        
        /*{ error in
            if let error = error {
                print("Error scheduling log reminder: \(error.localizedDescription)")
            } else {
                print("Log reminder notification scheduled.")
            }
        }*/
    }
}





*/
