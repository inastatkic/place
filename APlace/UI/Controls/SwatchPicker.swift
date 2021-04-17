//
//  SwatchPicker.swift
//  APlace
//
//  Created by Ina Statkic on 4/12/21.
//

import SwiftUI
import RealityKit

struct SwatchPicker: View {
    var swatches = VitraColour.allCases.map { "vitra.\($0.rawValue)" }
    @Binding var touchPoint: CGPoint
    @State private var swatch = ""
    @Binding var virtualObject: ModelEntity
    
    var body: some View {
        ZStack {
            let number = swatches.count < 6 ? swatches.count - 1 : 5
            let angle = 2.0 / CGFloat(number + 1) * .pi
            ForEach(Array(zip(swatches[0...number], swatches[0...number].indices)), id: \.0) { name, index in
                Swatch(name: name, swatch: $swatch)
                    .position(x: touchPoint.x + cos(angle * CGFloat(index)) * 40, y: touchPoint.y - sin(angle * CGFloat(index)) * 40)
                    .onTapGesture {
                        swatch = name
                        virtualObject.model?.materials = Assets().materials(swatch)
                    }
            }
        }
        if swatches.count > 6 {
            ZStack {
                let angle = 2.0 / CGFloat(8) * .pi
                ForEach(Array(zip(swatches[6...13], swatches[6...13].indices)), id: \.0) { name, index in
                    Swatch(name: name, swatch: $swatch)
                        .position(x: touchPoint.x + cos(angle * CGFloat(index)) * 80, y: touchPoint.y - sin(angle * CGFloat(index)) * 80)
                        .onTapGesture {
                            swatch = name
                            virtualObject.model?.materials = Assets().materials(swatch)
                        }
                }
            }
        }
    }
}
