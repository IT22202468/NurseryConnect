import SwiftUI

struct AllergenBadgeView: View {
    let allergen: String

    private var icon: String {
        switch allergen.lowercased() {
        case let s where s.contains("milk") || s.contains("dairy"):
            return "drop.fill"
        case let s where s.contains("egg"):
            return "oval.fill"
        case let s where s.contains("nut") || s.contains("peanut"):
            return "leaf.fill"
        case let s where s.contains("fish") || s.contains("shellfish"):
            return "fish.fill"
        case let s where s.contains("gluten") || s.contains("wheat"):
            return "wind"
        default:
            return "exclamationmark.circle.fill"
        }
    }

    var body: some View {
        HStack(spacing: 5) {
            Image(systemName: icon)
                .font(.system(size: 10, weight: .semibold))
                .foregroundStyle(Color.brandPurple)
            Text(allergen)
                .font(.captionText)
                .foregroundStyle(.black)
        }
        .padding(.horizontal, 10)
        .padding(.vertical, 5)
        .background(Color.brandPurple.opacity(0.1))
        .clipShape(Capsule())
        .overlay(Capsule().stroke(Color.brandPurple.opacity(0.25), lineWidth: 1))
    }
}
