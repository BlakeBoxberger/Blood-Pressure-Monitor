//
//  BPMeasurement.swift
//  Blood Pressure Monitor (Modernizing Medicine)
//
//  Created by Blake Boxberger on 6/7/21.
//

import Foundation

struct BPMeasurement {
    var systolic: Int
    var diastolic: Int
    let dateAdded = Date()
    var category: BPCategory {
        return BPCategory.categoryForMeasurement(self)
    }
}
