
//  Child.swift
//  NurseryConnect

import Foundation
import SwiftData

@Model
final class Child {
    var id: UUID
    var fullName: String
    var preferredName: String
    var dateOfBirth: Date
    var roomName: String
    var profileImageData: Data?
    var allergies: [String]
    var dietaryRequirements: String
    var medicalNotes: String
    var photographyConsent: Bool
    var parentName: String
    var parentContact: String
    var emergencyContact: String

    @Relationship(deleteRule: .cascade, inverse: \DiaryEntry.child)
    var diaryEntries: [DiaryEntry] = []

    @Relationship(deleteRule: .cascade, inverse: \IncidentReport.child)
    var incidents: [IncidentReport] = []

    init(
        id: UUID = UUID(),
        fullName: String,
        preferredName: String = "",
        dateOfBirth: Date,
        roomName: String,
        profileImageData: Data? = nil,
        allergies: [String] = [],
        dietaryRequirements: String = "",
        medicalNotes: String = "",
        photographyConsent: Bool = false,
        parentName: String,
        parentContact: String,
        emergencyContact: String
    ) {
        self.id = id
        self.fullName = fullName
        self.preferredName = preferredName.isEmpty ? fullName : preferredName
        self.dateOfBirth = dateOfBirth
        self.roomName = roomName
        self.profileImageData = profileImageData
        self.allergies = allergies
        self.dietaryRequirements = dietaryRequirements
        self.medicalNotes = medicalNotes
        self.photographyConsent = photographyConsent
        self.parentName = parentName
        self.parentContact = parentContact
        self.emergencyContact = emergencyContact
    }

    // MARK: - Computed Properties

    var age: String {
        let calendar = Calendar.current
        let now = Date.now
        let components = calendar.dateComponents([.year, .month], from: dateOfBirth, to: now)

        let years = components.year ?? 0
        let months = components.month ?? 0

        if years > 0 {
            return months > 0 ? "\(years)y \(months)m" : "\(years) year\(years == 1 ? "" : "s")"
        } else {
            return "\(months) month\(months == 1 ? "" : "s")"
        }
    }

    var hasActiveAllergens: Bool {
        !allergies.isEmpty
    }
}
