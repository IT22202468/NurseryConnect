
//  IncidentReport.swift
//  NurseryConnect

import Foundation
import SwiftData

@Model
final class IncidentReport {
    var id: UUID
    private(set) var timestamp: Date
    var category: IncidentCategory
    var locationDescription: String
    var descriptionText: String
    var immediateActionTaken: String
    var witnesses: String
    var status: IncidentStatus
    var photoEvidenceData: Data?
    var severityLevel: SeverityLevel

    @Relationship(deleteRule: .cascade, inverse: \BodyMapMarker.incident)
    var bodyMapMarkers: [BodyMapMarker] = []

    var child: Child?

    init(
        id: UUID = UUID(),
        category: IncidentCategory,
        locationDescription: String,
        descriptionText: String,
        immediateActionTaken: String = "",
        witnesses: String = "",
        status: IncidentStatus = .pendingReview,
        photoEvidenceData: Data? = nil,
        severityLevel: SeverityLevel = .minor,
        child: Child? = nil
    ) {
        self.id = id
        self.timestamp = .now
        self.category = category
        self.locationDescription = locationDescription
        self.descriptionText = descriptionText
        self.immediateActionTaken = immediateActionTaken
        self.witnesses = witnesses
        self.status = status
        self.photoEvidenceData = photoEvidenceData
        self.severityLevel = severityLevel
        self.child = child
    }

    // MARK: - Computed Properties

    /// True when the incident has been in `pendingReview` for more than 2 hours.
    var isOverdue: Bool {
        guard status == .pendingReview else { return false }
        return Date.now.timeIntervalSince(timestamp) > 2 * 3600
    }
}
