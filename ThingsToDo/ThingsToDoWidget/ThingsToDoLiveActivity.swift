//
//  ThingsToDoWidgetLiveActivity.swift
//  ThingsToDoWidget
//
//  Created by Martha Mendoza Alfaro on 18/12/24.
//

import ActivityKit
import WidgetKit
import SwiftUI

import ActivityKit
import SwiftUI
import WidgetKit

struct ThingsToDoLiveActivity: Widget {
    var body: some WidgetConfiguration {
        ActivityConfiguration(for: ThingsToDoAttributes.self) { context in
            VStack {
                Text("Tasks Progress")
                    .font(.headline)

                HStack {
                    Text("\(context.state.completedTasks)/\(context.state.totalTasks)")
                        .font(.largeTitle)
                        .fontWeight(.bold)

                    ProgressView(value: Double(context.state.completedTasks), total: Double(context.state.totalTasks))
                        .progressViewStyle(CircularProgressViewStyle(tint: .green))
                        .frame(width: 50, height: 50)
                }

                if context.state.completedTasks == context.state.totalTasks {
                    Text("All tasks completed! 🎉")
                        .font(.subheadline)
                        .foregroundColor(.green)
                } else {
                    Text("Keep going!")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
            }
            .padding()
        } dynamicIsland: { context in
            DynamicIsland {
                DynamicIslandExpandedRegion(.center) {
                    Text("Completed: \(context.state.completedTasks)/\(context.state.totalTasks)")
                        .font(.headline)
                }
                DynamicIslandExpandedRegion(.bottom) {
                    ProgressView(value: Double(context.state.completedTasks), total: Double(context.state.totalTasks))
                        .progressViewStyle(LinearProgressViewStyle())
                }
            } compactLeading: {
                Text("\(context.state.completedTasks)")
            } compactTrailing: {
                Text("\(context.state.totalTasks)")
            } minimal: {
                Text("\(context.state.completedTasks)/\(context.state.totalTasks)")
            }
        }
    }
}


import ActivityKit

struct ThingsToDoAttributes: ActivityAttributes {
    public struct ContentState: Codable, Hashable {
        var completedTasks: Int
        var totalTasks: Int
    }

    var name: String
}



import ActivityKit

func startTaskLiveActivity(completed: Int, total: Int) {
    let initialState = ThingsToDoAttributes.ContentState(completedTasks: completed, totalTasks: total)
    let attributes = ThingsToDoAttributes(name: "Task Progress")

    do {
        let activity = try Activity<ThingsToDoAttributes>.request(
            attributes: attributes,
            contentState: initialState,
            pushType: nil // For real-time updates, you can use a push token
        )
        print("Started Live Activity: \(activity.id)")
    } catch {
        print("Failed to start Live Activity: \(error.localizedDescription)")
    }
}


func endTaskLiveActivity() {
    for activity in Activity<ThingsToDoAttributes>.activities {
        Task {
            await activity.end(dismissalPolicy: .immediate)
        }
    }
}


func updateTaskLiveActivity(completed: Int, total: Int) {
    let updatedState = ThingsToDoAttributes.ContentState(completedTasks: completed, totalTasks: total)
    for activity in Activity<ThingsToDoAttributes>.activities {
        Task {
            await activity.update(using: updatedState)
        }
    }
}
