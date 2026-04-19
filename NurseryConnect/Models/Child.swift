import Foundation
import SwiftData

@Model
final class Child {
    var id: UUID
    var fullName: String
    var preferredName: String
    var dateOfBirth: Date
    var roomName: String
    var keyworkerUUID: UUID
    var photoConsent: Bool
    var allergens: [String]
    var dietaryRequirements: [String]
    var medicalNotes: String
    var contactsData: Data

    init(
        id: UUID = UUID(),
        fullName: String,
        preferredName: String = "",
        dateOfBirth: Date,
        roomName: String,
        keyworkerUUID: UUID,
        photoConsent: Bool = true,
        allergens: [String] = [],
        dietaryRequirements: [String] = [],
        medicalNotes: String = "",
        contacts: [ChildContact] = []
    ) {
        self.id = id
        self.fullName = fullName
        self.preferredName = preferredName.isEmpty ? fullName : preferredName
        self.dateOfBirth = dateOfBirth
        self.roomName = roomName
        self.keyworkerUUID = keyworkerUUID
        self.photoConsent = photoConsent
        self.allergens = allergens
        self.dietaryRequirements = dietaryRequirements
        self.medicalNotes = medicalNotes
        self.contactsData = (try? JSONEncoder().encode(contacts)) ?? Data()
    }

    // MARK: - Computed Properties

    var contacts: [ChildContact] {
        get { (try? JSONDecoder().decode([ChildContact].self, from: contactsData)) ?? [] }
        set { contactsData = (try? JSONEncoder().encode(newValue)) ?? Data() }
    }

    var initials: String {
        fullName
            .split(separator: " ")
            .compactMap { $0.first.map { String($0) } }
            .joined()
            .uppercased()
    }

    var ageInYears: Int {
        Calendar.current.dateComponents([.year], from: dateOfBirth, to: .now).year ?? 0
    }
}
