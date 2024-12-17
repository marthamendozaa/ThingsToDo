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
    @State private var color: Color = .blue
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
                            .foregroundStyle(color)
                            .scaledToFit()
                            .frame(width: dynamicImageSize(), height: dynamicImageSize())
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
                }
                    
                ColorPickerView(selectedColor: $color)
                    
                IconPickerView(selectedIcon: $icon)
                    
                //TextField("Folder Name", text: $folderName)
                
                Section {
                    Button("Create Folder") {
                        let newFolder = Folder(name: folderName, colorName: "blue", icon: icon)
                        modelContext.insert(newFolder)
                        dismiss()
                    }
                    .disabled(folderName.isEmpty)
                }
            }
            .navigationTitle("New Folder")
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        dismiss()
                    }
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
    
    let icons: [String] = ["star.fill", "heart.fill", "leaf.fill", "bolt.fill", "flame.fill", "moon.fill"]
    
    var body: some View {
        HStack {
            ForEach(icons, id: \.self) { icon in
                ZStack {
                    Circle()
                        .fill(selectedIcon == icon ? Color.gray.opacity(0.2) : Color.clear)
                        .padding(2)
                    Image(systemName: icon)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 40, height: 40)
                        .foregroundColor(selectedIcon == icon ? .blue : .primary)
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
    @Binding var selectedColor: Color
    
    let colors: [Color] = [.red, .blue, .green, .yellow, .pink, .purple]
    
    var body: some View {
        HStack {
            ForEach(colors, id: \.self) { color in
                ZStack {
                    Circle().fill()
                        .foregroundColor(color)
                        .padding(2)
                    Circle()
                        .strokeBorder(selectedColor == color ? .gray: .clear, lineWidth: 4)
                        .scaleEffect(CGSize(width: 1.2, height: 1.2))
                }.onTapGesture {
                    selectedColor = color
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
        ColorPickerView(selectedColor: .constant(.yellow))
    }
}

