import Foundation
import SwiftUI
import Observation

@Observable
final class AuthViewModel {
    var email: String = "keyworker@littlestars.co.uk"
    var password: String = "Stars2024!" {
        didSet { if showError { clearError() } }
    }
    var errorMessage: String = ""
    var showError: Bool = false

    func clearError() {
        withAnimation(.easeOut(duration: 0.2)) { showError = false }
    }

    private let validEmail    = "keyworker@littlestars.co.uk"
    private let validPassword = "Stars2024!"

    func signIn(completion: () -> Void) {
        let trimmedEmail = email.trimmingCharacters(in: .whitespaces)

        if trimmedEmail.isEmpty && password.isEmpty {
            errorMessage = "Please enter your email and password."
            showErrorAnimated()
            return
        }
        if trimmedEmail.isEmpty {
            errorMessage = "Please enter your email address."
            showErrorAnimated()
            return
        }
        if password.isEmpty {
            errorMessage = "Please enter your password."
            showErrorAnimated()
            return
        }
        if !trimmedEmail.contains("@") || !trimmedEmail.contains(".") {
            errorMessage = "Please enter a valid email address."
            showErrorAnimated()
            return
        }
        if trimmedEmail == validEmail && password == validPassword {
            showError = false
            completion()
        } else {
            errorMessage = "Incorrect email or password. Please try again."
            showErrorAnimated()
        }
    }

    private func showErrorAnimated() {
        withAnimation(.spring(response: 0.3, dampingFraction: 0.6)) {
            showError = true
        }
    }
}
