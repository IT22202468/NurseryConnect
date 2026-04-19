import SwiftUI

enum AppPhase {
    case splash, login, main
}

struct AppRootView: View {
    @State private var phase: AppPhase = .splash

    var body: some View {
        ZStack {
            switch phase {
            case .splash:
                SplashScreenView {
                    withAnimation(.easeInOut(duration: 0.4)) {
                        phase = .login
                    }
                }
                .transition(.opacity)

            case .login:
                LoginView {
                    withAnimation(.easeInOut(duration: 0.4)) {
                        phase = .main
                    }
                }
                .transition(.opacity)

            case .main:
                MainTabView()
                    .transition(.opacity)
            }
        }
        .preferredColorScheme(.light)
    }
}
