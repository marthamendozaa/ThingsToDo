//
//  CalendarView.swift
//  ThingsToDo
//
//  Created by Martha Mendoza Alfaro on 10/12/24.
//

/*
struct CalendarView: View {
    var body: some View {
        Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
    }
}*/

#Preview {
    CalendarView()
}


import SwiftUI
import UIKit
import SwiftData

struct CalendarView: View {
    @Environment(\.modelContext) private var modelContext
    @Query(sort: \Task.dueDate) private var tasks: [Task]
    
    @State private var selectedDate: Date? = .now
    @State private var tasksForSelectedDate: [Task] = []
    
    var body: some View {
        VStack {
            // UICalendarView
            CalendarUIKitView(selectedDate: $selectedDate)
                .frame(height: 300)
            
            // Display tasks for selected date
            if let selectedDate = selectedDate {
                List {
                    
                    ForEach(tasksForSelectedDate) { task in
                        
                        RowTaskView(task: task)
                        
                    }
                    .onDelete(perform: deleteTasks)
                }
                .navigationTitle("Tasks for \(formattedDate(selectedDate))")
                .onAppear {
                    updateTasksForSelectedDate()
                }

            } else {
                Text("Select a date to see tasks.")
                    .font(.headline)
                    .padding()
            }
        }
        .onChange(of: selectedDate) { oldDate, newDate in
            if oldDate != newDate {
                updateTasksForSelectedDate()
            }
        }
        
    }
    
    // Update tasks for the selected date
    private func updateTasksForSelectedDate() {
        guard let selectedDate = selectedDate else {
            tasksForSelectedDate = []
            return
        }
        let calendar = Calendar.current
        tasksForSelectedDate = tasks.filter {
            calendar.isDate($0.dueDate, inSameDayAs: selectedDate)
        }
    }
    
    // Format date
    private func formattedDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        return formatter.string(from: date)
    }
    
    
    func deleteTasks(_ indexSet: IndexSet) {
        for index in indexSet {
            let taskToDelete = tasksForSelectedDate[index]
            // Update the main tasks array by deleting from SwiftData
            modelContext.delete(taskToDelete)
        }
        
        // Re-fetch tasks for the selected date to ensure the UI is in sync
        updateTasksForSelectedDate()
    }

}

// UIViewRepresentable for UICalendarView
struct CalendarUIKitView: UIViewRepresentable {
    @Binding var selectedDate: Date?
    
    func makeUIView(context: Context) -> UICalendarView {
        let calendarView = UICalendarView()
        calendarView.delegate = context.coordinator
        calendarView.selectionBehavior = UICalendarSelectionSingleDate(delegate: context.coordinator)
        return calendarView
    }
    
    func updateUIView(_ uiView: UICalendarView, context: Context) {
        // No need to update UICalendarView dynamically in this case
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    class Coordinator: NSObject, UICalendarViewDelegate, UICalendarSelectionSingleDateDelegate {
        var parent: CalendarUIKitView
        
        init(_ parent: CalendarUIKitView) {
            self.parent = parent
        }
        
        func dateSelection(_ selection: UICalendarSelectionSingleDate, didSelectDate dateComponents: DateComponents?) {
            if let date = dateComponents?.date {
                DispatchQueue.main.async {
                    self.parent.selectedDate = date
                }
            }
        }
    }
}
