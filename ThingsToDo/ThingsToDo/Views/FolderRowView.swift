//
//  FolderRowView.swift
//  ThingsToDo
//
//  Created by Martha Mendoza Alfaro on 17/12/24.
//

import SwiftUI
import SwiftData

struct FolderRow: View {
    var folder: Folder
    
    var body: some View {
        HStack {
            Image(systemName: folder.icon)
                .foregroundStyle(folder.color) // Use the dynamic color
                .frame(width: 40, height: 40)
                .padding()
            
            Text(folder.name)
                .font(.headline)
        }
    }
}


struct FolderListView: View {
    @State private var folders: [Folder] = [
        Folder(name: "Work", colorName: "red", icon: "briefcase.fill"),
        Folder(name: "Personal", colorName: "green", icon: "person.fill"),
        Folder(name: "Ideas", colorName: "purple", icon: "lightbulb.fill")
    ]
    
    var body: some View {
        List(folders) { folder in
            FolderRow(folder: folder)
        }
        .navigationTitle("Folders")
    }
}

#Preview {
    FolderListView()
}
