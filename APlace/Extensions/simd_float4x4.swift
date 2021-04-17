//
//  simd_float4x4.swift
//  APlace
//
//  Created by Ina Statkic on 4/9/21.
//

import ARKit

extension simd_float4x4 {
    var position: SIMD3<Float> {
        return SIMD3<Float>(columns.3.x, columns.3.y, columns.3.z)
    }
}
