//
//  ContextSuggestion.swift
//  APlace
//
//  Created by Ina Statkic on 5/7/21.
//

import SwiftUI

struct ContextSuggestion: View {
    @Binding var surfaceClassification: SurfaceClassification
    
    var body: some View {
        Text(surfaceClassification.mesh.suggestion)
            .textCase(.uppercase)
            .position(surfaceClassification.point)
            .foregroundColor(.white)
            .padding()
            .contextMenu {
                switch surfaceClassification.mesh {
                case .window:
                    Group {
                        Button { naturalLight() } label: {
                            Text("Natural light")
                        }
                        Button { visualLinks() } label: {
                            Text("Visualy link with the outside")
                        }
                    }
                case .none: Group {}
                case .wall: Group {}
                case .floor: Group {}
                case .ceiling: Group {}
                case .table: Group {}
                case .seat: Group {}
                case .door: Group {}
                @unknown default: Group {}
                }
            }
    }
    
    // MARK: - Actions
    
    func naturalLight() { }
    func visualLinks() { }
}
