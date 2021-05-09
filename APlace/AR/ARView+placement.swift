// Created by Ina Statkic in 2021.

import RealityKit

extension ARViewContainer.Coordinator {
    func place(_ entity: ModelEntity, at anchor: AnchorEntity, in arView: ARView) {
        let entity = entity.clone(recursive: true)
        entity.generateCollisionShapes(recursive: true)
        arView.installGestures([.translation, .rotation], for: entity)
        anchor.addChild(entity)
        arView.scene.addAnchor(anchor)
    }
    
    func mark(at anchor: AnchorEntity, in arView: ARView) {
        let sphere = ModelEntity(mesh: .generateSphere(radius: 0.01), materials: [UnlitMaterial(color: .white)])
        // Move sphere up by half its diameter so that it does not intersect with the mesh
        sphere.position.y = 0.01
        anchor.addChild(sphere)
        arView.scene.addAnchor(anchor)
    }
}
