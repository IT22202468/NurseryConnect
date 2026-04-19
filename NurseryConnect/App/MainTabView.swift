import SwiftUI

struct MainTabView: View {
    @State private var showSOS = false

    var body: some View {
        ZStack(alignment: .bottomTrailing) {
            TabView {
                NavigationStack {
                    ChildListView()
                }
                .tabItem {
                    Label("My Children", systemImage: "person.2.fill")
                }

                NavigationStack {
                    IncidentListView()
                }
                .tabItem {
                    Label("Incidents", systemImage: "exclamationmark.shield.fill")
                }
            }
            .tint(Color.brandPurple)

            // Persistent SOS button
            SOSButton { showSOS = true }
                .padding(.bottom, 80)
                .padding(.trailing, 20)
        }
        .fullScreenCover(isPresented: $showSOS) {
            SOSView()
        }
    }
}
