//
//  FolderRowView.swift
//  ThingsToDo
//
//  Created by Martha Mendoza Alfaro on 17/12/24.
//

import SwiftUI
import SwiftData


import SwiftUI

struct FolderRow: View {
    @Bindable var folder: Folder
    @State private var isExpanded = true
    var tasks: [Task] // Pass filtered tasks here
    
    @State private var isEditing = false // Local state for editing

    var body: some View {
        VStack(alignment: .leading) {
            // Folder Header
            HStack {
                Image(systemName: folder.icon)
                    .foregroundStyle(folder.color)
                    .font(.title2)
                    .onTapGesture {
                        //task.isEditing = true
                        isEditing = true
                    }
                    .accessibilityLabel("\(folder.name) icon")
                    .accessibilityHint("Tap to edit")

                Text(folder.name)
                    .font(.title3)
                    .fontWeight(.semibold)
                    .onTapGesture {
                        //task.isEditing = true
                        isEditing = true
                    }
                    .accessibilityHint("Tap to edit")

                Spacer()

                Button(action: {
                    withAnimation {
                        isExpanded.toggle()
                    }
                }) {
                    Image(systemName: isExpanded ? "chevron.down" : "chevron.right")
                        .font(.subheadline)
                        .foregroundStyle(.gray)
                }
                .contentTransition(.symbolEffect(.replace))
            }
            .padding(.top,10)
            .padding(.bottom,10)
            .sheet(isPresented: $isEditing) {
                EditFolderView(folder: folder) // Pass the folder to edit
            }

            // Task List
            if isExpanded {
                ForEach(tasks) { task in
                    RowTaskView(task: task)
                }
                //.onDelete(perform: deleteTasks)
                /*.onDelete { offsets in
                    deleteTasks(at: offsets)
                }*/
            }
        }
    }

    private func deleteTasks(at offsets: IndexSet) {
        for index in offsets {
            folder.tasks.remove(at: index)
        }
    }
}






/*
struct FolderRow: View {
    @Bindable var folder: Folder
    @State private var isExpanded = true // Tracks expand/collapse state
    @State private var taskRefreshID = UUID()

    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                Image(systemName: folder.icon)
                    .foregroundStyle(folder.color)
                    .font(.title2)
                
                Text(folder.name)
                    .font(.title3)
                    .fontWeight(.semibold)
                
                Spacer()

                Button(action: {
                    withAnimation {
                        isExpanded.toggle()
                    }
                }) {
                    Image(systemName: isExpanded ? "chevron.down" : "chevron.right")
                        .font(.subheadline)
                        .foregroundStyle(.gray)
                        .contentShape(Rectangle()) // Restrict tap to button only
                        .buttonStyle(BorderlessButtonStyle())
                }
                .contentTransition(.symbolEffect(.replace))
            }
            //.contentShape(Rectangle())
            //.padding(.vertical, 5)
            
            if isExpanded {
                //List {
                    ForEach(folder.tasks,  id: \.self) { task in
                        RowTaskView(task: task)
                        //.padding(.leading, 30) // Indent tasks under the folder
                    }
                    .onDelete(perform: deleteTasks)
                    .id(taskRefreshID)
                
                //}
                //.listStyle(PlainListStyle())
                //.frame(width: .infinity, height: .infinity)
                //.padding(.top, 5)
            }
        }
        .onChange(of: folder.tasks.count) { _ in
            taskRefreshID = UUID() // Change the ID to force the list to refresh
        }
    }
    
    // Delete tasks from the folder
    private func deleteTasks(at offsets: IndexSet) {
        for index in offsets {
            folder.tasks.remove(at: index)
        }
    }
    
}


*/
/*
struct FolderListView: View {
    @Environment(\.modelContext) var modelContext
    @Query private var folders: [Folder]

    var body: some View {
        List(folders) { folder in
            FolderRow(folder: folder)
                //.listRowBackground(Color(UIColor.systemGray6)) // Keep gray background
                //.foregroundStyle(Color.primary) // Ensure text has no white outline
        }
        .buttonStyle(BorderlessButtonStyle())
        //.scrollContentBackground(.hidden) // Hide white content background
        //.background(Color(UIColor.systemGray6)) // Set overall background to gray
        .navigationTitle("Folders")
    }
    
    
    
    
}

*/
 

/*#Preview(traits: .mockData) {
    FolderListView()
}


*/
/*
struct FolderListView: View {
    
    @Environment(\.modelContext) var modelContext
    
    @Query private var folders: [Folder]
    
    
    var body: some View {
        List(folders) { folder in
            FolderRow(folder: folder)
        }
        .navigationTitle("Folders")
        //.scrollContentBackground(.hidden)
        //.background(Color.clear)
    }
}
*/



