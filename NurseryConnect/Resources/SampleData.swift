//
//  SampleData.swift
//  NurseryConnect
//
//  Created by Nipun Jayasinghe on 2026-03-18.
//

import SwiftData
import Foundation

struct SampleData {
    static func populate(context: ModelContext) {
        // Check if data already exists
        let descriptor = FetchDescriptor<Child>()
        guard (try? context.fetchCount(descriptor)) == 0 else { return }
        
        let oliver = Child(
            fullName: "Oliver Thompson",
            preferredName: "Ollie",
            dateOfBirth: Calendar.current.date(
                byAdding: .year, value: -3, to: Date()
            )!,
            roomName: "Butterfly Room",
            allergies: ["Peanuts"],
            dietaryRequirements: "",
            medicalNotes: "No known conditions",
            photographyConsent: true,
            parentName: "James Thompson",
            parentContact: "07700 900111",
            emergencyContact: "Mary Thompson - 07700 900222"
        )
        context.insert(oliver)
        
        // Add more children, diary entries, incidents...
        // Use Claude Code to generate the full sample data
        
        try? context.save()
    }
}
