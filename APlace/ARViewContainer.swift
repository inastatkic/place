//
//  ARViewContainer.swift
//  APlace
//
//  Created by Ina Statkic on 4/10/21.
//

import SwiftUI
import RealityKit
import ARKit

struct ARViewContainer: UIViewRepresentable {
    let arView = ARView(frame: .zero)
    @Binding var virtualObject: VirtualObject?
    var touchPoint: ((CGPoint, ModelEntity) -> Void)
    
    func makeUIView(context: Context) -> ARView {
        
        // Prevent the screen from being dimmed to avoid interrupting the AR experience.
        UIApplication.shared.isIdleTimerDisabled = true

        
        // MARK: - Environment
        
        // Reverberation, spatial audio settings
        arView.environment.reverb = .preset(.smallRoom)
        
        // Initialize list of Scene Understanding options
        arView.environment.sceneUnderstanding.options = []
        // Receives Lighting allows virtual objects to cast shadows on real-world surfaces.
        // Physics enables the act of virtual objects physically interacting with the real world.
        // Collision enables the generation of collision events, as well as the ability to ray-cast against the real world.
        arView.environment.sceneUnderstanding.options.insert(.occlusion)
        arView.environment.sceneUnderstanding.options.insert(.receivesLighting)
        arView.environment.sceneUnderstanding.options.insert(.physics)
        
        // MARK: - Configuration
        
        // AR session
        arView.automaticallyConfigureSession = false
        let configuration = ARWorldTrackingConfiguration()
        configuration.sceneReconstruction = .meshWithClassification
        configuration.planeDetection = [.horizontal, .vertical]
        configuration.environmentTexturing = .automatic
        arView.session.run(configuration)
        
        // MARK: - Debug
        
        // Display a debug visualization of the mesh
//        arView.debugOptions.insert(.showSceneUnderstanding)
        
//        arView.debugOptions.insert(.showFeaturePoints)
        
        // MARK: - Render
        
        // For performance, disable render options that are not required for this app.
        arView.renderOptions = [.disableMotionBlur]
        
        // MARK: - Experience
        
        // Load the Object scene from the Experience Reality File
//        let objectAnchor = try! Experience.loadObject()

        // Add the object anchor to the scene
//        arView.scene.anchors.append(objectAnchor)
        
        // MARK: - Actions
        
        let tapGesture = UITapGestureRecognizer(target: context.coordinator, action: #selector(Coordinator.handleTap))
        arView.addGestureRecognizer(tapGesture)
        
        let longPressGesture = UILongPressGestureRecognizer(target: context.coordinator, action: #selector(Coordinator.handleLongPress))
        longPressGesture.allowableMovement = 100
        arView.addGestureRecognizer(longPressGesture)
        
        return arView
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self, touchPoint: touchPoint)
    }
    
    class Coordinator: NSObject {
        var arViewContainer: ARViewContainer
        var touchPoint: ((CGPoint, ModelEntity) -> Void)
        
        init(_ arViewContainer: ARViewContainer, touchPoint: @escaping ((CGPoint, ModelEntity) -> Void)) {
            self.arViewContainer = arViewContainer
            self.touchPoint = touchPoint
        }
        
        // MARK: - Actions
        
        @objc func handleTap(sender: UITapGestureRecognizer) {
            let touchPoint = sender.location(in: arViewContainer.arView)
            // Ray-cast allowing estimated plane with any alignment takes the mesh into account
            if let result = arViewContainer.arView.raycast(from: touchPoint, allowing: .estimatedPlane, alignment: .any).first {
                // Intersection point of the ray with the real-world surface.
                let resultAnchor = AnchorEntity(world: result.worldTransform.position)
                
                if let virtualObject = arViewContainer.virtualObject?.entity {
                    place(virtualObject, at: resultAnchor, in: arViewContainer.arView)
                }
            }
        }
        
        private func place(_ entity: ModelEntity, at anchor: AnchorEntity, in arView: ARView) {
            let entity = entity.clone(recursive: true)
            entity.generateCollisionShapes(recursive: true)
            arView.installGestures([.translation, .rotation], for: entity)
            anchor.addChild(entity)
            arView.scene.addAnchor(anchor)
        }
        
        @objc func handleLongPress(sender: UILongPressGestureRecognizer) {
            let touchPoint = sender.location(in: arViewContainer.arView)
            // Entity under touch point
            guard let entity = arViewContainer.arView.entity(at: touchPoint) else { return }
            if entity.anchor != nil {
                self.touchPoint(touchPoint, entity as! ModelEntity)
            }
        }
        
    }
    
    func updateUIView(_ uiView: ARView, context: Context) {
        virtualObject?.loadAsync()
    }
    
}
