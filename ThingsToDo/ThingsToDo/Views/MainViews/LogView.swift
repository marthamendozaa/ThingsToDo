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

    var body: some View {
        NavigationStack {
            List {
                ForEach(logs) { log in
                    VStack(alignment: .leading) {
                        Text("Date: \(formattedDate(log.date))")
                            .font(.headline)
                        Text("Tasks Completed: \(log.completedTasks)")
                            .font(.subheadline)
                        
                        if !log.reflection.isEmpty {
                            Text("Reflection: \(log.reflection)")
                                .font(.body)
                                .foregroundColor(.secondary)
                        }
                        
                        if !log.gratitude.isEmpty {
                            Text("Gratitude: \(log.gratitude)")
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

