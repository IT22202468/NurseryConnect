
//  Enums.swift
//  NurseryConnect

import SwiftUI

// MARK: - DiaryEntry Enums

enum EntryType: String, Codable, CaseIterable {
    case activity, sleep, meal, nappy, wellbeing, milestone

    var displayName: String {
        switch self {
        case .activity:  return "Activity"
        case .sleep:     return "Sleep"
        case .meal:      return "Meal"
        case .nappy:     return "Nappy"
        case .wellbeing: return "Wellbeing"
        case .milestone: return "Milestone"
        }
    }

    var icon: String {
        switch self {
        case .activity:  return "paintpalette.fill"
        case .sleep:     return "moon.fill"
        case .meal:      return "fork.knife"
        case .nappy:     return "trash.fill"
        case .wellbeing: return "heart.fill"
        case .milestone: return "star.fill"
        }
    }

    var color: Color {
        switch self {
        case .activity:  return .orange
        case .sleep:     return .indigo
        case .meal:      return .green
        case .nappy:     return .brown
        case .wellbeing: return .pink
        case .milestone: return .yellow
        }
    }
}

enum Mood: String, Codable, CaseIterable {
    case happy, content, unsettled, tired, unwell

    var displayName: String {
        switch self {
        case .happy:     return "Happy"
        case .content:   return "Content"
        case .unsettled: return "Unsettled"
        case .tired:     return "Tired"
        case .unwell:    return "Unwell"
        }
    }

    var icon: String {
        switch self {
        case .happy:     return "face.smiling.fill"
        case .content:   return "face.smiling"
        case .unsettled: return "face.dashed"
        case .tired:     return "zzz"
        case .unwell:    return "thermometer.medium"
        }
    }

    var color: Color {
        switch self {
        case .happy:     return .green
        case .content:   return .mint
        case .unsettled: return .orange
        case .tired:     return .indigo
        case .unwell:    return .red
        }
    }
}

enum PortionSize: String, Codable, CaseIterable {
    case none, quarter, half, threeQuarters, all

    var displayName: String {
        switch self {
        case .none:          return "None"
        case .quarter:       return "¼"
        case .half:          return "½"
        case .threeQuarters: return "¾"
        case .all:           return "All"
        }
    }

    var icon: String {
        switch self {
        case .none:          return "circle"
        case .quarter:       return "circle.lefthalf.filled"
        case .half:          return "circle.bottomhalf.filled"
        case .threeQuarters: return "circle.righthalf.filled"
        case .all:           return "circle.fill"
        }
    }
}

enum SleepPosition: String, Codable, CaseIterable {
    case back, side, front

    var displayName: String {
        switch self {
        case .back:  return "On Back"
        case .side:  return "On Side"
        case .front: return "On Front"
        }
    }

    var icon: String {
        switch self {
        case .back:  return "arrow.up.circle.fill"
        case .side:  return "arrow.right.circle.fill"
        case .front: return "arrow.down.circle.fill"
        }
    }
}

enum NappyType: String, Codable, CaseIterable {
    case wet, soiled, both, dry

    var displayName: String {
        switch self {
        case .wet:    return "Wet"
        case .soiled: return "Soiled"
        case .both:   return "Wet & Soiled"
        case .dry:    return "Dry"
        }
    }

    var icon: String {
        switch self {
        case .wet:    return "drop.fill"
        case .soiled: return "exclamationmark.circle.fill"
        case .both:   return "drop.circle.fill"
        case .dry:    return "checkmark.circle.fill"
        }
    }
}

enum EYFSArea: String, Codable, CaseIterable {
    case communication, physicalDevelopment, personalSocialEmotional,
         literacy, mathematics, understandingTheWorld, expressiveArts

    var displayName: String {
        switch self {
        case .communication:             return "Communication & Language"
        case .physicalDevelopment:       return "Physical Development"
        case .personalSocialEmotional:   return "Personal, Social & Emotional"
        case .literacy:                  return "Literacy"
        case .mathematics:               return "Mathematics"
        case .understandingTheWorld:     return "Understanding the World"
        case .expressiveArts:            return "Expressive Arts & Design"
        }
    }

    var icon: String {
        switch self {
        case .communication:           return "bubble.left.and.bubble.right.fill"
        case .physicalDevelopment:     return "figure.run"
        case .personalSocialEmotional: return "person.2.fill"
        case .literacy:                return "book.fill"
        case .mathematics:             return "number.circle.fill"
        case .understandingTheWorld:   return "globe"
        case .expressiveArts:          return "paintbrush.fill"
        }
    }

    var color: Color {
        switch self {
        case .communication:           return .blue
        case .physicalDevelopment:     return .green
        case .personalSocialEmotional: return .pink
        case .literacy:                return .orange
        case .mathematics:             return .purple
        case .understandingTheWorld:   return .teal
        case .expressiveArts:          return .yellow
        }
    }
}

// MARK: - Incident Enums

enum IncidentCategory: String, Codable, CaseIterable {
    case fall, bump, scrape, bite, allergicReaction, illness, behavioural, other

    var displayName: String {
        switch self {
        case .fall:             return "Fall"
        case .bump:             return "Bump"
        case .scrape:           return "Scrape"
        case .bite:             return "Bite"
        case .allergicReaction: return "Allergic Reaction"
        case .illness:          return "Illness"
        case .behavioural:      return "Behavioural"
        case .other:            return "Other"
        }
    }

    var icon: String {
        switch self {
        case .fall:             return "figure.fall"
        case .bump:             return "bolt.circle.fill"
        case .scrape:           return "bandage.fill"
        case .bite:             return "mouth.fill"
        case .allergicReaction: return "allergens"
        case .illness:          return "thermometer.medium"
        case .behavioural:      return "brain.head.profile"
        case .other:            return "ellipsis.circle.fill"
        }
    }
}

enum IncidentStatus: String, Codable, CaseIterable {
    case pendingReview, inReview, parentNotified, closed

    var displayName: String {
        switch self {
        case .pendingReview:   return "Pending Review"
        case .inReview:        return "In Review"
        case .parentNotified:  return "Parent Notified"
        case .closed:          return "Closed"
        }
    }

    var icon: String {
        switch self {
        case .pendingReview:  return "clock.fill"
        case .inReview:       return "eye.fill"
        case .parentNotified: return "bell.fill"
        case .closed:         return "checkmark.seal.fill"
        }
    }

    var color: Color {
        switch self {
        case .pendingReview:  return .orange
        case .inReview:       return .blue
        case .parentNotified: return .yellow
        case .closed:         return .green
        }
    }
}

enum SeverityLevel: String, Codable, CaseIterable {
    case minor, moderate, serious, critical

    var displayName: String {
        switch self {
        case .minor:    return "Minor"
        case .moderate: return "Moderate"
        case .serious:  return "Serious"
        case .critical: return "Critical"
        }
    }

    var icon: String {
        switch self {
        case .minor:    return "1.circle.fill"
        case .moderate: return "2.circle.fill"
        case .serious:  return "3.circle.fill"
        case .critical: return "exclamationmark.triangle.fill"
        }
    }

    var color: Color {
        switch self {
        case .minor:    return .green
        case .moderate: return .yellow
        case .serious:  return .orange
        case .critical: return .red
        }
    }
}

// MARK: - Body Map Enum

enum BodyView: String, Codable, CaseIterable {
    case front, back

    var displayName: String {
        switch self {
        case .front: return "Front"
        case .back:  return "Back"
        }
    }

    var icon: String {
        switch self {
        case .front: return "figure.stand"
        case .back:  return "figure.stand"
        }
    }
}
