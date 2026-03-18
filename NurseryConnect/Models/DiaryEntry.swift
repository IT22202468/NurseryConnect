
//  DiaryEntry.swift
//  NurseryConnect

import Foundation
import SwiftData

@Model
final class DiaryEntry {
    var id: UUID
    var timestamp: Date
    var entryType: EntryType
    var title: String
    var notes: String
    var mood: Mood?
    var mealPortionConsumed: PortionSize?
    var sleepStartTime: Date?
    var sleepEndTime: Date?
    var sleepPosition: SleepPosition?
    var nappyType: NappyType?
    var photoData: Data?
    var eyfsArea: EYFSArea?

    var child: Child?

    init(
        id: UUID = UUID(),
        timestamp: Date = .now,
        entryType: EntryType,
        title: String,
        notes: String = "",
        mood: Mood? = nil,
        mealPortionConsumed: PortionSize? = nil,
        sleepStartTime: Date? = nil,
        sleepEndTime: Date? = nil,
        sleepPosition: SleepPosition? = nil,
        nappyType: NappyType? = nil,
        photoData: Data? = nil,
        eyfsArea: EYFSArea? = nil,
        child: Child? = nil
    ) {
        self.id = id
        self.timestamp = timestamp
        self.entryType = entryType
        self.title = title
        self.notes = notes
        self.mood = mood
        self.mealPortionConsumed = mealPortionConsumed
        self.sleepStartTime = sleepStartTime
        self.sleepEndTime = sleepEndTime
        self.sleepPosition = sleepPosition
        self.nappyType = nappyType
        self.photoData = photoData
        self.eyfsArea = eyfsArea
        self.child = child
    }

    // MARK: - Computed Properties

    /// Duration in minutes between sleepStartTime and sleepEndTime, if both are set.
    var sleepDurationMinutes: Int? {
        guard let start = sleepStartTime, let end = sleepEndTime else { return nil }
        return Int(end.timeIntervalSince(start) / 60)
    }
}
