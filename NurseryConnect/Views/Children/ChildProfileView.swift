import SwiftUI
import SwiftData
import Charts

struct ChildProfileView: View {
    let child: Child

    @Query private var allEntries: [DiaryEntry]
    @State private var showContacts = false

    private var todayEntries: [DiaryEntry] {
        let start = Calendar.current.startOfDay(for: .now)
        return allEntries
            .filter { $0.childId == child.id && $0.timestamp >= start }
            .sorted { $0.timestamp < $1.timestamp }
    }

    private var entryTypeCounts: [(EntryType, Int)] {
        EntryType.allCases.compactMap { type in
            let count = todayEntries.filter { $0.entryType == type }.count
            return count > 0 ? (type, count) : nil
        }
    }

    var body: some View {
        ZStack {
            Color.appBackground.ignoresSafeArea()

            ScrollView {
                VStack(spacing: 20) {
                    // Avatar header
                    avatarHeader
                        .slideUpOnAppear(delay: 0)

                    // No photo consent warning
                    if !child.photoConsent {
                        HStack(spacing: 10) {
                            Image(systemName: "camera.slash.fill")
                                .foregroundStyle(.white)
                                .font(.system(size: 16, weight: .semibold))
                            Text("No Photography Consent — This child must not be photographed")
                                .font(.system(size: 13, weight: .semibold))
                                .foregroundStyle(.white)
                            Spacer()
                        }
                        .padding(14)
                        .background(Color.red)
                        .clipShape(RoundedRectangle(cornerRadius: 16))
                        .padding(.horizontal, 16)
                        .slideUpOnAppear(delay: 0.05)
                    }

                    // Allergens card
                    VStack(alignment: .leading, spacing: 10) {
                        Label("Allergens", systemImage: "exclamationmark.circle.fill")
                            .font(.cardTitle)
                            .foregroundStyle(.black)

                        if child.allergens.isEmpty {
                            HStack(spacing: 6) {
                                Image(systemName: "checkmark.circle.fill")
                                    .foregroundStyle(.green)
                                Text("No known allergens")
                                    .font(.captionText)
                                    .foregroundStyle(.gray)
                            }
                        } else {
                            FlowLayout(spacing: 8) {
                                ForEach(child.allergens, id: \.self) { allergen in
                                    AllergenBadgeView(allergen: allergen)
                                }
                            }
                        }
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(16)
                    .cardStyle()
                    .padding(.horizontal, 16)
                    .slideUpOnAppear(delay: 0.1)

                    // Today's Diary card
                    VStack(alignment: .leading, spacing: 12) {
                        HStack {
                            Label("Today's Diary", systemImage: "book.fill")
                                .font(.cardTitle)
                                .foregroundStyle(.black)
                            Spacer()
                            Text("\(todayEntries.count) entr\(todayEntries.count == 1 ? "y" : "ies")")
                                .font(.captionText)
                                .foregroundStyle(.gray)
                        }

                        if !entryTypeCounts.isEmpty {
                            Chart(entryTypeCounts, id: \.0) { type, count in
                                SectorMark(
                                    angle: .value("Count", count),
                                    innerRadius: .ratio(0.5),
                                    angularInset: 2
                                )
                                .foregroundStyle(type.color)
                            }
                            .chartLegend(.hidden)
                            .frame(height: 100)
                        }

                        if todayEntries.isEmpty {
                            HStack(spacing: 6) {
                                Image(systemName: "moon.zzz.fill")
                                    .foregroundStyle(.gray.opacity(0.4))
                                Text("No entries yet today")
                                    .font(.captionText)
                                    .foregroundStyle(.gray)
                            }
                            .frame(maxWidth: .infinity, alignment: .center)
                            .padding(.vertical, 12)
                        } else {
                            VStack(spacing: 8) {
                                ForEach(todayEntries) { entry in
                                    diaryEntryRow(entry: entry)
                                }
                            }
                        }
                    }
                    .padding(16)
                    .cardStyle()
                    .padding(.horizontal, 16)
                    .slideUpOnAppear(delay: 0.15)

                    // Action buttons
                    VStack(spacing: 10) {
                        NavigationLink(destination: DiaryTimelineView(child: child, startWithLogCard: true)) {
                            Label("Add Log Entry", systemImage: "plus.circle.fill")
                                .purpleButtonStyle()
                        }
                        .buttonStyle(.plain)
                        .pressEffect()

                        Button {
                            withAnimation(.spring(response: 0.4, dampingFraction: 0.75)) {
                                showContacts = true
                            }
                        } label: {
                            Label("Contacts", systemImage: "person.2.fill")
                                .font(.system(size: 16, weight: .semibold))
                                .foregroundStyle(Color.brandPurple)
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, 16)
                                .background(Color.brandPurple.opacity(0.08))
                                .clipShape(RoundedRectangle(cornerRadius: 14))
                                .overlay(RoundedRectangle(cornerRadius: 14).stroke(Color.brandPurple.opacity(0.25), lineWidth: 1))
                        }
                        .pressEffect()
                    }
                    .padding(.horizontal, 16)
                    .padding(.bottom, 40)
                    .slideUpOnAppear(delay: 0.2)
                }
            }
        }
        .navigationBarTitleDisplayMode(.inline)
        .sheet(isPresented: $showContacts) {
            ContactsSheet(child: child)
        }
    }

