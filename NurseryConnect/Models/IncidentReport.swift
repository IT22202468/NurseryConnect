import Foundation
import SwiftData

@Model
final class IncidentReport {
    var id: UUID
    private(set) var timestamp: Date
    var childId: UUID
    var childName: String
    var keyworkerId: UUID
    var location: String
    var category: IncidentCategory
    var incidentDescription: String
    var immediateAction: String
    var witnesses: String
    var bodyMapData: Data
    var status: String
    var sosActivated: Bool

    init(
        id: UUID = UUID(),
        childId: UUID,
        childName: String,
        keyworkerId: UUID,
        location: String = "",
        category: IncidentCategory = .accidentMinor,
        incidentDescription: String = "",
        immediateAction: String = "",
        witnesses: String = "",
        bodyMapData: Data = Data(),
        status: String = "draft",
        sosActivated: Bool = false
    ) {
        self.id = id
        self.timestamp = .now
        self.childId = childId
        self.childName = childName
        self.keyworkerId = keyworkerId
        self.location = location
        self.category = category
        self.incidentDescription = incidentDescription
        self.immediateAction = immediateAction
        self.witnesses = witnesses
        self.bodyMapData = bodyMapData
        self.status = status
        self.sosActivated = sosActivated
    }
}
