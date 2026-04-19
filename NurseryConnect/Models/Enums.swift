import SwiftUI

// MARK: - Entry Type

enum EntryType: String, Codable, CaseIterable {
    case activity, meal, nap, nappy, mood, arrival, departure

    var displayName: String {
        switch self {
        case .activity:  return "Activity"
        case .meal:      return "Meal"
        case .nap:       return "Nap"
        case .nappy:     return "Nappy"
        case .mood:      return "Mood"
        case .arrival:   return "Arrival"
        case .departure: return "Departure"
        }
    }

    var sfSymbol: String {
        switch self {
        case .activity:  return "figure.play"
        case .meal:      return "fork.knife"
        case .nap:       return "moon.zzz.fill"
        case .nappy:     return "drop.fill"
        case .mood:      return "face.smiling"
        case .arrival:   return "arrow.right.circle.fill"
        case .departure: return "arrow.left.circle.fill"
        }
    }

    var color: Color {
        switch self {
        case .activity:  return Color.brandPurple
        case .meal:      return Color.brandPink
        case .nap:       return .blue
        case .nappy:     return .green
        case .mood:      return .orange
        case .arrival:   return .teal
        case .departure: return .gray
        }
    }
}

// MARK: - Consumption Level

enum ConsumptionLevel: String, Codable, CaseIterable {
    case all, most, half, little, none, refused

    var displayName: String {
        switch self {
        case .all:     return "All"
        case .most:    return "Most"
        case .half:    return "Half"
        case .little:  return "Little"
        case .none:    return "None"
        case .refused: return "Refused"
        }
    }
}

// MARK: - Sleep Position

enum SleepPosition: String, Codable, CaseIterable {
    case back, side

    var displayName: String {
        switch self {
        case .back: return "Back"
        case .side: return "Side"
        }
    }
}

// MARK: - Nappy Type

enum NappyType: String, Codable, CaseIterable {
    case wet, dirty, both, none

    var displayName: String {
        switch self {
        case .wet:   return "Wet"
        case .dirty: return "Dirty"
        case .both:  return "Both"
        case .none:  return "None"
        }
    }
}

// MARK: - EYFS Area

enum EYFSArea: String, Codable, CaseIterable {
    case communication
    case physical
    case personalSocial
    case literacy
    case mathematics
    case understandingWorld
    case expressiveArts

    var displayName: String {
        switch self {
        case .communication:      return "Communication & Language"
        case .physical:           return "Physical Development"
        case .personalSocial:     return "Personal, Social & Emotional"
        case .literacy:           return "Literacy"
        case .mathematics:        return "Mathematics"
        case .understandingWorld: return "Understanding the World"
        case .expressiveArts:     return "Expressive Arts & Design"
        }
    }
}

// MARK: - Incident Category

enum IncidentCategory: String, Codable, CaseIterable {
    case accidentMinor
    case accidentFirstAid
    case safeguardingConcern
    case nearMiss
    case allergicReaction
    case medicalIncident

    var displayName: String {
        switch self {
        case .accidentMinor:       return "Accident Minor"
        case .accidentFirstAid:    return "Accident First Aid"
        case .safeguardingConcern: return "Safeguarding Concern"
        case .nearMiss:            return "Near Miss"
        case .allergicReaction:    return "Allergic Reaction"
        case .medicalIncident:     return "Medical Incident"
        }
    }
}

// MARK: - Body Side

enum BodySide: String, Codable, CaseIterable {
    case front, back

    var displayName: String {
        switch self {
        case .front: return "Front"
        case .back:  return "Back"
        }
    }
}
