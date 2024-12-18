//
//  LogView.swift
//  ThingsToDo
//
//  Created by Martha Mendoza Alfaro on 10/12/24.
//

import SwiftUI
import SwiftData

struct LogView: View {
    @Environment(\.modelContext) private var modelContext
    @Query(sort: \Log.date, order: .reverse) private var logs: [Log] // Fetch logs in reverse chronological order

    @State private var showingLogSheet = false
    @State private var isEditing = false // Local state for editing
    
    @State private var selectedLog: Log?

    var body: some View {
        NavigationStack {
            List {
                ForEach(logs) { log in
                    VStack(alignment: .leading) {
                        Text("Log for \(formattedDate(log.date))")
                            .font(.title3)
                            .fontWeight(.semibold)
                            .onTapGesture {
                                //task.isEditing = true
                                isEditing = true
                                selectedLog = log
                            }
                            .accessibilityHint("Double-tap to edit")
                        HStack {
                            Image(systemName: log.completedTasks > 0 ? "checklist" : "checklist.unchecked")

                            Text("\(log.completedTasks) completed tasks!")
                                .font(.headline)
                        }
                        
                        if !log.reflection.isEmpty {
                            Text("🌱 \(log.reflection)")
                                .font(.body)
                                .foregroundColor(.secondary)
                        }
                        
                        if !log.gratitude.isEmpty {
                            Text("⭐️ \(log.gratitude)")
                                .font(.body)
                                .foregroundColor(.secondary)
                        }
                    }
                    .padding(.vertical, 5)
                    
                }
            }
            .navigationTitle("Logs")
            .toolbar {
                ToolbarItem(placement: .primaryAction) {
                    Button(action: {
                        showingLogSheet.toggle()
                    }) {
                        Label("Create Log", systemImage: "plus")
                            .labelStyle(.titleAndIcon)
                    }
                }
            }
            .sheet(isPresented: $showingLogSheet) {
                NewLogView()
            }
            .sheet(item: $selectedLog) { log in
                EditLogView(log: log)
            }

            /*.sheet(isPresented: $isEditing) {
                EditLogView(log: log) // Pass the task to edit
            }*/
        }
    }

    private func formattedDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        return formatter.string(from: date)
    }
}

#Preview {
    LogView()
}

