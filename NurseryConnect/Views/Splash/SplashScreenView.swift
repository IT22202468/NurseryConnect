import SwiftUI

struct SplashScreenView: View {
    let completion: () -> Void

    @State private var scale: CGFloat    = 0.3
    @State private var opacity: Double   = 0.0
    @State private var offsetY: CGFloat  = 40.0
    @State private var logoScale: CGFloat = 1.0

    var body: some View {
        ZStack {
            Color.brandYellow.ignoresSafeArea()

            VStack(spacing: 8) {
//                Image(systemName: "leaf.circle.fill")
                Image("Applogo")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 180, height: 180)
                    .foregroundStyle(Color.brandPurple)
                    .scaleEffect(logoScale)

//                Text("Nursery")
//                    .font(.system(size: 32, weight: .bold, design: .rounded))
//                    .foregroundStyle(Color.brandPurple)
//
//                Text("Connect")
//                    .font(.system(size: 32, weight: .bold, design: .rounded))
//                    .foregroundStyle(Color.brandPink)
            }
            .scaleEffect(scale)
            .opacity(opacity)
            .offset(y: offsetY)
        }
        .onAppear {
            // Spring entrance
            withAnimation(.spring(response: 0.6, dampingFraction: 0.55)) {
                scale   = 1.0
                opacity = 1.0
                offsetY = 0
            }

            // Pulse at 0.8s
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.8) {
                withAnimation(.easeInOut(duration: 0.3).repeatCount(2, autoreverses: true)) {
                    logoScale = 1.07
                }
            }

            // Fade-out at 2.5s
            DispatchQueue.main.asyncAfter(deadline: .now() + 2.5) {
                withAnimation(.easeInOut(duration: 0.5)) {
                    opacity = 0
                    scale   = 1.15
                }
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                    completion()
                }
            }
        }
    }
}
