//
//  Patient.swift
//  Blood Pressure Monitor (Modernizing Medicine)
//
//  Created by Blake Boxberger on 6/7/21.
//

import Foundation

class Patient {
    let firstName: String
    let lastName: String
    var fullName: String {
        return "\(firstName) \(lastName)"
    }
    let birthday: Date
    
    internal init(firstName: String, lastName: String, birthday: Date) {
        self.firstName = firstName
        self.lastName = lastName
        self.birthday = birthday
    }
}
