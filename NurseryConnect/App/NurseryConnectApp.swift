import SwiftUI
import SwiftData

@main
struct NurseryConnectApp: App {
    var body: some Scene {
        WindowGroup {
            AppRootView()
        }
        .modelContainer(
            for: [Keyworker.self, Child.self, DiaryEntry.self, IncidentReport.self],
            isAutosaveEnabled: true
        ) { result in
            if case .success(let container) = result {
                SeedData.insertIfNeeded(context: container.mainContext)
            }
        }
    }
}
