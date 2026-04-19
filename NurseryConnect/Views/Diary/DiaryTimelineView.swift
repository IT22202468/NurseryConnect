import SwiftUI
import SwiftData

struct DiaryTimelineView: View {
    let child: Child
    var startWithLogCard: Bool = false

    @Query private var allEntries: [DiaryEntry]
    @Environment(\.modelContext) private var context

    @State private var viewModel = DiaryViewModel()

    private var todayEntries: [DiaryEntry] {
        let start = Calendar.current.startOfDay(for: .now)
        return allEntries
            .filter { $0.childId == child.id && $0.timestamp >= start }
            .sorted { $0.timestamp < $1.timestamp }
    }

    private var dateSubtitle: String {
        let fmt = DateFormatter()
        fmt.dateFormat = "EEEE, d MMMM"
        return fmt.string(from: .now)
    }

    var body: some View {
        ZStack {
            Color.appBackground.ignoresSafeArea()

            ScrollViewReader { proxy in
                ScrollView {
                    VStack(alignment: .leading, spacing: 14) {
                        // Date subtitle
                        HStack(spacing: 6) {
                            Image(systemName: "calendar")
                                .font(.system(size: 12))
                                .foregroundStyle(Color.brandPurple)
                            Text(dateSubtitle)
                                .font(.captionText)
                                .foregroundStyle(.gray)
                        }
                        .padding(.horizontal, 4)
                        .slideUpOnAppear(delay: 0)

                        // Log card (inline, at top)
                        if viewModel.showLogCard {
                            DiaryLogCard(child: child, viewModel: viewModel, context: context)
                                .id("logCard")
                                .transition(.asymmetric(
                                    insertion: .move(edge: .top).combined(with: .opacity),
                                    removal: .move(edge: .top).combined(with: .opacity)
                                ))
                        }

                        // Timeline entries
                        if todayEntries.isEmpty && !viewModel.showLogCard {
                            VStack(spacing: 12) {
                                Image(systemName: "book.closed.fill")
                                    .font(.system(size: 44))
                                    .foregroundStyle(Color.brandPurple.opacity(0.25))
                                Text("No entries today")
                                    .font(.bodyText)
                                    .foregroundStyle(.gray)
                                Text("Tap Add Log to get started")
                                    .font(.captionText)
                                    .foregroundStyle(Color.gray.opacity(0.6))
                            }
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 48)
                            .slideUpOnAppear(delay: 0.1)
                        } else {
                            ForEach(Array(todayEntries.enumerated()), id: \.element.id) { index, entry in
                                entryCard(entry: entry)
                                    .slideUpOnAppear(delay: Double(index) * 0.05)
                            }
                        }
                    }
                    .padding(.horizontal, 16)
                    .padding(.bottom, 120)
                    .animation(.spring(response: 0.4, dampingFraction: 0.75), value: viewModel.showLogCard)
                    .animation(.spring(response: 0.4, dampingFraction: 0.75), value: todayEntries.count)
                }
                .onChange(of: viewModel.showLogCard) { _, showing in
                    if showing {
                        withAnimation(.spring(response: 0.4, dampingFraction: 0.75)) {
                            proxy.scrollTo("logCard", anchor: .top)
                        }
                    }
                }
            }

            // Floating add button
            VStack {
                Spacer()
                if !viewModel.showLogCard {
                    Button {
                        withAnimation(.spring(response: 0.4, dampingFraction: 0.75)) {
                            viewModel.showLogCard = true
                        }
                    } label: {
                        Label("Add Log", systemImage: "plus")
                            .purpleButtonStyle()
                            .padding(.horizontal, 32)
                    }
                    .pressEffect()
                    .padding(.bottom, 100)
                    .transition(.asymmetric(
                        insertion: .move(edge: .bottom).combined(with: .opacity),
                        removal: .scale(scale: 0.8).combined(with: .opacity)
                    ))
                }
            }
            .animation(.spring(response: 0.35, dampingFraction: 0.75), value: viewModel.showLogCard)
        }
        .navigationTitle("\(child.preferredName)'s Diary")
        .navigationBarTitleDisplayMode(.large)
        .onAppear {
            if startWithLogCard && !viewModel.showLogCard {
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.15) {
                    withAnimation(.spring(response: 0.4, dampingFraction: 0.75)) {
                        viewModel.showLogCard = true
                    }
                }
            }
        }
    }

    private func entryCard(entry: DiaryEntry) -> some View {
        HStack(spacing: 0) {
            RoundedRectangle(cornerRadius: 3)
                .fill(entry.entryType.color)
                .frame(width: 4)
                .padding(.vertical, 14)
                .padding(.leading, 14)

            HStack(spacing: 12) {
                ZStack {
                    Circle()
                        .fill(entry.entryType.color.opacity(0.12))
                        .frame(width: 36, height: 36)
                    Image(systemName: entry.entryType.sfSymbol)
                        .font(.system(size: 15, weight: .semibold))
                        .foregroundStyle(entry.entryType.color)
                }

                Text(entry.summaryText)
                    .font(.cardTitle)
                    .foregroundStyle(.black)
                    .lineLimit(2)

                Spacer()

                Text(entry.timestamp, style: .time)
                    .font(.captionText)
                    .foregroundStyle(.gray)
            }
            .padding(.horizontal, 12)
            .padding(.vertical, 14)
        }
        .cardStyle()
    }
}
