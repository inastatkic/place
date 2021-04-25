//
//  SwatchPicker.swift
//  APlace
//
//  Created by Ina Statkic on 4/12/21.
//

import SwiftUI
import RealityKit

struct SwatchPicker: View {
    @Binding var swatches: [String]
    @Binding var touchPoint: CGPoint
    @State private var swatch = ""
    @Binding var model: ModelEntity
    
    var body: some View {
        if swatches.count > 2 {
            ZStack {
                let number = swatches.count < 6 ? swatches.count - 1 : 5
                let angle = 2.0 / CGFloat(6) * .pi
                ForEach(Array(zip(swatches[0...number], swatches[0...number].indices)), id: \.0) { name, index in
                    SwatchView(name: name, swatch: $swatch)
                        .position(x: touchPoint.x + cos(angle * CGFloat(index)) * 40, y: touchPoint.y - sin(angle * CGFloat(index)) * 40)
                        .onTapGesture {
                            swatch = name
                            if let asset = Assets(rawValue: model.name) {
                                model.model?.materials = Assets(asset: asset).materials(swatch)
                            }
                        }
                }
            }
        }
        if swatches.count > 6 {
            ZStack {
                let number = swatches.count - 1
                let angle = 2.0 / CGFloat(8) * .pi
                ForEach(Array(zip(swatches[6...number], swatches[6...number].indices)), id: \.0) { name, index in
                    SwatchView(name: name, swatch: $swatch)
                        .position(x: touchPoint.x + cos(angle * CGFloat(index)) * 80, y: touchPoint.y - sin(angle * CGFloat(index)) * 80)
                        .onTapGesture {
                            swatch = name
                            if let asset = Assets(rawValue: model.name) {
                                model.model?.materials = Assets(asset: asset).materials(swatch)
                            }
                        }
                }
            }
        }
    }
}
