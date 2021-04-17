//
//  Model.swift
//  APlace
//
//  Created by Ina Statkic on 4/6/21.
//

import Foundation
import RealityKit
import Combine

enum Kind {
    case table, lamp, chair
}

final class VirtualObject {
    var name: String
    var entity: ModelEntity?
    var kind: Kind?
    
    init(name: String) {
        self.name = name
    }
    
    private var loadRequest: AnyCancellable?
    
    func loadAsync() {
        let filename = "\(name).usdz"
        
        loadRequest = Entity.loadModelAsync(named: filename)
//            .append(Entity.loadModelAsync(named: "MyOtherEntity"))
//            .collect()
            .sink(receiveCompletion: { loadCompletion in
                switch loadCompletion {
                case .failure(let error):
                    debugPrint(error.localizedDescription)
                case .finished: break
                }
            }, receiveValue: { entity in
                // TODO: collect and receive entities
                self.entity = entity
            })
    }

}
