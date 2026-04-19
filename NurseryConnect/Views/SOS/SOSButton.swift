import SwiftUI

struct SOSButton: View {
    let action: () -> Void

    @State private var pulseScale: CGFloat = 1.0
    @State private var pulseOpacity: Double = 0.7
    @State private var isPressed = false

    var body: some View {
        ZStack {
            // Pulsing ring behind button
            Circle()
                .stroke(Color.red.opacity(0.6), lineWidth: 2.5)
                .frame(width: 60, height: 60)
                .scaleEffect(pulseScale)
                .opacity(pulseOpacity)

            // Main button
            Button(action: action) {
                ZStack {
                    Circle()
                        .fill(Color.red)
                        .frame(width: 56, height: 56)
                        .shadow(color: Color.red.opacity(0.4), radius: 8, x: 0, y: 4)

                    VStack(spacing: 2) {
                        Image(systemName: "exclamationmark.triangle.fill")
                            .font(.system(size: 18, weight: .bold))
                            .foregroundStyle(.white)
                        Text("SOS")
                            .font(.system(size: 9, weight: .heavy, design: .rounded))
                            .foregroundStyle(.white)
                    }
                }
            }
            .scaleEffect(isPressed ? 0.93 : 1.0)
            .simultaneousGesture(
                DragGesture(minimumDistance: 0)
                    .onChanged { _ in
                        withAnimation(.spring(response: 0.2, dampingFraction: 0.6)) { isPressed = true }
                    }
                    .onEnded { _ in
                        withAnimation(.spring(response: 0.3, dampingFraction: 0.5)) { isPressed = false }
                    }
            )
        }
        .onAppear {
            withAnimation(.easeOut(duration: 1.4).repeatForever(autoreverses: false)) {
                pulseScale   = 1.6
                pulseOpacity = 0
            }
        }
    }
}
