//
//  CalendarView.swift
//  ThingsToDo
//
//  Created by Martha Mendoza Alfaro on 10/12/24.
//

#Preview(traits: .mockData) {
    CalendarView()
}

import SwiftUI
import SwiftData

struct CalendarView: View {
    @Environment(\.modelContext) private var modelContext
    @Query(sort: \Folder.name) private var folders: [Folder]
    
    @State private var selectedDate: Date? = .now
    
    @State private var showingFolderSheet = false
    @State private var showingTaskSheet = false

    var body: some View {
        NavigationView {

            VStack(spacing: 0) {
                // Calendar
                CalendarUIKitView(selectedDate: $selectedDate)
                    .padding(.horizontal)
                
                // List of Folders with Tasks for Selected Date
                if let selectedDate = selectedDate {
                    List {
                        ForEach(folders) { folder in
                            let tasksForDate = tasksForSelectedDate(in: folder, on: selectedDate)
                            if !tasksForDate.isEmpty {
                                FolderRow(folder: folder, tasks: tasksForDate)
                                    .listRowBackground(Color(UIColor.systemGray6)) // Keep gray background
                                    .foregroundStyle(Color.primary) // Ensure text has no white outline
                            }
                        }
                    }
                    .listStyle(.plain)
                    .buttonStyle(BorderlessButtonStyle())
                    .scrollContentBackground(.hidden)
                    //.navigationTitle("Calendar")
                } else {
                    Text("Select a date to see tasks.")
                }
            }
            .navigationTitle("Calendar")
            //.navigationBarTitleDisplayMode(.inline)
            .toolbar {
                // 12 - add new button destination
                ToolbarItem(placement: .primaryAction) {
                    Button(action: {
                        showingTaskSheet.toggle()
                    }) {
                        
                        Label("Add task", systemImage: "plus")
                            .labelStyle(.titleAndIcon)
                        //Image(systemName: "plus")
                        //Text("Add task")
                    }
                }
                
                
                ToolbarItem() {
                    Button(action: {
                        showingFolderSheet.toggle()
                    }) {
                        Label("Create folder", systemImage: "folder.badge.plus")
                            .labelStyle(.titleAndIcon)
                        //Image(systemName: "plus")
                        //Text("Add task")
                    }
                }
            }
            .sheet(isPresented: $showingTaskSheet) {
                NewTaskView()
            }
            .sheet(isPresented: $showingFolderSheet) {
                NewFolderView()
            }
            
        }
        
    }

    // Filter tasks for the selected date
    private func tasksForSelectedDate(in folder: Folder, on date: Date) -> [Task] {
        let calendar = Calendar.current
        return folder.tasks.filter { task in
            calendar.isDate(task.dueDate, inSameDayAs: date)
        }
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

    func updateUIView(_ uiView: UICalendarView, context: Context) { }

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


