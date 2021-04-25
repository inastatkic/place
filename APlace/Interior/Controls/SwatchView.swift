//
//  Swatch.swift
//  APlace
//
//  Created by Ina Statkic on 4/11/21.
//

import SwiftUI

struct SwatchView: View {
    var name: String
    @Binding var swatch: String
    var isSelected: Bool {
        swatch == name
    }
    
    var body: some View {
        // TODO: Generalize
        if name[..<name.firstIndex(of: ".")!] == "fiberglass" {
            Image(name)
                .resizable()
                .frame(width: 28, height: 28)
                .clipShape(Circle())
        } else {
            Circle()
                .frame(width: 28, height: 28)
                .foregroundColor(Color(name))
        }
        if isSelected {
            Circle()
                .strokeBorder(Color(.white), lineWidth: 3, antialiased: true)
                .frame(width: 31, height: 31)
        }
    }
}
