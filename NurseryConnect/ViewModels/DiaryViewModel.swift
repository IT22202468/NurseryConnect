import Foundation
import SwiftUI
import SwiftData
import Observation

@Observable
final class DiaryViewModel {
    var showLogCard: Bool = false
    var selectedEntryType: EntryType = .activity

    // Activity
    var activityName: String = ""
    var eyfsArea: EYFSArea = .communication
    var durationMinutes: Int = 15

    // Meal
    var mealType: String = "Breakfast"
    var foodsOffered: String = ""
    var consumptionLevel: ConsumptionLevel = .all
    var fluidVolumeMl: Int = 0
    var fluidType: String = "Water"
    var allergenAcknowledged: Bool = false

    // Nap
    var napStartTime: Date = Calendar.current.date(bySettingHour: 12, minute: 0, second: 0, of: .now)!
    var napEndTime: Date   = Calendar.current.date(bySettingHour: 13, minute: 0, second: 0, of: .now)!
    var sleepPosition: SleepPosition = .back

    // Nappy
    var nappyType: NappyType = .wet
    var nappyConcerns: Bool = false
    var concernsNotes: String = ""

    // Mood
    var moodRating: Int = 1

    // Shared
    var notes: String = ""
    var validationError: String? = nil

    // MARK: - Validation

    func validate(child: Child) -> Bool {
        switch selectedEntryType {
        case .activity:
            if activityName.trimmingCharacters(in: .whitespaces).isEmpty {
                validationError = "Please enter an activity name."
                return false
            }
        case .meal:
            if foodsOffered.trimmingCharacters(in: .whitespaces).isEmpty {
                validationError = "Please describe the foods offered."
                return false
            }
            if !child.allergens.isEmpty && !allergenAcknowledged {
                validationError = "Please acknowledge the allergen check before saving."
                return false
            }
        case .nap:
            if napEndTime <= napStartTime {
                validationError = "End time must be after start time."
                return false
            }
        case .nappy:
            if nappyConcerns && concernsNotes.trimmingCharacters(in: .whitespaces).isEmpty {
                validationError = "Please describe the concern."
                return false
            }
        case .mood, .arrival, .departure:
            break
        }
        validationError = nil
        return true
    }

    // MARK: - Save

    func saveEntry(child: Child, keyworkerId: UUID, context: ModelContext) {
        let entry = DiaryEntry(
            childId: child.id,
            keyworkerId: keyworkerId,
            entryType: selectedEntryType,
            notes: notes
        )

        switch selectedEntryType {
        case .activity:
            entry.activityName = activityName.isEmpty ? nil : activityName
            entry.eyfsArea = eyfsArea
            entry.durationMinutes = durationMinutes
        case .meal:
            entry.mealType = mealType
            entry.foodsOffered = foodsOffered.isEmpty ? nil : foodsOffered
            entry.consumptionLevel = consumptionLevel
            entry.fluidVolumeMl = fluidVolumeMl
            entry.fluidType = fluidType
            entry.allergenAcknowledged = allergenAcknowledged
        case .nap:
            entry.napStartTime = napStartTime
            entry.napEndTime = napEndTime
            entry.sleepPosition = sleepPosition
        case .nappy:
            entry.nappyType = nappyType
            entry.nappyConcerns = nappyConcerns
        case .mood:
            entry.moodRating = moodRating
        case .arrival, .departure:
            break
        }

        context.insert(entry)
        try? context.save()
        showLogCard = false
        reset()
    }

    // MARK: - Reset

    func reset() {
        selectedEntryType = .activity
        activityName = ""
        eyfsArea = .communication
        durationMinutes = 15
        mealType = "Breakfast"
        foodsOffered = ""
        consumptionLevel = .all
        fluidVolumeMl = 0
        fluidType = "Water"
        allergenAcknowledged = false
        napStartTime = Calendar.current.date(bySettingHour: 12, minute: 0, second: 0, of: .now)!
        napEndTime   = Calendar.current.date(bySettingHour: 13, minute: 0, second: 0, of: .now)!
        sleepPosition = .back
        nappyType = .wet
        nappyConcerns = false
        concernsNotes = ""
        moodRating = 1
        notes = ""
        validationError = nil
    }
}