    // MARK: - Diary Entry Row

    private func diaryEntryRow(entry: DiaryEntry) -> some View {
        HStack(spacing: 10) {
            ZStack {
                Circle()
                    .fill(entry.entryType.color.opacity(0.12))
                    .frame(width: 32, height: 32)
                Image(systemName: entry.entryType.sfSymbol)
                    .font(.system(size: 13, weight: .semibold))
                    .foregroundStyle(entry.entryType.color)
            }

            Text(entry.summaryText)
                .font(.bodyText)
                .foregroundStyle(.black)
                .lineLimit(2)

            Spacer()

            Text(entry.timestamp, style: .time)
                .font(.captionText)
                .foregroundStyle(.gray)
        }
        .padding(10)
        .background(Color.appBackground)
        .clipShape(RoundedRectangle(cornerRadius: 10))
    }

    // MARK: - Avatar Header

    private var avatarHeader: some View {
        VStack(spacing: 10) {
            ZStack {
                Circle()
                    .fill(Color.brandPurple.opacity(0.12))
                    .frame(width: 88, height: 88)
                Circle()
                    .stroke(Color.brandPurple.opacity(0.2), lineWidth: 2)
                    .frame(width: 88, height: 88)
                Text(child.initials)
                    .font(.system(size: 30, weight: .bold, design: .rounded))
                    .foregroundStyle(Color.brandPurple)
            }
            Text(child.fullName)
                .font(.appTitle)
                .foregroundStyle(.black)
            HStack(spacing: 4) {
                Image(systemName: "building.2")
                    .font(.system(size: 11))
                    .foregroundStyle(.gray)
                Text(child.roomName)
                    .font(.captionText)
                    .foregroundStyle(.gray)
            }
        }
        .padding(.top, 20)
    }
}

// MARK: - Contacts Sheet

