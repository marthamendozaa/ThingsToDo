//
//  EditLogView.swift
//  ThingsToDo
//
//  Created by Martha Mendoza Alfaro on 18/12/24.
//

import SwiftUI
import SwiftData

struct EditLogView: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(\.modelContext) private var modelContext
    @Query(sort: \Task.dueDate) private var tasks: [Task] // Fetch tasks

    @Bindable var log: Log
    @State private var completedTaskCount = 0 // Dynamically calculated

    var body: some View {
        NavigationView {
            
            Form {
                Section{
                    if completedTaskCount == 0 {
                        
                        HStack(spacing: 20)  {
                            Image(systemName: "checklist.unchecked")
                                .imageScale(.large)
                            
                            Text("You didn't complete any tasks today. Let's hope for tomorrow!")
                                .font(.headline)
                                .fontWeight(.semibold)
                        }

                    } else {
                        Image(systemName: "checklist")
                            .imageScale(.large)
                        
                        Text("You completed \(completedTaskCount) tasks today. Good job!")
                            .font(.headline)
                            .fontWeight(.semibold)
                    }
                }
                
                Section(header: Text("Reflection")) {
                    TextField("What did you do today?", text: $log.reflection)

                }
                
                Section(header: Text("Gratitude")) {
                    TextField("What are you grateful for today?", text: $log.gratitude)
                }
                
            }
            .navigationTitle("Edit Log")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        dismiss()
                    }
                    .foregroundColor(.pink)
                }
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Save") {
                        dismiss()
                    }
                    .disabled(log.reflection.isEmpty)
                    .disabled(log.gratitude.isEmpty)
                    .foregroundColor(.pink)
                }
                
                ToolbarItem(placement: .bottomBar) {
                    Button(role: .destructive, action: deleteLog) {
                        Label("Delete Log", systemImage: "trash")
                            .foregroundColor(.red)
                    }
                }
            }
            .onAppear {
                calculateCompletedTasks()
            }
        }
    }

    private func calculateCompletedTasks() {
        let today = Calendar.current.startOfDay(for: Date())
        completedTaskCount = tasks.filter {
            $0.completed && Calendar.current.isDate($0.dueDate, inSameDayAs: today)
        }.count
    }

    private func deleteLog() {
        modelContext.delete(log)
        dismiss()
    }
}

/*
#Preview {
    EditLogView()
}
*/
