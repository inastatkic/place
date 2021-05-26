//
//  NumberFormatter.swift
//  APlace
//
//  Created by Ina Statkic on 5/25/21.
//

import Foundation

extension NumberFormatter {
    static let decimalFormatter: NumberFormatter = {
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .decimal
        numberFormatter.maximumFractionDigits = 2
        return numberFormatter
    }()
}
