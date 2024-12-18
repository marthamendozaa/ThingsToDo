//
//  ThingsToDoWidgetLiveActivity.swift
//  ThingsToDoWidget
//
//  Created by Martha Mendoza Alfaro on 18/12/24.
//

import ActivityKit
import WidgetKit
import SwiftUI

struct ThingsToDoWidgetAttributes: ActivityAttributes {
    public struct ContentState: Codable, Hashable {
        // Dynamic stateful properties about your activity go here!
        var emoji: String
        // Task progress details
        //var completedTasks: Int
        //var totalTasks: Int
    }

    // Fixed non-changing properties about your activity go here!
    var name: String
}

struct ThingsToDoWidgetLiveActivity: Widget {
    var body: some WidgetConfiguration {
        ActivityConfiguration(for: ThingsToDoWidgetAttributes.self) { context in
            // Lock screen/banner UI goes here
            VStack {
                Text("Hello \(context.state.emoji)")
            }
            .activityBackgroundTint(Color.cyan)
            .activitySystemActionForegroundColor(Color.black)

        } dynamicIsland: { context in
            DynamicIsland {
                // Expanded UI goes here.  Compose the expanded UI through
                // various regions, like leading/trailing/center/bottom
                DynamicIslandExpandedRegion(.leading) {
                    Text("Leading")
                }
                DynamicIslandExpandedRegion(.trailing) {
                    Text("Trailing")
                }
                DynamicIslandExpandedRegion(.bottom) {
                    Text("Bottom \(context.state.emoji)")
                    // more content
                }
            } compactLeading: {
                Text("L")
            } compactTrailing: {
                Text("T \(context.state.emoji)")
            } minimal: {
                Text(context.state.emoji)
            }
            .widgetURL(URL(string: "http://www.apple.com"))
            .keylineTint(Color.red)
        }
    }
}

extension ThingsToDoWidgetAttributes {
    fileprivate static var preview: ThingsToDoWidgetAttributes {
        ThingsToDoWidgetAttributes(name: "World")
    }
}

extension ThingsToDoWidgetAttributes.ContentState {
    fileprivate static var smiley: ThingsToDoWidgetAttributes.ContentState {
        ThingsToDoWidgetAttributes.ContentState(emoji: "😀")
     }
     
     fileprivate static var starEyes: ThingsToDoWidgetAttributes.ContentState {
         ThingsToDoWidgetAttributes.ContentState(emoji: "🤩")
     }
}

#Preview("Notification", as: .content, using: ThingsToDoWidgetAttributes.preview) {
   ThingsToDoWidgetLiveActivity()
} contentStates: {
    ThingsToDoWidgetAttributes.ContentState.smiley
    ThingsToDoWidgetAttributes.ContentState.starEyes
}
