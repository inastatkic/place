//
//  Assets.swift
//  APlace
//
//  Created by Ina Statkic on 4/15/21.
//

import UIKit
import RealityKit

enum Assets: String, CaseIterable {
    case plasticSideChair
    case fiberglassSideChair

    init(asset: Assets) {
        self = asset
    }
    
    func materials(_ swatch: String) -> [Material] {
        switch self {
        case .plasticSideChair:
            return [
                SimpleMaterial(color: UIColor(named: "20")!, roughness: .float(0.68), isMetallic: false),
                SimpleMaterial(color: UIColor(red: 229.0, green: 229.0, blue: 229.0, alpha: 1.0), isMetallic: true),
                SimpleMaterial(color: UIColor(named: swatch)!, roughness: .float(0.25), isMetallic: false),
                SimpleMaterial(color: UIColor(named: swatch)!, roughness: .float(0.25), isMetallic: false)
            ]
        case .fiberglassSideChair:
            var shellMeterial = SimpleMaterial()
            shellMeterial.roughness = .float(0.25)
            if let image = try? TextureResource.load(named: swatch) {
                shellMeterial.baseColor = .texture(image)
            }
            return [
                SimpleMaterial(color: UIColor(red: 229.0, green: 229.0, blue: 229.0, alpha: 1.0), isMetallic: true),
                SimpleMaterial(color: UIColor(named: "88")!, roughness: .float(0.68), isMetallic: false),
                shellMeterial
            ]
        }
    }
    
    func swatches() -> [String] {
        switch self {
        case .plasticSideChair:
            return VitraColour.allCases.map { "vitra.\($0.rawValue)" }
        case .fiberglassSideChair:
            return VitraFiberglass.allCases.map { "fiberglass.\($0.rawValue)" }
        }
    }
}
