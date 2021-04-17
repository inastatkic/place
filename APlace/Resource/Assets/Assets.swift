//
//  Assets.swift
//  APlace
//
//  Created by Ina Statkic on 4/15/21.
//

import UIKit
import RealityKit

enum Assets: CaseIterable {
    case plasticSideChair
    
    /// File name
    var name: String {
        switch self {
            case .plasticSideChair: return "plastic_side_chair"
        }
    }

    init() {
        self = .plasticSideChair
    }
    
    func materials(_ swatch: String) -> [Material] {
        switch self {
        case .plasticSideChair:
            return [
                SimpleMaterial(color: .black, isMetallic: false),
                SimpleMaterial(color: .init(red: 229, green: 229, blue: 229, alpha: 1), isMetallic: true),
                SimpleMaterial(color: UIColor(named: swatch)!, roughness: .float(0.25), isMetallic: false),
                SimpleMaterial(color: UIColor(named: swatch)!, roughness: .float(0.25), isMetallic: false)
            ]
        }
    }
}
