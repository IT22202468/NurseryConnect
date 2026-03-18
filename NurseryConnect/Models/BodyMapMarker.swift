
//  BodyMapMarker.swift
//  NurseryConnect

import Foundation
import SwiftData

@Model
final class BodyMapMarker {
    var id: UUID
    /// Normalised horizontal position on the body diagram (0.0 = left edge, 1.0 = right edge).
    var xPosition: Double
    /// Normalised vertical position on the body diagram (0.0 = top, 1.0 = bottom).
    var yPosition: Double
    var bodyView: BodyView
    var injuryDescription: String

    var incident: IncidentReport?

    init(
        id: UUID = UUID(),
        xPosition: Double,
        yPosition: Double,
        bodyView: BodyView,
        injuryDescription: String,
        incident: IncidentReport? = nil
    ) {
        precondition((0.0...1.0).contains(xPosition), "xPosition must be in 0–1")
        precondition((0.0...1.0).contains(yPosition), "yPosition must be in 0–1")
        self.id = id
        self.xPosition = xPosition
        self.yPosition = yPosition
        self.bodyView = bodyView
        self.injuryDescription = injuryDescription
        self.incident = incident
    }
}
