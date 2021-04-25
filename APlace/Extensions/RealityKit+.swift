// Created by Ina Statkic in 2021.

import RealityKit

extension HasModel where Self: Entity {
    public func replaceMaterial(_ index: Int, with material: Material) {
        guard index >= 0, index < model?.materials.count ?? 0 else {
            let materialCount = model?.materials.count ?? 0
            fatalError(String(format: "index out of range", materialCount))
        }
        model?.materials[index] = material
    }
}
