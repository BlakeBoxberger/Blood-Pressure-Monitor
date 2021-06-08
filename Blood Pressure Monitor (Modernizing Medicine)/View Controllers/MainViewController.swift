//
//  ViewController.swift
//  Blood Pressure Monitor (Modernizing Medicine)
//
//  Created by Blake Boxberger on 6/7/21.
//

import UIKit

class MainViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    @IBOutlet weak var measurementTitleLabel: UILabel!
    @IBOutlet weak var measurementSecondaryLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    
    var patient: Patient?
    var measurements: [BPMeasurement] = [] {
        didSet {
            // Reload tableView data on the main queue (all UI work must be done on the main thread)
            DispatchQueue.main.async { [unowned self] in
                tableView.reloadData()
            }
        }
    }
    var selectedMeasurement: BPMeasurement? {
        didSet {
            // Check if there is a selectedMeasurement
            guard let selectedMeasurement = selectedMeasurement else {
                measurementTitleLabel.text = "No measurement selected. :("
                measurementSecondaryLabel.text = "Select a measurement above to view more info."
                return
            }
            
            // Update labels
            measurementTitleLabel.text = "Your BP is \(selectedMeasurement.category.description.lowercased())."
            
            // Set dateAdded label text
            let dateFormatter = DateFormatter()
            
            dateFormatter.dateStyle = .short
            dateFormatter.timeStyle = .none
            
            let dateAddedString = dateFormatter.string(from: selectedMeasurement.dateAdded)
            
            dateFormatter.dateStyle = .none
            dateFormatter.timeStyle = .short
            
            let timeAddedString = dateFormatter.string(from: selectedMeasurement.dateAdded)
            
            measurementSecondaryLabel.text = "\(dateAddedString) at \(timeAddedString)"
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set up tableView
        tableView.dataSource = self
        tableView.delegate = self
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        // Ask patient for information
        _requestPatientInformation()
    }
    
    private func _requestPatientInformation() {
        // Exit early if the patient is already set
        guard patient == nil else {
            return
        }
        
        // Set up alert controller
        let alertController = UIAlertController(title: "Who are you?", message: "Please enter your first name, last name, and birthdate (mm/dd/yyyy).", preferredStyle: .alert)
        
        // Set up alert controller text fields
        alertController.addTextField { textField in
            textField.placeholder = "First name"
        }
        alertController.addTextField { textField in
            textField.placeholder = "Last name"
        }
        alertController.addTextField { textField in
            textField.placeholder = "Birthday"
        }
        
        // Set up enter action
        let enterAction = UIAlertAction(title: "Enter", style: .default) { [unowned alertController, self] action in
            // Read user entries from text fields
            let firstName = alertController.textFields?[0].text
            let lastName = alertController.textFields?[1].text
            let birthday = alertController.textFields?[2].text
            
            // Unwrap patient information
            guard let firstName = firstName, let lastName = lastName, let birthday = birthday else {
                fatalError("\(#file), Line: \(#line) - Could not retrieve patient information.")
            }
            
            // Create birthdayDate
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "MM/dd/yyyy"
            let birthdayDate = dateFormatter.date(from: birthday)
            
            // Unwrap birthdayDate
            guard let birthdayDate = birthdayDate else {
                print("\(#file), Line: \(#line) - Patient birthday is not a valid date.")
                
                // Present error alert to user, then try again
                let birthdayInvalidAlertController = UIAlertController(title: "Invalid Birthday", message: "Please enter a valid birthday in any format.", preferredStyle: .alert)
                let dismissAction = UIAlertAction(title: "Dismiss", style: .default) { _ in
                    _requestPatientInformation()
                }
                
                // Add dismiss action
                birthdayInvalidAlertController.addAction(dismissAction)
                
                // Present alert
                self.present(birthdayInvalidAlertController, animated: true, completion: nil)
                return
            }
            
            // Create and set patient
            patient = Patient(firstName: firstName, lastName: lastName, birthday: birthdayDate)
        }
        
        // Add enter action
        alertController.addAction(enterAction)
        
        // Present alert
        self.present(alertController, animated: true, completion: nil)
    }

    @IBAction func addNewMeasurementButtonTapped(_ sender: UIButton) {
        // Set up alert controller
        let alertController = UIAlertController(title: "New Measurement", message: "Please enter your systolic (upper) and diastolic (lower) values.", preferredStyle: .alert)
        
        // Set up alert controller text fields
        alertController.addTextField { textField in
            textField.placeholder = "Systolic (upper)"
        }
        alertController.addTextField { textField in
            textField.placeholder = "Diastolic (lower)"
        }
        
        // Set up enter action
        let enterAction = UIAlertAction(title: "Enter", style: .default) { [unowned alertController, self] action in
            // Read user entries from text fields
            let systolic = alertController.textFields?[0].text
            let diastolic = alertController.textFields?[1].text
            
            // Unwrap measurement information
            guard let systolic = systolic, let diastolic = diastolic, let systolicInt = Int(systolic), let diastolicInt = Int(diastolic) else {
                print("\(#file), Line: \(#line) - Could not unwrap new measurement information.")
                
                // In a perfect world, I would alert the user but I am running out of time.
                return
            }
            
            // Create new BPMeasurement and add it to the front of the measurements array
            let newMeasurement = BPMeasurement(systolic: systolicInt, diastolic: diastolicInt)
            measurements.insert(newMeasurement, at: 0)
            selectedMeasurement = newMeasurement
            
            // Check if the category is Hypertension Stage Two or Hypertensive Crisis
            if newMeasurement.category == .hypertensionStageTwo || newMeasurement.category == .hypertensiveCrisis {
                // Alert user to go to the doctor
                let alertController = UIAlertController(title: "Go to the doctor.", message: "You are experiencing \(newMeasurement.category). Visit the ER or physician immediately.", preferredStyle: .alert)
                let dismissAction = UIAlertAction(title: "Ok, leaving now.", style: .destructive, handler: nil)
                alertController.addAction(dismissAction)
                self.present(alertController, animated: true, completion: nil)
            }
        }
        
        // Add enter action
        alertController.addAction(enterAction)
        
        // Present alert
        self.present(alertController, animated: true, completion: nil)
    }
    
    @IBAction func helpButtonTapped(_ sender: UIButton) {
        let alertController = UIAlertController(title: "", message: "Tap \"add a new measurement\" to add a new entry, and tap any entry to view relevant imformation! \n\nPretty easy, huh? :)\n\nThis app was created for assessment purposes only. Please do not reuse or modify this code in your own projects.\n\nThank you!\n\nMade with ❤️ by Blake.", preferredStyle: .alert)
        let dismissAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertController.addAction(dismissAction)
        self.present(alertController, animated: true, completion: nil)
    }
    
    // MARK: UITableViewDataSource Protocol
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return measurements.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "bp-measurement-cell") as? BPMeasurementTableViewCell else {
            fatalError("\(#file), Line: \(#line) - Could not dequeue reusable cell.")
        }
        
        // Configure cell with measurement at indexPath.row
        let measurement = measurements[indexPath.row]
        cell.measurement = measurement
        
        return cell
    }
    
    // MARK: UITableViewDelegate
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let newSelectedMeasuremet = measurements[indexPath.row]
        selectedMeasurement = newSelectedMeasuremet
    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        selectedMeasurement = nil
    }
}

