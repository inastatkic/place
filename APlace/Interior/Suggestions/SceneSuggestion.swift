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
        ZStack {
            if ceilingHeight > 0 {
                Text(ceilingHeight.meter() + " ceiling height")
                    .foregroundColor(.white)
                    .padding(10)
                    .background(VisualEffect(style: .systemUltraThinMaterialDark))
                    .cornerRadius(10)
                    .position(x: 100, y: 40)
                Group {
                    if ceilingHeight < 2.4 {
//                        Text("Ceiling look higher when painted white.")
                        Text("Low, horizontal furniture make ceiling look higher")
                            .lineLimit(2)
                            .padding(.horizontal, 65)
                    } else if ceilingHeight > 2.4 && ceilingHeight <= 3.0 {
                        Text("Generous height.")
                    } else if ceilingHeight > 3.0 {
                        Text("To make ceiling lower paint with darker colours.")
                    }
                }.foregroundColor(.white)
            } else {
                Text("")
            }
        }
    }
}

