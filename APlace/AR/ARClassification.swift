//
//  ARClassification.swift
//  APlace
//
//  Created by Ina Statkic on 5/7/21.
//

import ARKit.ARMeshGeometry

struct SurfaceClassification {
    var mesh: ARMeshClassification = .none
    var anchor: ARAnchor?
    // point from the 3D world to the pixel of the viewport
    var projection = CGPoint()
}
