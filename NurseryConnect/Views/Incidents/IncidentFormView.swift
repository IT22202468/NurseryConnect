import SwiftUI
import SwiftData

struct IncidentFormView: View {
    @Environment(\.modelContext) private var context
    @Environment(\.dismiss) private var dismiss

    @Query(sort: \Child.fullName) private var allChildren: [Child]
    private var children: [Child] {
        allChildren.filter { $0.keyworkerUUID == SeedData.keyworkerId }
    }

    @State private var viewModel = IncidentViewModel()

    var body: some View {
        ZStack {
            Color.appBackground.ignoresSafeArea()

            ScrollView {
                VStack(spacing: 24) {
                    progressIndicator
                        .padding(.horizontal, 16)
                        .padding(.top, 8)
                        .slideUpOnAppear(delay: 0)

                    detailsSection
                        .slideUpOnAppear(delay: 0.05)
                    bodyMapSection
                        .slideUpOnAppear(delay: 0.1)
                    reviewSection
                        .slideUpOnAppear(delay: 0.15)

                    Color.clear.frame(height: 100)
                }
            }
            .safeAreaInset(edge: .bottom) {
                submitBar
            }
        }
        .navigationTitle("New Incident")
        .navigationBarTitleDisplayMode(.inline)
    }

    // MARK: - Progress Indicator

    private var progressIndicator: some View {
        let steps = ["Details", "Body Map", "Review"]
        let complete = [viewModel.section0Complete, viewModel.section1Complete, viewModel.section2Complete]

        return HStack(spacing: 0) {
            ForEach(steps.indices, id: \.self) { i in
                HStack(spacing: 0) {
                    VStack(spacing: 4) {
                        ZStack {
                            Circle()
                                .fill(complete[i] ? Color.brandPurple : Color.gray.opacity(0.25))
                                .frame(width: 24, height: 24)
                            Text("\(i + 1)")
                                .font(.system(size: 10, weight: .bold))
                                .foregroundStyle(.white)
                        }
                        Text(steps[i])
                            .font(.captionText)
                            .foregroundStyle(complete[i] ? Color.brandPurple : .gray)
                    }
                    if i < steps.count - 1 {
                        Rectangle()
                            .fill(Color.gray.opacity(0.3))
                            .frame(height: 1)
                            .frame(maxWidth: .infinity)
                    }
                }
            }
        }
        .animation(.easeInOut, value: viewModel.section0Complete)
        .animation(.easeInOut, value: viewModel.section2Complete)
    }

    // MARK: - Section 1: Details

    private var detailsSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            sectionHeader("INCIDENT DETAILS")

            // Child picker
            VStack(alignment: .leading, spacing: 6) {
                Text("Child")
                    .font(.captionText)
                    .foregroundStyle(.gray)
                Picker("Child", selection: $viewModel.selectedChildId) {
                    Text("Select a child").tag(nil as UUID?)
                    ForEach(children) { child in
                        Text(child.fullName).tag(child.id as UUID?)
                    }
                }
                .pickerStyle(.menu)
                .tint(Color.brandPurple)
                .onChange(of: viewModel.selectedChildId) { _, newId in
                    viewModel.selectedChildName = children.first { $0.id == newId }?.fullName ?? ""
                }
            }
            .padding(14)
            .background(Color.white)
            .clipShape(RoundedRectangle(cornerRadius: 12))

            // Read-only timestamp
            VStack(alignment: .leading, spacing: 4) {
                Text("Date & Time")
                    .font(.captionText)
                    .foregroundStyle(.gray)
                HStack {
                    Text(Date.now, style: .date)
                    Text("·")
                    Text(Date.now, style: .time)
                }
                .font(.bodyText)
                .foregroundStyle(.black)
                .padding(14)
                .frame(maxWidth: .infinity, alignment: .leading)
                .background(Color.white.opacity(0.6))
                .clipShape(RoundedRectangle(cornerRadius: 12))

                HStack(spacing: 4) {
                    Image(systemName: "lock.fill")
                        .font(.system(size: 10))
                }
                .font(.captionText)
                .foregroundStyle(.gray)
            }

