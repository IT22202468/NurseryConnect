import SwiftUI

struct LoginView: View {
    let completion: () -> Void

    @State private var viewModel = AuthViewModel()
    @State private var cardAppeared = false
    @State private var logoAppeared = false
    @FocusState private var focusedField: Field?

    enum Field { case email, password }

    var body: some View {
        ZStack {
            Color.appBackground.ignoresSafeArea()

            ScrollView {
                VStack(spacing: 28) {
                    // Logo
                    VStack(spacing: 6) {
//                        Image(systemName: "leaf.circle.fill")
//                            .resizable()
//                            .scaledToFit()
//                            .frame(width: 80, height: 80)
//                            .foregroundStyle(Color.brandPurple)
                        
                        Image("Applogo")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 80, height: 80)
                            .foregroundStyle(Color.brandPurple)

//                        Text("NurseryConnect")
//                            .font(.system(.title3, design: .rounded).weight(.bold))
//                            .foregroundStyle(Color.brandPurple)
                    }
                    .padding(.top, 56)
                    .opacity(logoAppeared ? 1 : 0)
                    .scaleEffect(logoAppeared ? 1 : 0.85)

                    // Card
                    VStack(alignment: .leading, spacing: 20) {
                        VStack(alignment: .leading, spacing: 4) {
                            Text("Welcome back")
                                .font(.appTitle)
                                .foregroundStyle(.black)
                            Text("Sign in to your account")
                                .font(.captionText)
                                .foregroundStyle(.gray)
                        }

                        // Error banner
                        if viewModel.showError {
                            HStack(spacing: 10) {
                                Image(systemName: "exclamationmark.circle.fill")
                                    .foregroundStyle(.white)
                                    .font(.system(size: 16, weight: .semibold))
                                Text(viewModel.errorMessage)
                                    .font(.captionText)
                                    .foregroundStyle(.white)
                                Spacer()
                            }
                            .padding(12)
                            .background(Color.red.opacity(0.85))
                            .clipShape(RoundedRectangle(cornerRadius: 10))
                            .transition(.move(edge: .top).combined(with: .opacity))
                        }

                        // Email field
                        fieldRow(
                            icon: "envelope",
                            isFocused: focusedField == .email,
                            hasError: viewModel.showError
                        ) {
                            TextField("Email address", text: $viewModel.email)
                                .keyboardType(.emailAddress)
                                .autocorrectionDisabled()
                                .textInputAutocapitalization(.never)
                                .focused($focusedField, equals: .email)
                                .onChange(of: viewModel.email) { _, _ in viewModel.clearError() }
                        }

                        // Password field
                        fieldRow(
                            icon: "lock",
                            isFocused: focusedField == .password,
                            hasError: viewModel.showError
                        ) {
                            SecureField("Password", text: $viewModel.password)
                                .focused($focusedField, equals: .password)
                                .onChange(of: viewModel.password) { _, _ in viewModel.clearError() }
                        }

                        // Sign In button
                        Button {
                            focusedField = nil
                            withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                                viewModel.signIn { completion() }
                            }
                        } label: {
                            Text("Sign In")
                                .purpleButtonStyle()
                        }
                        .pressEffect()
                    }
                    .padding(24)
                    .cardStyle()
                    .padding(.horizontal, 24)
                    .opacity(cardAppeared ? 1 : 0)
                    .offset(y: cardAppeared ? 0 : 24)

                    Spacer(minLength: 40)
                }
            }
        }
        .animation(.spring(response: 0.35, dampingFraction: 0.7), value: viewModel.showError)
        .onAppear {
            withAnimation(.spring(response: 0.55, dampingFraction: 0.8)) {
                logoAppeared = true
            }
            withAnimation(.spring(response: 0.55, dampingFraction: 0.8).delay(0.15)) {
                cardAppeared = true
            }
        }
    }

    @ViewBuilder
    private func fieldRow<Content: View>(icon: String, isFocused: Bool, hasError: Bool = false, @ViewBuilder content: () -> Content) -> some View {
        HStack(spacing: 10) {
            Image(systemName: icon)
                .foregroundStyle(hasError ? Color.red : isFocused ? Color.brandPurple : Color.gray.opacity(0.6))
                .frame(width: 18)
                .animation(.easeInOut(duration: 0.2), value: isFocused)
                .animation(.easeInOut(duration: 0.2), value: hasError)
            content()
        }
        .padding(14)
        .background(Color.white)
        .clipShape(RoundedRectangle(cornerRadius: 12))
        .overlay(
            RoundedRectangle(cornerRadius: 12)
                .stroke(
                    hasError ? Color.red.opacity(0.6) : isFocused ? Color.brandPurple : Color.gray.opacity(0.15),
                    lineWidth: (hasError || isFocused) ? 2 : 1
                )
                .animation(.easeInOut(duration: 0.2), value: isFocused)
                .animation(.easeInOut(duration: 0.2), value: hasError)
        )
    }
}
