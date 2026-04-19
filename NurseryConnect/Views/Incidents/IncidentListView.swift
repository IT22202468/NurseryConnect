import SwiftUI
import SwiftData

struct IncidentListView: View {
    @Query(sort: \IncidentReport.timestamp, order: .reverse)
    private var allIncidents: [IncidentReport]

    private var incidents: [IncidentReport] {
        allIncidents.filter { $0.keyworkerId == SeedData.keyworkerId }
    }

    var body: some View {
        ZStack {
            Color.appBackground.ignoresSafeArea()

            VStack(alignment: .leading, spacing: 16) {
                // New incident button
                NavigationLink(destination: IncidentFormView()) {
                    Label("New Incident", systemImage: "plus")
                        .purpleButtonStyle()
                }
                .buttonStyle(.plain)
                .pressEffect()
                .padding(.horizontal, 16)
                .padding(.top, 8)
                .slideUpOnAppear(delay: 0)

                if incidents.isEmpty {
                    emptyState
                } else {
                    ScrollView {
                        VStack(spacing: 12) {
                            ForEach(Array(incidents.enumerated()), id: \.element.id) { index, incident in
                                incidentCard(incident)
                                    .slideUpOnAppear(delay: Double(index) * 0.06)
                            }
                        }
                        .padding(.horizontal, 16)
                        .padding(.bottom, 120)
                    }
                }
            }
        }
        .navigationTitle("Incidents")
        .navigationBarTitleDisplayMode(.large)
    }

    private var emptyState: some View {
        VStack(spacing: 12) {
            Spacer()
            Image(systemName: "shield")
                .font(.system(size: 60))
                .foregroundStyle(.gray.opacity(0.4))
            Text("No incidents recorded")
                .font(.bodyText)
                .foregroundStyle(.gray)
            Text("Tap + New Incident to begin")
                .font(.captionText)
                .foregroundStyle(.gray)
            Spacer()
        }
        .frame(maxWidth: .infinity)
    }

    private func incidentCard(_ incident: IncidentReport) -> some View {
        VStack(alignment: .leading, spacing: 0) {
            HStack(alignment: .top, spacing: 12) {
                VStack(alignment: .leading, spacing: 4) {
                    Text(incident.childName)
                        .font(.cardTitle)
                        .foregroundStyle(.black)
                    Text(incident.category.displayName)
                        .font(.bodyText)
                        .foregroundStyle(.black)
                    Text(relativeTimestamp(incident.timestamp))
                        .font(.captionText)
                        .foregroundStyle(.gray)
                }
                Spacer()
                statusPill(incident.status)
            }
            .padding(16)

            if incident.sosActivated {
                HStack {
                    Spacer()
                    HStack(spacing: 4) {
                        Image(systemName: "sos.circle.fill")
                            .font(.system(size: 11, weight: .bold))
                        Text("SOS Used")
                            .font(.system(size: 11, weight: .bold))
                    }
                    .foregroundStyle(.white)
                    .padding(.horizontal, 8)
                    .padding(.vertical, 4)
                    .background(Color.red)
                    .clipShape(Capsule())
                }
                .padding(.horizontal, 16)
                .padding(.bottom, 12)
            }
        }
        .cardStyle()
    }

    private func statusPill(_ status: String) -> some View {
        let isDraft = status == "draft"
        return Text(isDraft ? "Draft" : "Submitted")
            .font(.captionText)
            .foregroundStyle(.white)
            .padding(.horizontal, 10)
            .padding(.vertical, 4)
            .background(isDraft ? Color.brandPink : Color.brandPurple)
            .clipShape(Capsule())
    }

    private func relativeTimestamp(_ date: Date) -> String {
        let calendar = Calendar.current
        if calendar.isDateInToday(date) {
            let fmt = DateFormatter()
            fmt.dateFormat = "HH:mm"
            return "Today at \(fmt.string(from: date))"
        } else if calendar.isDateInYesterday(date) {
            let fmt = DateFormatter()
            fmt.dateFormat = "HH:mm"
            return "Yesterday at \(fmt.string(from: date))"
        } else {
            let fmt = DateFormatter()
            fmt.dateStyle = .short
            fmt.timeStyle = .short
            return fmt.string(from: date)
        }
    }
}