            // Location
            VStack(alignment: .leading, spacing: 6) {
                Text("Location")
                    .font(.captionText)
                    .foregroundStyle(.gray)
                TextField("Where did this happen?", text: $viewModel.location)
                    .textFieldStyle(BrandTextFieldStyle())
            }

            // Category chips
            VStack(alignment: .leading, spacing: 8) {
                Text("Category")
                    .font(.captionText)
                    .foregroundStyle(.gray)
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 8) {
                        ForEach(IncidentCategory.allCases, id: \.self) { cat in
                            Button {
                                withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                                    viewModel.category = cat
                                }
                            } label: {
                                Text(cat.displayName)
                                    .font(.system(size: 12, weight: .semibold))
                                    .padding(.horizontal, 12)
                                    .padding(.vertical, 7)
                                    .foregroundStyle(viewModel.category == cat ? .white : Color.brandPurple)
                                    .background(viewModel.category == cat ? Color.brandPurple : Color.white)
                                    .clipShape(Capsule())
                                    .overlay(Capsule().stroke(Color.brandPurple, lineWidth: viewModel.category == cat ? 0 : 1.5))
                            }
                        }
                    }
                }
            }

            // Safeguarding warning
            if viewModel.category == .safeguardingConcern {
                HStack(spacing: 10) {
                    Image(systemName: "exclamationmark.shield.fill")
                        .font(.system(size: 20, weight: .semibold))
                        .foregroundStyle(.red)
                    VStack(alignment: .leading, spacing: 4) {
                        Label("Safeguarding Concern", systemImage: "exclamationmark.triangle.fill")
                            .font(.system(size: 13, weight: .bold))
                            .foregroundStyle(.black)
                        Text("Contact your Designated Safeguarding Lead immediately. Use the SOS button if the child is in immediate danger.")
                            .font(.captionText)
                            .foregroundStyle(.black)
                    }
                }
                .padding(14)
                .background(Color.red.opacity(0.08))
                .clipShape(RoundedRectangle(cornerRadius: 12))
                .overlay(RoundedRectangle(cornerRadius: 12).stroke(Color.red.opacity(0.25), lineWidth: 1))
                .transition(.move(edge: .top).combined(with: .opacity))
            }

            // Description
            formTextEditor(label: "What happened?", text: $viewModel.incidentDescription, minHeight: 80)

            // Immediate action
            formTextEditor(label: "Immediate action taken", text: $viewModel.immediateAction, minHeight: 60)

            // Witnesses
            VStack(alignment: .leading, spacing: 6) {
                Text("Witnesses")
                    .font(.captionText)
                    .foregroundStyle(.gray)
                TextField("Names of witnesses, separated by commas", text: $viewModel.witnesses)
                    .textFieldStyle(BrandTextFieldStyle())
            }
        }
        .padding(.horizontal, 16)
        .animation(.spring(response: 0.3, dampingFraction: 0.7), value: viewModel.category)
    }

    // MARK: - Section 2: Body Map

    private var bodyMapSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            sectionHeader("BODY MAP")

            Text("Tap the diagram to mark injury locations (optional)")
                .font(.captionText)
                .foregroundStyle(.gray)

            // Side toggle
            Picker("Side", selection: $viewModel.currentBodySide) {
                ForEach(BodySide.allCases, id: \.self) { side in
                    Text(side.displayName).tag(side)
                }
            }
            .pickerStyle(.segmented)

            // Body map inline
            BodyMapView(annotations: $viewModel.annotations, currentSide: $viewModel.currentBodySide)
                .frame(height: 280)

            // Annotation list
            let visible = viewModel.annotations.filter { $0.side == viewModel.currentBodySide }
            if !visible.isEmpty {
                VStack(alignment: .leading, spacing: 8) {
                    ForEach(visible) { annotation in
                        HStack(spacing: 8) {
                            Circle()
                                .fill(Color.brandPurple)
                                .frame(width: 8, height: 8)
                            Text("\(annotation.side.displayName): \(annotation.note.isEmpty ? "(no note)" : annotation.note)")
                                .font(.captionText)
                                .foregroundStyle(.black)
                        }
                    }
                }
            }
        }
        .padding(.horizontal, 16)
    }

    // MARK: - Section 3: Review

    private var reviewSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            sectionHeader("REVIEW")

            // Summary
            VStack(alignment: .leading, spacing: 8) {
                if let childName = children.first(where: { $0.id == viewModel.selectedChildId })?.fullName {
                    reviewRow(label: "Child", value: childName)
                }
                reviewRow(label: "Category", value: viewModel.category.displayName)
                if !viewModel.location.isEmpty {
                    reviewRow(label: "Location", value: viewModel.location)
                }
                if !viewModel.incidentDescription.isEmpty {
                    reviewRow(
                        label: "Description",
                        value: String(viewModel.incidentDescription.prefix(100)) + (viewModel.incidentDescription.count > 100 ? "…" : "")
                    )
                }
            }
            .padding(14)
            .cardStyle()

            // Confirm toggle
            Toggle(isOn: $viewModel.confirmAccurate) {
                HStack(spacing: 6) {
                    Text("✅")
                    Text("I confirm this report is accurate and complete")
                        .font(.bodyText)
                        .foregroundStyle(.black)
                }
            }
            .tint(Color.brandPurple)
            .padding(14)
            .background(viewModel.confirmAccurate ? Color.brandPurple.opacity(0.08) : Color.white)
            .clipShape(RoundedRectangle(cornerRadius: 12))
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(viewModel.confirmAccurate ? Color.brandPurple : Color.orange.opacity(0.6), lineWidth: 1.5)
            )
            .animation(.easeInOut(duration: 0.2), value: viewModel.confirmAccurate)
        }
        .padding(.horizontal, 16)
    }

    // MARK: - Submit Bar

    private var submitBar: some View {
        VStack(spacing: 6) {
            if let error = viewModel.validationError {
                HStack(spacing: 6) {
                    Image(systemName: "exclamationmark.circle.fill")
                        .font(.system(size: 13))
                        .foregroundStyle(.red)
                    Text(error)
                        .font(.captionText)
                        .foregroundStyle(.red)
                        .multilineTextAlignment(.center)
                }
                .padding(.horizontal, 16)
                .transition(.move(edge: .bottom).combined(with: .opacity))
            }
            Button {
                if viewModel.submitReport(keyworkerId: SeedData.keyworkerId, context: context) {
                    dismiss()
                }
            } label: {
                Label("Submit Report", systemImage: "checkmark.circle.fill")
                    .purpleButtonStyle()
                    .padding(.horizontal, 16)
            }
            .pressEffect()
            .padding(.bottom, 8)
        }
        .padding(.top, 8)
        .background(Color.appBackground)
        .animation(.spring(response: 0.3, dampingFraction: 0.7), value: viewModel.validationError)
    }

    // MARK: - Helpers

    private func sectionHeader(_ text: String) -> some View {
        Text(text)
            .font(.system(size: 12, weight: .semibold, design: .default))
            .tracking(1)
            .foregroundStyle(Color.brandPurple)
    }

    private func formTextEditor(label: String, text: Binding<String>, minHeight: CGFloat) -> some View {
        VStack(alignment: .leading, spacing: 6) {
            Text(label)
                .font(.captionText)
                .foregroundStyle(.gray)
            ZStack(alignment: .topLeading) {
                if text.wrappedValue.isEmpty {
                    Text("Tap to enter...")
                        .font(.bodyText)
                        .foregroundStyle(.gray.opacity(0.5))
                        .padding(.top, 8)
                        .padding(.leading, 4)
                }
                TextEditor(text: text)
                    .font(.bodyText)
                    .frame(minHeight: minHeight)
                    .scrollContentBackground(.hidden)
            }
            .padding(10)
            .background(Color.white)
            .clipShape(RoundedRectangle(cornerRadius: 12))
            .overlay(RoundedRectangle(cornerRadius: 12).stroke(Color.gray.opacity(0.2)))
        }
    }

    private func reviewRow(label: String, value: String) -> some View {
        HStack(alignment: .top, spacing: 8) {
            Text(label + ":")
                .font(.captionText)
                .foregroundStyle(.gray)
                .frame(width: 80, alignment: .leading)
            Text(value)
                .font(.bodyText)
                .foregroundStyle(.black)
            Spacer()
        }
    }
}