private struct ContactsSheet: View {
    let child: Child
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        NavigationStack {
            ZStack {
                Color.appBackground.ignoresSafeArea()

                if child.contacts.isEmpty {
                    VStack(spacing: 12) {
                        Image(systemName: "person.2.slash")
                            .font(.system(size: 48))
                            .foregroundStyle(.gray.opacity(0.35))
                        Text("No contacts on file")
                            .font(.bodyText)
                            .foregroundStyle(.gray)
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                } else {
                    ScrollView {
                        VStack(spacing: 12) {
                            ForEach(Array(child.contacts.enumerated()), id: \.element.id) { index, contact in
                                contactCard(contact)
                                    .slideUpOnAppear(delay: Double(index) * 0.06)
                            }
                        }
                        .padding(16)
                        .padding(.bottom, 40)
                    }
                }
            }
            .navigationTitle("\(child.preferredName)'s Contacts")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        dismiss()
                    } label: {
                        Image(systemName: "xmark.circle.fill")
                            .font(.title2)
                            .foregroundStyle(Color.gray.opacity(0.5))
                    }
                }
            }
        }
    }

    private func contactCard(_ contact: ChildContact) -> some View {
        VStack(spacing: 0) {
            HStack(spacing: 14) {
                ZStack {
                    Circle()
                        .fill(Color.brandPurple.opacity(0.1))
                        .frame(width: 48, height: 48)
                    Image(systemName: "person.fill")
                        .font(.system(size: 18, weight: .semibold))
                        .foregroundStyle(Color.brandPurple)
                }

                VStack(alignment: .leading, spacing: 3) {
                    Text(contact.name)
                        .font(.cardTitle)
                        .foregroundStyle(.black)
                    Text(contact.relationship)
                        .font(.captionText)
                        .foregroundStyle(Color.brandPurple)
                }

                Spacer()
            }
            .padding(16)

            Divider()
                .padding(.horizontal, 16)

            VStack(spacing: 0) {
                if !contact.phone.isEmpty {
                    contactRow(
                        icon: "phone.fill",
                        color: .green,
                        value: contact.phone,
                        action: { openPhone(contact.phone) }
                    )
                }
                if !contact.email.isEmpty {
                    contactRow(
                        icon: "envelope.fill",
                        color: Color.brandPurple,
                        value: contact.email,
                        action: { openEmail(contact.email) }
                    )
                }
            }
            .padding(.bottom, 4)
        }
        .cardStyle()
    }

    private func contactRow(icon: String, color: Color, value: String, action: @escaping () -> Void) -> some View {
        Button(action: action) {
            HStack(spacing: 12) {
                Image(systemName: icon)
                    .font(.system(size: 14, weight: .semibold))
                    .foregroundStyle(color)
                    .frame(width: 28)
                Text(value)
                    .font(.bodyText)
                    .foregroundStyle(.black)
                Spacer()
                Image(systemName: "chevron.right")
                    .font(.system(size: 11, weight: .semibold))
                    .foregroundStyle(.gray.opacity(0.4))
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 12)
        }
        .pressEffect()
    }

    private func openPhone(_ number: String) {
        let cleaned = number.replacingOccurrences(of: " ", with: "")
        if let url = URL(string: "tel://\(cleaned)") {
            UIApplication.shared.open(url)
        }
    }

    private func openEmail(_ email: String) {
        if let url = URL(string: "mailto:\(email)") {
            UIApplication.shared.open(url)
        }
    }
}

// MARK: - Flow Layout

struct FlowLayout: Layout {
    var spacing: CGFloat = 8

    func sizeThatFits(proposal: ProposedViewSize, subviews: Subviews, cache: inout ()) -> CGSize {
        let width = proposal.width ?? 0
        var x: CGFloat = 0
        var y: CGFloat = 0
        var rowHeight: CGFloat = 0
        var totalHeight: CGFloat = 0

        for subview in subviews {
            let size = subview.sizeThatFits(.unspecified)
            if x + size.width > width && x > 0 {
                y += rowHeight + spacing
                x = 0
                rowHeight = 0
                totalHeight = y
            }
            x += size.width + spacing
            rowHeight = max(rowHeight, size.height)
        }
        totalHeight += rowHeight
        return CGSize(width: width, height: totalHeight)
    }

    func placeSubviews(in bounds: CGRect, proposal: ProposedViewSize, subviews: Subviews, cache: inout ()) {
        var x: CGFloat = bounds.minX
        var y: CGFloat = bounds.minY
        var rowHeight: CGFloat = 0

        for subview in subviews {
            let size = subview.sizeThatFits(.unspecified)
            if x + size.width > bounds.maxX && x > bounds.minX {
                y += rowHeight + spacing
                x = bounds.minX
                rowHeight = 0
            }
            subview.place(at: CGPoint(x: x, y: y), proposal: ProposedViewSize(size))
            x += size.width + spacing
            rowHeight = max(rowHeight, size.height)
        }
    }
}
