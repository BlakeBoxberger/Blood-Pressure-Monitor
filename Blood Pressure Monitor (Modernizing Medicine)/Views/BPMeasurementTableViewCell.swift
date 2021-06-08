//
//  BPMeasurementTableViewCell.swift
//  Blood Pressure Monitor (Modernizing Medicine)
//
//  Created by Blake Boxberger on 6/7/21.
//

import UIKit

class BPMeasurementTableViewCell: UITableViewCell {
    @IBOutlet weak var dateAddedLabel: UILabel!
    @IBOutlet weak var systolicLabel: UILabel!
    @IBOutlet weak var diastolicLabel: UILabel!
    @IBOutlet weak var categoryLabel: UILabel!
    
    var measurement: BPMeasurement! {
        didSet {
            guard let measurement = measurement else {
                return
            }
            
            // Set dateAdded label text
            let dateFormatter = DateFormatter()
            
            dateFormatter.dateStyle = .short
            dateFormatter.timeStyle = .none
            
            let dateAddedString = dateFormatter.string(from: measurement.dateAdded)
            
            dateFormatter.dateStyle = .none
            dateFormatter.timeStyle = .short
            
            let timeAddedString = dateFormatter.string(from: measurement.dateAdded)
            
            dateAddedLabel.text = "\(dateAddedString)\n\(timeAddedString)"
            
            // Set systolic/diastolic text
            systolicLabel.text = "\(measurement.systolic)"
            diastolicLabel.text = "\(measurement.diastolic)"
            
            // Set category
            categoryLabel.text = measurement.category.description
        }
    }
    
    override func prepareForReuse() {
        dateAddedLabel.text = ""
        systolicLabel.text = ""
        diastolicLabel.text = ""
        categoryLabel.text = ""
    }
}
