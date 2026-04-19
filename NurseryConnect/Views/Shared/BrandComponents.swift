import SwiftUI

// MARK: - Brand Colors

extension Color {
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let r = Double((int >> 16) & 0xFF) / 255.0
        let g = Double((int >> 8) & 0xFF) / 255.0
        let b = Double(int & 0xFF) / 255.0
        self.init(red: r, green: g, blue: b)
    }

    /// Used only on the Splash screen
    static let brandYellow = Color(hex: "FAF29B")
    /// Primary accent — buttons, active states, section headers
    static let brandPurple = Color(hex: "868EF1")
    /// Secondary accent — allergen badges, SOS, alert highlights
    static let brandPink   = Color(hex: "FFA6F2")
    /// Page background for all screens except Splash
    static let appBackground = Color(.systemGroupedBackground)
}

// MARK: - Typography

extension Font {
    static let appTitle    = Font.system(.title2, design: .rounded).weight(.semibold)
    static let cardTitle   = Font.system(.headline, design: .rounded).weight(.semibold)
    static let bodyText    = Font.system(size: 15, weight: .regular, design: .default)
    static let captionText = Font.system(size: 12, weight: .medium, design: .default)
    static let buttonLabel = Font.system(.subheadline, design: .rounded).weight(.semibold)
}

// MARK: - CardStyle ViewModifier

struct CardStyle: ViewModifier {
    func body(content: Content) -> some View {
        content
            .background(Color.white)
            .clipShape(RoundedRectangle(cornerRadius: 20))
            .shadow(color: .black.opacity(0.06), radius: 10, x: 0, y: 4)
    }
}

extension View {
    func cardStyle() -> some View {
        modifier(CardStyle())
    }
}

// MARK: - PurpleButton ViewModifier

struct PurpleButton: ViewModifier {
    func body(content: Content) -> some View {
        content
            .font(.buttonLabel)
            .foregroundStyle(.white)
            .frame(maxWidth: .infinity)
            .padding(.vertical, 16)
            .background(Color.brandPurple)
            .clipShape(RoundedRectangle(cornerRadius: 14))
    }
}

extension View {
    func purpleButtonStyle() -> some View {
        modifier(PurpleButton())
    }
}

// MARK: - Press Effect

struct PressEffect: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .scaleEffect(configuration.isPressed ? 0.96 : 1.0)
            .opacity(configuration.isPressed ? 0.85 : 1.0)
            .animation(.spring(response: 0.25, dampingFraction: 0.7), value: configuration.isPressed)
    }
}

extension View {
    /// Apply press-scale feedback to any tappable view
    func pressEffect() -> some View {
        self.buttonStyle(PressEffect())
    }
}

// MARK: - Appear Animation Helpers

extension View {
    /// Slide-up + fade-in on appear with optional delay
    func slideUpOnAppear(delay: Double = 0) -> some View {
        modifier(SlideUpOnAppear(delay: delay))
    }
}

struct SlideUpOnAppear: ViewModifier {
    let delay: Double
    @State private var appeared = false

    func body(content: Content) -> some View {
        content
            .opacity(appeared ? 1 : 0)
            .offset(y: appeared ? 0 : 18)
            .onAppear {
                withAnimation(.spring(response: 0.5, dampingFraction: 0.75).delay(delay)) {
                    appeared = true
                }
            }
    }
}
