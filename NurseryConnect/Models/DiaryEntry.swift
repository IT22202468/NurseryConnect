import Foundation
import SwiftData

@Model
final class DiaryEntry {
    var id: UUID
    private(set) var timestamp: Date
    var childId: UUID
    var keyworkerId: UUID
    var entryType: EntryType
    var notes: String

    // Activity fields
    var activityName: String?
    var eyfsArea: EYFSArea?
    var durationMinutes: Int?

    // Meal fields
    var mealType: String?
    var foodsOffered: String?
    var consumptionLevel: ConsumptionLevel?
    var fluidVolumeMl: Int?
    var fluidType: String?
    var allergenAcknowledged: Bool?

    // Nap fields
    var napStartTime: Date?
    var napEndTime: Date?
    var sleepPosition: SleepPosition?

    // Nappy fields
    var nappyType: NappyType?
    var nappyConcerns: Bool?

    // Mood field
    var moodRating: Int?

    init(
        id: UUID = UUID(),
        childId: UUID,
        keyworkerId: UUID,
        entryType: EntryType,
        notes: String = "",
        _timestamp: Date = .now
    ) {
        self.id = id
        self.timestamp = _timestamp
        self.childId = childId
        self.keyworkerId = keyworkerId
        self.entryType = entryType
        self.notes = notes
    }

    // MARK: - Computed Properties

    var summaryText: String {
        switch entryType {
        case .activity:
            return activityName.map { "Activity: \($0)" } ?? "Activity"
        case .meal:
            let food = foodsOffered ?? "not recorded"
            let type = mealType ?? "Meal"
            return "\(type) — \(food)"
        case .nap:
            let fmt = DateFormatter()
            fmt.dateFormat = "HH:mm"
            if let start = napStartTime, let end = napEndTime {
                return "Nap \(fmt.string(from: start))–\(fmt.string(from: end))"
            }
            return "Nap"
        case .nappy:
            return "Nappy change" + (nappyType.map { " — \($0.displayName)" } ?? "")
        case .mood:
            switch moodRating {
            case 1: return "Mood: Happy 😊"
            case 2: return "Mood: Unsettled 😕"
            case 3: return "Mood: Poorly 🤒"
            default: return "Mood check"
            }
        case .arrival:
            return "Arrived"
        case .departure:
            return "Departed"
        }
    }

    var napDurationMinutes: Int? {
        guard let start = napStartTime, let end = napEndTime else { return nil }
        return Int(end.timeIntervalSince(start) / 60)
    }
}
