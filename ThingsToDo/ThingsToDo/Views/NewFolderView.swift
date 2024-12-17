//
//  NewFolderView.swift
//  ThingsToDo
//
//  Created by Martha Mendoza Alfaro on 16/12/24.
//

import SwiftUI
import SwiftData

struct NewFolderView: View {
    @Environment(\.sizeCategory) var sizeCategory
    @Environment(\.dismiss) private var dismiss
    @Environment(\.modelContext) private var modelContext
    
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
    
#Preview {
    NavigationStack {
        NewFolderView()
    }
}



struct IconPickerView: View {
    @Binding var selectedIcon: String
    
    let icons: [String] = ["star.fill", "heart.fill", "book.closed.fill", "folder.fill", "bag.fill", "moon.fill"]
    
    var body: some View {
        HStack(spacing: 0) {
            ForEach(icons, id: \.self) { icon in
                ZStack {
                    Circle()
                        .fill(selectedIcon == icon ? Color.gray.opacity(0.2) : Color.clear)
                        .frame(width: 55, height: 55)
                    
                    Image(systemName: icon)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 40, height: 40)
                        .foregroundColor(selectedIcon == icon ? .pink : .primary)
                }.onTapGesture {
                    selectedIcon = icon
                }
                
            }
        }
        .padding()
        .frame(maxWidth: .infinity, maxHeight: 100)
        .clipShape(RoundedRectangle(cornerRadius: 10.0, style: .continuous))
    }
}

struct IconPickerView_Previews: PreviewProvider {
    static var previews: some View {
        IconPickerView(selectedIcon: .constant("star.fill"))
    }
}



struct ColorPickerView: View {
    @Binding var selectedColorName: String
    
    let colors: [(name: String, color: Color)] = [
        ("red", .red), ("green", .green),
        ("yellow", .yellow), ("pink", .pink), ("blue", .blue), ("orange", .orange), ("teal", .teal)
    ]
    
    var body: some View {
        HStack {
            ForEach(colors, id: \.name) { colorItem in
                ZStack {
                    Circle()
                        //.fill()
                        .fill(colorItem.color)
                        //.foregroundColor(color)
                        .padding(2)
                    
                    if selectedColorName == colorItem.name {
                        Circle()
                            .strokeBorder(Color.gray, lineWidth: 3)
                            .frame(width: 45, height: 45)
                    }
                    /*Circle()
                        .strokeBorder(selectedColorName == colorItem ? .gray: .clear, lineWidth: 4)
                        .scaleEffect(CGSize(width: 1.2, height: 1.2))
                     */
                }.onTapGesture {
                    selectedColorName = colorItem.name
                }
                
            }
        }
        .padding()
        .frame(maxWidth: .infinity, maxHeight: 100)
        .clipShape(RoundedRectangle(cornerRadius: 10.0, style: .continuous))
    }
}

struct ColorPickerView_Previews: PreviewProvider {
    static var previews: some View {
        ColorPickerView(selectedColorName: .constant("blue"))
    }
}

