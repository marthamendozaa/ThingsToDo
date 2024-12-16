//
//  Untitled.swift
//  ThingsToDo
//
//  Created by Martha Mendoza Alfaro on 16/12/24.
//

import SwiftUI

struct Bruh: View {
    @Environment(\.sizeCategory) var sizeCategory

    var body: some View {
        VStack {
            Text("Dynamic Example")
                .font(.headline)
            Image(systemName: "star.fill")
                .resizable()
                .scaledToFit()
                .frame(width: dynamicImageSize(), height: dynamicImageSize())
        }
    }
    
    func dynamicImageSize() -> CGFloat {
        switch sizeCategory {
        case .extraSmall: return 20
        case .small: return 25
        case .medium: return 30
        case .large: return 35
        case .extraLarge: return 40
        default: return 45
        }
    }
}


#Preview {
    Bruh()
}
