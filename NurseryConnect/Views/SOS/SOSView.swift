import SwiftUI
import UIKit

struct SOSView: View {
    @Environment(\.dismiss) private var dismiss
    @State private var callingService: String? = nil
    @State private var cardAppeared = false

    var body: some View {
        ZStack {
            Color.black.opacity(0.82).ignoresSafeArea()
                .onTapGesture { dismiss() }

            VStack {
                Spacer()

                VStack(spacing: 20) {
                    // Icon
                    ZStack {
                        Circle()
                            .fill(Color.red.opacity(0.12))
                            .frame(width: 80, height: 80)
                        Image(systemName: "exclamationmark.shield.fill")
                            .font(.system(size: 40, weight: .bold))
                            .foregroundStyle(.red)
                    }

                    VStack(spacing: 4) {
                        Text("Emergency")
                            .font(.system(size: 26, weight: .bold, design: .rounded))
                            .foregroundStyle(.black)
                        Text("Tap a button to call emergency services")
                            .font(.captionText)
                            .foregroundStyle(.gray)
                            .multilineTextAlignment(.center)
                    }

                    // Calling status
                    if let service = callingService {
                        HStack(spacing: 8) {
                            Image(systemName: "phone.fill")
                                .foregroundStyle(Color.brandPurple)
                            Text("Calling \(service)...")
                                .font(.system(size: 14, weight: .semibold))
                                .foregroundStyle(Color.brandPurple)
                        }
                        .transition(.opacity.combined(with: .scale(scale: 0.9)))
                    }

                    Divider()

                    VStack(spacing: 10) {
                        callButton(
                            icon: "cross.case.fill",
                            label: "Call Ambulance",
                            color: Color(hex: "FF3B30"),
                            service: "Ambulance"
                        )
                        callButton(
                            icon: "flame.fill",
                            label: "Call Fire Brigade",
                            color: Color(hex: "FF9500"),
                            service: "Fire Brigade"
                        )
                        callButton(
                            icon: "building.2.fill",
                            label: "Call Hospital (A&E)",
                            color: Color(hex: "007AFF"),
                            service: "Hospital (A&E)"
                        )
                    }

                    // Cancel
                    Button { dismiss() } label: {
                        Text("Cancel")
                            .font(.system(size: 16, weight: .semibold))
                            .foregroundStyle(.gray)
                            .frame(maxWidth: .infinity)
                            .frame(height: 52)
                            .background(Color.gray.opacity(0.1))
                            .clipShape(RoundedRectangle(cornerRadius: 14))
                    }
                    .pressEffect()
                }
                .padding(24)
                .background(Color.white)
                .clipShape(RoundedRectangle(cornerRadius: 28))
                .shadow(color: .black.opacity(0.2), radius: 30, x: 0, y: 10)
                .padding(.horizontal, 20)
                .scaleEffect(cardAppeared ? 1 : 0.88)
                .opacity(cardAppeared ? 1 : 0)
                .offset(y: cardAppeared ? 0 : 30)

                Spacer()
            }
        }
        .animation(.spring(response: 0.35, dampingFraction: 0.75), value: callingService)
        .onAppear {
            withAnimation(.spring(response: 0.45, dampingFraction: 0.75)) {
                cardAppeared = true
            }
        }
    }

    @ViewBuilder
    private func callButton(icon: String, label: String, color: Color, service: String) -> some View {
        Button {
            withAnimation { callingService = service }
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                UIApplication.shared.open(URL(string: "tel://999")!)
            }
        } label: {
            HStack(spacing: 12) {
                Image(systemName: icon)
                    .font(.system(size: 18, weight: .semibold))
                Text(label)
                    .font(.system(size: 16, weight: .bold))
            }
            .foregroundStyle(.white)
            .frame(maxWidth: .infinity)
            .frame(height: 58)
            .background(color)
            .clipShape(RoundedRectangle(cornerRadius: 14))
        }
        .pressEffect()
    }
}
