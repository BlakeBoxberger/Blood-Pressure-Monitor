//
//  BPCategory.swift
//  Blood Pressure Monitor (Modernizing Medicine)
//
//  Created by Blake Boxberger on 6/7/21.
//

import Foundation

enum BPCategory {
    case normal, elevated, hypertensionStageOne, hypertensionStageTwo, hypertensiveCrisis, unknown
}

extension BPCategory {
    static func categoryForMeasurement(_ measurement: BPMeasurement) -> BPCategory {
        // Follow chart
        let systolic = measurement.systolic
        let diastolic = measurement.diastolic
        
        if systolic < 120 && diastolic < 80 {
            return .normal
        } else if (120...129).contains(systolic) && diastolic < 80 {
            return .elevated
        } else if (130...139).contains(systolic) || (80...89).contains(diastolic) { // Unsure if Stage One and Stage Two are OR (||) or XOR (!=) as Crisis specifically says "and/or"
            return .hypertensionStageOne
        } else if (140...180).contains(systolic) || (90...120).contains(diastolic) {
            return .hypertensionStageTwo
        } else if systolic > 180 || diastolic > 120 {
            return .hypertensiveCrisis
        }
        
        return .unknown
    }
}

extension BPCategory: CustomStringConvertible {
    var description: String {
        switch self {
        case .normal:
            return "Normal"
        case .elevated:
            return "Elevated"
        case .hypertensionStageOne:
            return "Hypertension Stage One"
        case .hypertensionStageTwo:
            return "Hypertension Stage Two"
        case .hypertensiveCrisis:
            return "Hypertensive Crisis"
        case .unknown:
            return "Unknown"
        }
    }
}
