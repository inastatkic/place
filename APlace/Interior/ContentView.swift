//
//  ContentView.swift
//  APlace
//
//  Created by Ina Statkic on 3/29/21.
//

import SwiftUI
import RealityKit

struct ContentView : View {
    @State private var showCompositions: Bool = false
    @State var touchEntity = (CGPoint(), ModelEntity())
    @State var virtualObject: VirtualObject?
    @State var swatches: [String] = []
    @State var surfaceClassification = SurfaceClassification()

    var body: some View {
        ZStack {
            ARViewContainer(virtualObject: $virtualObject) {
                touchEntity = ($0, $1)
                guard
                    let name = virtualObject?.name,
                    let asset = Assets(rawValue: name)
                else { return }
                swatches = Assets(asset: asset).swatches()
            } surfaceClassification: {
                surfaceClassification = $0
            }.edgesIgnoringSafeArea(.all)
            SwatchPicker(swatches: $swatches, touchPoint: $touchEntity.0, model: $touchEntity.1)
            ContextSuggestion(surfaceClassification: $surfaceClassification)
            VStack {
                Spacer()
                Button {
                    showCompositions.toggle()
                } label: {
                    Image(systemName: "circle.fill")
                        .imageScale(.large)
                        .foregroundColor(.white)
                        .padding()
                }.sheet(isPresented: $showCompositions) {
                    CompositionsView(virtualObject: $virtualObject)
                }
            }
        }
    }
}

#if DEBUG
struct ContentView_Previews : PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
#endif
