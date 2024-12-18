//
//  NewFolderView.swift
//  ThingsToDo
//
//  Created by Martha Mendoza Alfaro on 16/12/24.
//

import SwiftUI
import SwiftData



struct EditFolderView: View {
    @Environment(\.sizeCategory) var sizeCategory
    @Environment(\.dismiss) private var dismiss
    @Environment(\.modelContext) private var modelContext
    
    @Bindable var folder: Folder // Directly bind the folder properties

    var body: some View {
        NavigationView {
            Form {
                // Folder Name
                Section {
                    TextField("Folder Name", text: $folder.name)
                        .font(.title)
                        .accessibilityLabel("\(folder.name)")
                        .accessibilityHint("Enter the name for the new folder")
                }
                
                // Folder Preview
                Section {
                    VStack {
                        Image(systemName: folder.icon)
                            .resizable()
                            .foregroundStyle(Folder.colorMap[folder.colorName] ?? .pink)
                            .scaledToFit()
                            .frame(width: dynamicImageSize(), height: dynamicImageSize())
                            .accessibilityLabel("Folder icon \(folder.icon) color \(folder.colorName)")
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
                }
                
                // Color Picker
                Section(header: Text("Choose a Color")) {
                    ColorPickerView(selectedColorName: $folder.colorName)
                }
                
                // Icon Picker
                Section(header: Text("Choose an Icon")) {
                    IconPickerView(selectedIcon: $folder.icon)
                }
            }
            .navigationTitle("Edit Folder")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                // Cancel Button
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        dismiss()
                    }
                    .foregroundColor(.pink)
                }
                
                // Save Button
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Save") {
                        dismiss()
                    }
                    .disabled(folder.name.isEmpty)
                    .foregroundColor(.pink)
                }
                
                ToolbarItem(placement: .bottomBar) {
                    Button(role: .destructive, action: deleteFolder) {
                        Label("Delete Folder", systemImage: "trash")
                            .foregroundColor(.red)
                    }
                    .frame(maxWidth: .infinity, alignment: .center)
                }
            }
        }
    }
    
    private func deleteFolder() {
        modelContext.delete(folder) // Automatically deletes tasks due to cascade
        dismiss()
    }
    
    func dynamicImageSize() -> CGFloat {
        switch sizeCategory {
        case .extraSmall: return 45
        case .small: return 50
        case .medium: return 55
        case .large: return 60
        case .extraLarge: return 65
        case .extraExtraLarge: return 70
        case .extraExtraExtraLarge: return 75
        case .accessibilityMedium: return 80
        case .accessibilityLarge: return 85
        case .accessibilityExtraLarge: return 90
        case .accessibilityExtraExtraLarge: return 95
        case .accessibilityExtraExtraExtraLarge: return 100
        default: return 55
        }
    }
}


/*
struct EditFolderView: View {
    @Environment(\.sizeCategory) var sizeCategory
    @Environment(\.dismiss) private var dismiss
    @Environment(\.modelContext) private var modelContext
    
    @Bindable var folder: Task // Bind the task to edit
    
    @State private var folderName: String = ""
    @State private var selectedColorName: String = "pink" // Default color
    @State private var icon: String = "star.fill"
    
    var body: some View {
        NavigationView {
            Form {
                
                TextField("Folder Name", text: $folderName)
                    .font(.title)
                
                Section {
                    VStack {
                        Image(systemName: icon)
                            .resizable()
                            .foregroundStyle(Folder.colorMap[selectedColorName] ?? .pink)
                            .scaledToFit()
                            .frame(width: dynamicImageSize(), height: dynamicImageSize())
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
                }
                    
                ColorPickerView(selectedColorName: $selectedColorName)
                    
                IconPickerView(selectedIcon: $icon)
                    
                //TextField("Folder Name", text: $folderName)
                
            }
            .navigationTitle("New Folder")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
                
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Create") {
                        let newFolder = Folder(name: folderName, colorName: selectedColorName, icon: icon)
                        modelContext.insert(newFolder)
                        dismiss()
                    }
                    .disabled(folderName.isEmpty)
                }
            }
        }
    }
    
    
    func dynamicImageSize() -> CGFloat {
            switch sizeCategory {
            case .extraSmall: return 45
            case .small: return 50
            case .medium: return 55
            case .large: return 60
            case .extraLarge: return 65
            case .extraExtraLarge: return 70
            case .extraExtraExtraLarge: return 75
            case .accessibilityMedium: return 80
            case .accessibilityLarge: return 85
            case .accessibilityExtraLarge: return 90
            case .accessibilityExtraExtraLarge: return 95
            case .accessibilityExtraExtraExtraLarge: return 100
                
            default: return 55
            }
    }
}
    

*/

/*#Preview {
    NavigationStack {
        EditFolderView()
    }
}
*/


