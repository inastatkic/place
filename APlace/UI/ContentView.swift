//
//  ContentView.swift
//  APlace
//
//  Created by Ina Statkic on 3/29/21.
//

import SwiftUI
import RealityKit

struct ContentView : View {
    @State var touchPoint = (CGPoint(x: -100, y: -100), ModelEntity())
    @State var virtualObject: VirtualObject? = VirtualObject(name: "plastic_side_chair")

    var body: some View {
        ZStack {
            ARViewContainer(virtualObject: $virtualObject) {
                touchPoint = ($0, $1)
            }
            SwatchPicker(touchPoint: $touchPoint.0, virtualObject: $touchPoint.1)
        }.edgesIgnoringSafeArea(.all)
    }
}

#if DEBUG
struct ContentView_Previews : PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
#endif
