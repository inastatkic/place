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
    var touchEntity: ((CGPoint, ModelEntity) -> ())
    var surfaceClassification: ((SurfaceClassification) -> ())
    var ceilingHeight: ((Float) -> ())
    private let locationManager = CLLocationManager()
    
    func makeUIView(context: Context) -> ARView {
        
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
        configuration.isLightEstimationEnabled = true
        configuration.frameSemantics = .smoothedSceneDepth
        arView.session.run(configuration)
        
        // Prevent the screen from being dimmed to avoid interrupting the AR experience.
        UIApplication.shared.isIdleTimerDisabled = true
        
        // MARK: - Debug
        
        // Display a debug visualization of the mesh
//        arView.debugOptions.insert(.showSceneUnderstanding)
//        arView.debugOptions.insert(.showAnchorOrigins)
        
        // MARK: - Render
        
        // For performance, disable render options that are not required for this app.
        arView.renderOptions.insert(.disableMotionBlur)
        // Add Depth of Field
        arView.renderOptions.remove(.disableDepthOfField)
        
        // MARK: - Experience
        
        // Load the Object scene from the Experience Reality File
//        let objectAnchor = try! Experience.loadObject()

        // Add the object anchor to the scene
//        arView.scene.anchors.append(objectAnchor)
        
        // MARK: - Gestures
        
        let tapGesture = UITapGestureRecognizer(target: context.coordinator, action: #selector(Coordinator.handleTap))
        arView.addGestureRecognizer(tapGesture)
        
        let touchGesture = UITapGestureRecognizer(target: context.coordinator, action: #selector(Coordinator.handleTouch))
        touchGesture.numberOfTouchesRequired = 2
        arView.addGestureRecognizer(touchGesture)
        
        let longPressGesture = UILongPressGestureRecognizer(target: context.coordinator, action: #selector(Coordinator.handleLongPress))
        longPressGesture.allowableMovement = 100
        arView.addGestureRecognizer(longPressGesture)
        
        arView.session.delegate = context.coordinator
        
        locationManager.startUpdatingHeading()
        locationManager.delegate = context.coordinator
        
        // MARK: - ARView
        
        return arView
    }
    
    // MARK: - Coordinator
    
    func makeCoordinator() -> Coordinator {
        Coordinator(
            self,
            touchEntity: touchEntity,
            surfaceClassification: surfaceClassification,
            ceilingHeight: ceilingHeight
        )
    }
    
    class Coordinator: NSObject, ARSessionDelegate, CLLocationManagerDelegate {
        var arViewContainer: ARViewContainer
        var touchEntity: ((CGPoint, ModelEntity) -> ())
        var surfaceClassification: ((SurfaceClassification) -> ())
        private var lastTouchPosition: SIMD3<Float>?
        var ceilingHeight: ((Float) -> ())
        var sceneAnchors: [AnchorClassification] = [AnchorClassification]()
        var planeAnchors: [AnchorClassification] = [AnchorClassification]()
        
        init(_ arViewContainer: ARViewContainer,
             touchEntity: @escaping ((CGPoint, ModelEntity) -> ()),
             surfaceClassification: @escaping ((SurfaceClassification) -> ()),
             ceilingHeight: @escaping ((Float) -> ())) {
            self.arViewContainer = arViewContainer
            self.touchEntity = touchEntity
            self.surfaceClassification = surfaceClassification
            self.ceilingHeight = ceilingHeight
        }
        
        // MARK: - Actions
        
        @objc func handleTap(sender: UITapGestureRecognizer) {
            let touchPoint = sender.location(in: arViewContainer.arView)
            
            guard let ray = arViewContainer.arView.ray(through: touchPoint) else { return }
            
            // Ray-cast intersected with the virtual objects
            if let result = arViewContainer.arView.scene.raycast(origin: ray.origin, direction: ray.direction).first {
                // Intersection point of the ray with the virtual surface.
                let resultAnchor = AnchorEntity(world: result.position)
                // Place on top of the other virtual object
                // TODO: limit which objects you can place on top of other
                if let virtualObject = arViewContainer.virtualObject?.entity {
                    place(virtualObject, at: resultAnchor, in: arViewContainer.arView)
                }
            // Ray-cast intersected with the real-world surfaces
            // Ray-cast allowing estimated plane with any alignment takes the mesh into account
            } else if let result = arViewContainer.arView.raycast(from: touchPoint, allowing: .estimatedPlane, alignment: .any).first {
                // Intersection point of the ray with the real-world surface.
                let resultAnchor = AnchorEntity(world: result.worldTransform.position)
                
                if let virtualObject = arViewContainer.virtualObject?.entity {
                    place(virtualObject, at: resultAnchor, in: arViewContainer.arView)
                }
            }
            
            if let result = arViewContainer.arView.raycast(from: touchPoint, allowing: .estimatedPlane, alignment: .any).first {
                // Intersection point of the ray with the real-world surface.
                let resultAnchor = AnchorEntity(world: result.worldTransform.position)
                
                if let lastTouchPosition = lastTouchPosition {
                    // Measure distance from touch to last touch
                    print(distance(result.worldTransform.position, lastTouchPosition))
                }
                
                lastTouchPosition = result.worldTransform.position
//                mark(at: resultAnchor, in: arViewContainer.arView)
                
                nearbyFaceWithClassification(to: result.worldTransform.position) { [weak self] (centerOfFace, classification) in
                    // Center of the face (if any was found)
                    // It is possible that this is nil, e.g. if there was no face close enough to the tap location.
                    if centerOfFace != nil {
//                        print(classification.description)
                        self?.surfaceClassification(SurfaceClassification(mesh: classification, projection: touchPoint))
                    }
                    DispatchQueue.main.async {
                        // TODO: Visualize the classification result.
                    }
                }
            }
        }
        
        @objc func handleLongPress(sender: UILongPressGestureRecognizer) {
            let touchPoint = sender.location(in: arViewContainer.arView)
            // Entity under touch point
            guard let entity = arViewContainer.arView.entity(at: touchPoint) else { return }
            if entity.anchor != nil {
                touchEntity(touchPoint, entity as! ModelEntity)
                arViewContainer.virtualObject = VirtualObject(name: entity.name, entity: entity as! ModelEntity)
            }
        }
        
        @objc func handleTouch(sender: UITapGestureRecognizer) {
            let touchPoint = sender.location(in: arViewContainer.arView)
            guard let entity = arViewContainer.arView.entity(at: touchPoint) else { return }
            entity.removeFromParent()
            // TODO: untouch - remove the point and empty entity
            touchEntity(CGPoint(x: -100, y: -100), ModelEntity())
        }
        
        // MARK: - Vision
        
        let visionModel = VisionModel()
        
        // The pixel buffer being held for analysis; used to serialize Vision requests.
        var currentBuffer: CVPixelBuffer?
        
        // Queue for dispatching vision classification requests
        let visionQueue = DispatchQueue(label: "me.human.APlace.visionQueue")
        
        // Vision Request
        lazy var classificationRequest: VNCoreMLRequest = {
            do {
                // Instantiate the model from its generated Swift class.
                let model = try VNCoreMLModel(for: visionModel.objectModel.model)
                let request = VNCoreMLRequest(model: model, completionHandler: { [weak self] request, error in
                    self?.processClassifications(for: request, error: error)
                })
                // Crop input images to square area at center, matching the way the ML model was trained.
                    request.imageCropAndScaleOption = .centerCrop
                // Use CPU for Vision processing to ensure that there are adequate GPU resources for rendering.
                request.usesCPUOnly = true
                return request
            } catch {
                fatalError("Failed to load Vision ML model: \(error)")
            }
        }()
        
        // MARK: - ARSession Delegate
        
        func session(_ session: ARSession, didUpdate frame: ARFrame) {
//            guard let lightEstimate = session.currentFrame?.lightEstimate else { return }
//            print(lightEstimate.ambientColorTemperature)
//            print(lightEstimate.ambientIntensity)
            
            // Pass camera frames received from ARKit to Vision
            guard currentBuffer == nil else { return }
            // Retain the image buffer for Vision processing.
            self.currentBuffer = frame.capturedImage
//            classifyCurrentImage()
        }
        
        func session(_ session: ARSession, didAdd anchors: [ARAnchor]) {
//            print(arViewContainer.arView.scene.anchors)
            // Session automatically attempts to detect surfaces
            guard
                let firstAnchor = anchors.first,
                let projection = arViewContainer.arView.project(firstAnchor.transform.position)
            else { return }
            nearbyFaceWithClassification(to: firstAnchor.transform.position) { [weak self] (centerOfFace, classification) in
                if centerOfFace != nil {
                    self?.surfaceClassification(SurfaceClassification(mesh: classification, projection: projection))
                }
            }
            
//            let spot = ModelEntity(mesh: .generateSphere(radius: 0.01), materials: [SimpleMaterial()])
            for anchor in anchors {
                nearbyFaceWithClassification(to: anchor.transform.position) { [weak self] (centerOfFace, classification) in
                    if centerOfFace != nil {
                        self?.sceneAnchors.append(AnchorClassification(mesh: classification, position: anchor.transform.position))
                        if
                            let ceiling = self?.sceneAnchors.first(where: { $0.mesh == .ceiling })?.position.y,
                            let floor = self?.sceneAnchors.first(where: { $0.mesh == .floor })?.position.y
                        {
                            // Distance from detected ceiling to floor
                            self?.ceilingHeight(distance(SIMD3<Float>(0,ceiling,0), SIMD3<Float>(0,floor,0)))
                        }
                        if anchor.isKind(of: ARPlaneAnchor.self) && classification == .wall {
                            self?.planeAnchors.append(AnchorClassification(mesh: classification, position: anchor.transform.position))
//                            print(anchor)
//                            let anchorEntity = AnchorEntity(world: anchor.transform.position)
//                            anchorEntity.addChild(spot)
//                            self?.arViewContainer.arView.scene.addAnchor(anchorEntity)
                        }
                    }
                }
            }
        }
        
        // MARK: - Location Delegate
        
        func locationManager(_ manager: CLLocationManager, didUpdateHeading newHeading: CLHeading) {
//            print(newHeading.trueHeading)
        }
        
    }
    
    // MARK: - Update ARView
    
    func updateUIView(_ uiView: ARView, context: Context) {
        virtualObject?.loadAsync()
    }
    
}
