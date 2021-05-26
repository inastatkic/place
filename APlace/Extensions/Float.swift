//
//  Float.swift
//  APlace
//
//  Created by Ina Statkic on 5/25/21.
//

import Foundation

extension Float {
    func meter() -> String {
        let mesurementFormatter = MeasurementFormatter()
        mesurementFormatter.unitOptions = .providedUnit
        mesurementFormatter.numberFormatter = NumberFormatter.decimalFormatter
        let value = String(self)
        let meter = Measurement<UnitLength>(value: Double(value)!, unit: .meters)
        return mesurementFormatter.string(from: meter)
    }
}
