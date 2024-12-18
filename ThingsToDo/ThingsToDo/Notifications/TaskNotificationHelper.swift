//
//  TaskNotificationHelper.swift
//  ThingsToDo
//
//  Created by Martha Mendoza Alfaro on 18/12/24.
//
import Foundation
import UserNotifications

struct TaskNotificationHelper {
    static func updateNotifications(for tasks: [Task]) {
        // Clear old notifications
        UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: ["taskReminder"])

        // Filter tasks due today and not completed
        let today = Calendar.current.startOfDay(for: Date())
        let todayTasks = tasks.filter {
            Calendar.current.isDate($0.dueDate, inSameDayAs: today) && !$0.completed
        }

        guard !todayTasks.isEmpty else { return }

        let content = UNMutableNotificationContent()
        content.title = "Tasks for Today"
        content.body = "You have \(todayTasks.count) task(s) due today. Don't forget to check your list!"
        content.sound = .default

        var dateComponents = DateComponents()
        dateComponents.hour = 9 // 9 AM

        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: true)
        let request = UNNotificationRequest(identifier: "taskReminder", content: content, trigger: trigger)

        UNUserNotificationCenter.current().add(request) { error in
            if let error = error {
                print("Error scheduling task notification: \(error.localizedDescription)")
            }
        }
    }
}
