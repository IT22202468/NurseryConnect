import SwiftUI
import SwiftData

struct ChildListView: View {
    @Query(sort: \Child.fullName) private var allChildren: [Child]
    @Query private var allEntries: [DiaryEntry]
    @Query private var allIncidents: [IncidentReport]

    @State private var appeared = false

    private var children: [Child] {
        allChildren.filter { $0.keyworkerUUID == SeedData.keyworkerId }
    }

    private var todayEntries: [DiaryEntry] {
        let start = Calendar.current.startOfDay(for: .now)
        return allEntries.filter {
            $0.keyworkerId == SeedData.keyworkerId && $0.timestamp >= start
        }
    }

    private var openIncidents: [IncidentReport] {
        allIncidents.filter {
            $0.keyworkerId == SeedData.keyworkerId && $0.status == "draft"
        }
    }

    private var childrenWithAllergens: Int {
        children.filter { !$0.allergens.isEmpty }.count
    }

    var body: some View {
        ZStack {
            Color.appBackground.ignoresSafeArea()

            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    dashboardHeader
                }
                .padding(.horizontal, 16)
                .padding(.bottom, 120)
            }
        }
        .navigationTitle("My Children")
        .navigationBarTitleDisplayMode(.large)
        .onAppear {
            withAnimation(.spring(response: 0.5, dampingFraction: 0.8).delay(0.05)) {
                appeared = true
            }
        }
    }

    // MARK: - Dashboard Header

    private var dashboardHeader: some View {
        VStack(alignment: .leading, spacing: 16) {
            // Greeting
            HStack(spacing: 8) {
                
                Text("Good morning, Sarah")
                    .font(.appTitle)
                    .foregroundStyle(.black)
                
                Image(systemName: "sun.max.fill")
                    .foregroundStyle(.orange)
            }
            .padding(.top, 8)
            .slideUpOnAppear(delay: 0)

            // Welcome card
            HStack(spacing: 16) {
                VStack(alignment: .leading, spacing: 4) {
                    Text("Room Sunflower")
                        .font(.cardTitle)
                        .foregroundStyle(.black)
                    Text("\(children.count) children · \(todayEntries.count) logs today")
                        .font(.captionText)
                        .foregroundStyle(.gray)
                }
                Spacer()
                Image(systemName: "building.2.fill")
                    .font(.system(size: 28))
                    .foregroundStyle(Color.brandPurple.opacity(0.3))
            }
            .padding(16)
            .cardStyle()
            .slideUpOnAppear(delay: 0.05)

            // Stat pills
            HStack(spacing: 10) {
                statPill(value: "\(todayEntries.count)", label: "Logs Today",      icon: "checkmark.circle.fill", color: .green)
                statPill(value: "\(openIncidents.count)", label: "Open Incidents", icon: "exclamationmark.shield.fill", color: .orange)
                statPill(value: "\(childrenWithAllergens)", label: "Allergen Alerts", icon: "exclamationmark.circle.fill", color: .red)
            }
            .slideUpOnAppear(delay: 0.1)

            // Children grid
            if !children.isEmpty {
                Text("My Children")
                    .font(.cardTitle)
                    .foregroundStyle(.black)
                    .slideUpOnAppear(delay: 0.15)

                LazyVGrid(
                    columns: [GridItem(.flexible(), spacing: 12), GridItem(.flexible(), spacing: 12)],
                    spacing: 12
                ) {
                    ForEach(Array(children.enumerated()), id: \.element.id) { index, child in
                        NavigationLink(destination: ChildProfileView(child: child)) {
                            childGridCard(child: child)
                        }
                        .buttonStyle(.plain)
                        .slideUpOnAppear(delay: 0.18 + Double(index) * 0.06)
                    }
                }
            }

            // Recent activity
            if !todayEntries.isEmpty {
                Text("Recent Activity")
                    .font(.cardTitle)
                    .foregroundStyle(.black)
                    .slideUpOnAppear(delay: 0.22)

                ForEach(Array(todayEntries.suffix(3).reversed().enumerated()), id: \.element.id) { index, entry in
                    recentEntryCard(entry: entry)
                        .slideUpOnAppear(delay: 0.25 + Double(index) * 0.05)
                }
            }
        }
    }

    // MARK: - Child Grid Card

    private func childGridCard(child: Child) -> some View {
        VStack(spacing: 10) {
            ZStack {
                Circle()
                    .fill(Color.brandPurple.opacity(0.12))
                    .frame(width: 56, height: 56)
                Circle()
                    .stroke(Color.brandPurple.opacity(0.2), lineWidth: 1.5)
                    .frame(width: 56, height: 56)
                Text(child.initials)
                    .font(.system(size: 18, weight: .bold, design: .rounded))
                    .foregroundStyle(Color.brandPurple)
            }

            VStack(spacing: 2) {
                Text(child.preferredName)
                    .font(.cardTitle)
                    .foregroundStyle(.black)
                    .lineLimit(1)
                Text(child.roomName)
                    .font(.captionText)
                    .foregroundStyle(.gray)
                    .lineLimit(1)
            }

            if !child.allergens.isEmpty {
                HStack(spacing: 4) {
                    Image(systemName: "exclamationmark.circle.fill")
                        .font(.system(size: 10))
                        .foregroundStyle(.orange)
                    Text("\(child.allergens.count) allergen\(child.allergens.count == 1 ? "" : "s")")
                        .font(.system(size: 10, weight: .semibold))
                        .foregroundStyle(.orange)
                }
            }

            if !child.photoConsent {
                Label("No Photo", systemImage: "camera.slash.fill")
                    .font(.system(size: 10, weight: .semibold))
                    .foregroundStyle(.white)
                    .padding(.horizontal, 8)
                    .padding(.vertical, 4)
                    .background(Color.red)
                    .clipShape(Capsule())
            }
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 16)
        .padding(.horizontal, 10)
        .cardStyle()
    }

    // MARK: - Stat Pill

    private func statPill(value: String, label: String, icon: String, color: Color) -> some View {
        VStack(spacing: 4) {
            Image(systemName: icon)
                .font(.system(size: 16, weight: .semibold))
                .foregroundStyle(color)
            Text(value)
                .font(.system(size: 18, weight: .bold, design: .rounded))
                .foregroundStyle(.black)
            Text(label)
                .font(.system(size: 10, weight: .medium))
                .foregroundStyle(.gray)
                .multilineTextAlignment(.center)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 12)
        .cardStyle()
    }

    // MARK: - Recent Entry Card

    private func recentEntryCard(entry: DiaryEntry) -> some View {
        HStack(spacing: 0) {
            RoundedRectangle(cornerRadius: 3)
                .fill(entry.entryType.color)
                .frame(width: 4)
                .padding(.vertical, 12)
                .padding(.leading, 12)

            HStack(spacing: 10) {
                Image(systemName: entry.entryType.sfSymbol)
                    .font(.system(size: 15, weight: .semibold))
                    .foregroundStyle(entry.entryType.color)
                    .frame(width: 22)
                Text(entry.summaryText)
                    .font(.bodyText)
                    .foregroundStyle(.black)
                    .lineLimit(1)
                Spacer()
                Text(entry.timestamp, style: .time)
                    .font(.captionText)
                    .foregroundStyle(.gray)
            }
            .padding(.horizontal, 12)
            .padding(.vertical, 12)
        }
        .cardStyle()
    }
}
