import Foundation
import SwiftData
import Observation

// MARK: - Body Map Annotation

struct BodyMapAnnotation: Codable, Identifiable {
    var id: UUID = UUID()
    var x: Float
    var y: Float
    var side: BodySide
    var note: String
}

// MARK: - IncidentViewModel

@Observable
final class IncidentViewModel {
    var selectedChildId: UUID? = nil
    var selectedChildName: String = ""
    var location: String = ""
    var category: IncidentCategory = .accidentMinor
    var incidentDescription: String = ""
    var immediateAction: String = ""
    var witnesses: String = ""
    var confirmAccurate: Bool = false

    var annotations: [BodyMapAnnotation] = []
    var currentBodySide: BodySide = .front

    var validationError: String? = nil

    // MARK: - Section Completion

    var section0Complete: Bool {
        selectedChildId != nil
            && !location.trimmingCharacters(in: .whitespaces).isEmpty
            && !incidentDescription.trimmingCharacters(in: .whitespaces).isEmpty
            && !immediateAction.trimmingCharacters(in: .whitespaces).isEmpty
    }

    var section1Complete: Bool {
        true // Body map is optional
    }

    var section2Complete: Bool {
        confirmAccurate
    }

    // MARK: - Submit

    func submitReport(keyworkerId: UUID, context: ModelContext) -> Bool {
        if selectedChildId == nil {
            validationError = "Please select a child."
            return false
        }
        if location.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            validationError = "Please enter the incident location."
            return false
        }
        if incidentDescription.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            validationError = "Please describe what happened."
            return false
        }
        if immediateAction.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            validationError = "Please describe the immediate action taken."
            return false
        }
        if !confirmAccurate {
            validationError = "Please check the confirmation box in the Review section below before submitting."
            return false
        }

        let data = (try? JSONEncoder().encode(annotations)) ?? Data()

        let report = IncidentReport(
            childId: selectedChildId!,
            childName: selectedChildName,
            keyworkerId: keyworkerId,
            location: location,
            category: category,
            incidentDescription: incidentDescription,
            immediateAction: immediateAction,
            witnesses: witnesses,
            bodyMapData: data,
            status: "submitted"
        )
        context.insert(report)
        do {
            try context.save()
            validationError = nil
            return true
        } catch {
            validationError = "Failed to save report: \(error.localizedDescription)"
            return false
        }
    }
}
