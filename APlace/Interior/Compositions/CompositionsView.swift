//
//  CompositionsView.swift
//  APlace
//
//  Created by Ina Statkic on 4/9/21.
//

import SwiftUI

struct CompositionsView: View {
    @Binding var virtualObject: VirtualObject?
    var compositions: [Composition] = [Composition(name: "", filename: Assets.fiberglassSideChair.rawValue, image: Image("EamesFiberglassSideChairDSR")), Composition(name: "", filename: Assets.plasticSideChair.rawValue, image: Image("EamesPlasticSideChairDSR"))]
    
    var body: some View {
        let columns = [GridItem(.adaptive(minimum: 100), spacing: 10)]
        
        ScrollView(showsIndicators: false) {
            LazyVGrid(columns: columns, spacing: 10) {
                ForEach(compositions) { composition in
                    CompositionView(composition: composition)
                        .onTapGesture {
                            virtualObject = nil
                            virtualObject = VirtualObject(name: composition.filename)
                        }
                }
            }.padding(.vertical)
        }
    }
}
