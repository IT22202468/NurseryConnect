import Foundation
import SwiftData

struct SeedData {
    static let keyworkerId = UUID(uuidString: "A1B2C3D4-E5F6-7890-ABCD-EF1234567890")!

    static func insertIfNeeded(context: ModelContext) {
        let descriptor = FetchDescriptor<Keyworker>()
        let count = (try? context.fetchCount(descriptor)) ?? 0
        guard count == 0 else { return }

        // MARK: Keyworker
        let sarah = Keyworker(
            id: keyworkerId,
            fullName: "Sarah Mitchell",
            email: "keyworker@littlestars.co.uk",
            password: "Stars2024!",
            roomName: "Room Sunflower"
        )
        context.insert(sarah)

        // MARK: Children
        let calendar = Calendar.current
        let now = Date.now

        let emmaId = UUID()
        let emma = Child(
            id: emmaId,
            fullName: "Emma Johnson",
            preferredName: "Emma",
            dateOfBirth: calendar.date(byAdding: .year, value: -3, to: now)!,
            roomName: "Room Sunflower",
            keyworkerUUID: keyworkerId,
            photoConsent: true,
            allergens: ["Milk", "Eggs"],
            contacts: [
                ChildContact(name: "Laura Johnson", relationship: "Mother", phone: "07712 345678", email: "laura.johnson@email.com"),
                ChildContact(name: "Tom Johnson", relationship: "Father", phone: "07798 654321", email: "tom.johnson@email.com")
            ]
        )
        context.insert(emma)

        let oliverId = UUID()
        let oliver = Child(
            id: oliverId,
            fullName: "Oliver Smith",
            preferredName: "Ollie",
            dateOfBirth: calendar.date(byAdding: .year, value: -4, to: now)!,
            roomName: "Room Sunflower",
            keyworkerUUID: keyworkerId,
            photoConsent: false,
            allergens: ["Nuts"],
            contacts: [
                ChildContact(name: "Rachel Smith", relationship: "Mother", phone: "07834 111222", email: "rachel.smith@email.com")
            ]
        )
        context.insert(oliver)

        let lily = Child(
            fullName: "Lily Chen",
            preferredName: "Lily",
            dateOfBirth: calendar.date(byAdding: .year, value: -2, to: now)!,
            roomName: "Room Sunflower",
            keyworkerUUID: keyworkerId,
            photoConsent: true,
            allergens: [],
            contacts: [
                ChildContact(name: "Wei Chen", relationship: "Father", phone: "07901 223344", email: "wei.chen@email.com"),
                ChildContact(name: "Mei Chen", relationship: "Mother", phone: "07901 556677")
            ]
        )
        context.insert(lily)

        // MARK: Diary entries for Emma
        let today = calendar.startOfDay(for: now)

        func time(_ h: Int, _ m: Int) -> Date {
            calendar.date(bySettingHour: h, minute: m, second: 0, of: today)!
        }

        let arrival = DiaryEntry(
            childId: emmaId,
            keyworkerId: keyworkerId,
            entryType: .arrival,
            _timestamp: time(8, 30)
        )
        context.insert(arrival)

        let breakfast = DiaryEntry(
            childId: emmaId,
            keyworkerId: keyworkerId,
            entryType: .meal,
            _timestamp: time(8, 45)
        )
        breakfast.mealType = "Breakfast"
        breakfast.foodsOffered = "Porridge and banana"
        breakfast.consumptionLevel = .most
        breakfast.fluidVolumeMl = 150
        breakfast.fluidType = "Milk"
        breakfast.allergenAcknowledged = true
        context.insert(breakfast)

        let nap = DiaryEntry(
            childId: emmaId,
            keyworkerId: keyworkerId,
            entryType: .nap,
            _timestamp: time(12, 0)
        )
        nap.napStartTime = time(12, 0)
        nap.napEndTime   = time(13, 15)
        nap.sleepPosition = .back
        context.insert(nap)

        // MARK: Incident for Oliver
        let incident = IncidentReport(
            childId: oliverId,
            childName: "Oliver Smith",
            keyworkerId: keyworkerId,
            location: "Outdoor play area",
            category: .accidentMinor,
            incidentDescription: "Oliver tripped on the grass and grazed his knee.",
            immediateAction: "Applied antiseptic and a plaster.",
            witnesses: "Jane Peters",
            status: "submitted"
        )
        context.insert(incident)

        try? context.save()
    }
}
