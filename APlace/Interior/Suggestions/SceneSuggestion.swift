//
//  SceneSuggestion.swift
//  APlace
//
//  Created by Ina Statkic on 5/25/21.
//

import SwiftUI

struct SceneSuggestion: View {
    @Binding var ceilingHeight: Float
    
    var body: some View {
        if ceilingHeight > 0 {
            Group {
                if ceilingHeight < 2.4 {
                    Text(ceilingHeight.meter() + " ceiling height")
                    Text("Make ceiling higher painting it white")
                } else if ceilingHeight > 2.4 && ceilingHeight <= 3.0 {
                    Text("Generous height.")
                } else if ceilingHeight > 3.0 {
                    Text("""
                        Luxurious height.
                        To make ceiling lower paint with darker colours.
                        """)
                }
            }
            .foregroundColor(.white)
            .padding(10)
            .background(VisualEffect(style: .systemUltraThinMaterialDark))
            .cornerRadius(10)
            .position(x: 100, y: 40)
        } else {
            Text("")
        }
    }
}

