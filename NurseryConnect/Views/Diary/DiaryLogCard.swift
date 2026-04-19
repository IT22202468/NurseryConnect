import SwiftUI
import SwiftData

struct DiaryLogCard: View {
    let child: Child
    @Bindable var viewModel: DiaryViewModel
    let context: ModelContext

    private let logTypes: [EntryType] = [.activity, .meal, .nap, .nappy, .mood]

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            // Header
            HStack {
                Label("Log Entry", systemImage: "square.and.pencil")
                    .font(.cardTitle)
                    .foregroundStyle(.black)
                Spacer()
                Button {
                    withAnimation(.spring(response: 0.35, dampingFraction: 0.75)) {
                        viewModel.showLogCard = false
                        viewModel.reset()
                    }
                } label: {
                    Image(systemName: "xmark.circle.fill")
                        .font(.title2)
                        .foregroundStyle(Color.gray.opacity(0.5))
                }
            }

            // Type chip selector
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 8) {
                    ForEach(logTypes, id: \.self) { type in
                        Button {
                            withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                                viewModel.selectedEntryType = type
                            }
                        } label: {
                            HStack(spacing: 5) {
                                Image(systemName: type.sfSymbol)
                                    .font(.system(size: 12, weight: .semibold))
                                Text(type.displayName)
                                    .font(.system(size: 13, weight: .semibold))
                            }
                            .padding(.horizontal, 14)
                            .padding(.vertical, 8)
                            .foregroundStyle(viewModel.selectedEntryType == type ? .white : Color.brandPurple)
                            .background(
                                viewModel.selectedEntryType == type
                                    ? Color.brandPurple
                                    : Color.brandPurple.opacity(0.07)
                            )
                            .clipShape(Capsule())
                            .scaleEffect(viewModel.selectedEntryType == type ? 1.04 : 1.0)
                            .animation(.spring(response: 0.3, dampingFraction: 0.65), value: viewModel.selectedEntryType)
                        }
                    }
                }
            }

            // Field sets — animated transitions between types
            ZStack {
                switch viewModel.selectedEntryType {
                case .meal:     MealFields(child: child, viewModel: viewModel)
                case .activity: ActivityFields(viewModel: viewModel)
                case .nap:      NapFields(viewModel: viewModel)
                case .nappy:    NappyFields(viewModel: viewModel)
                case .mood:     MoodFields(viewModel: viewModel)
                default:        EmptyView()
                }
            }
            .transition(.opacity.combined(with: .scale(scale: 0.97)))
            .animation(.spring(response: 0.32, dampingFraction: 0.78), value: viewModel.selectedEntryType)

            // Notes
            VStack(alignment: .leading, spacing: 6) {
                Label("Additional notes", systemImage: "text.alignleft")
                    .font(.captionText)
                    .foregroundStyle(.gray)
                ZStack(alignment: .topLeading) {
                    if viewModel.notes.isEmpty {
                        Text("Optional notes...")
                            .font(.bodyText)
                            .foregroundStyle(.gray.opacity(0.5))
                            .padding(.top, 8)
                            .padding(.leading, 4)
                    }
                    TextEditor(text: $viewModel.notes)
                        .font(.bodyText)
                        .frame(minHeight: 56)
                        .scrollContentBackground(.hidden)
                }
                .padding(10)
                .background(Color.appBackground)
                .clipShape(RoundedRectangle(cornerRadius: 10))
                .overlay(RoundedRectangle(cornerRadius: 10).stroke(Color.gray.opacity(0.15)))
            }

            // Validation error + Save
            VStack(spacing: 8) {
                if let error = viewModel.validationError {
                    HStack(spacing: 6) {
                        Image(systemName: "exclamationmark.circle.fill")
                            .foregroundStyle(.red)
                            .font(.system(size: 13))
                        Text(error)
                            .font(.captionText)
                            .foregroundStyle(.red)
                    }
                    .transition(.move(edge: .top).combined(with: .opacity))
                }

                Button {
                    withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                        if viewModel.validate(child: child) {
                            viewModel.saveEntry(child: child, keyworkerId: SeedData.keyworkerId, context: context)
                        }
                    }
                } label: {
                    Label("Save Log", systemImage: "checkmark.circle.fill")
                        .purpleButtonStyle()
                }
                .pressEffect()
            }
            .animation(.spring(response: 0.3, dampingFraction: 0.7), value: viewModel.validationError)
        }
        .padding(16)
        .cardStyle()
    }
}

// MARK: - Meal Fields

private struct MealFields: View {
    let child: Child
    @Bindable var viewModel: DiaryViewModel

    let mealTypes = ["Breakfast", "Morning Snack", "Lunch", "Afternoon Snack", "Dinner"]

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            // Allergen alert
            if !child.allergens.isEmpty {
                VStack(alignment: .leading, spacing: 10) {
                    HStack(spacing: 8) {
                        Image(systemName: "exclamationmark.triangle.fill")
                            .foregroundStyle(.orange)
                            .font(.system(size: 14, weight: .semibold))
                        Text("Allergen Alert: \(child.allergens.joined(separator: ", "))")
                            .font(.system(size: 13, weight: .semibold))
                            .foregroundStyle(.black)
                        Spacer()
                    }
                    Toggle(isOn: $viewModel.allergenAcknowledged) {
                        Text("I have checked allergens for this meal")
                            .font(.captionText)
                            .foregroundStyle(.black)
                    }
                    .tint(Color.brandPurple)
                }
                .padding(12)
                .background(Color.orange.opacity(0.1))
                .clipShape(RoundedRectangle(cornerRadius: 12))
                .overlay(RoundedRectangle(cornerRadius: 12).stroke(Color.orange.opacity(0.3), lineWidth: 1))
            }

            Picker("Meal type", selection: $viewModel.mealType) {
                ForEach(mealTypes, id: \.self) { Text($0).tag($0) }
            }
            .pickerStyle(.menu)
            .tint(Color.brandPurple)

            TextField("Foods offered", text: $viewModel.foodsOffered)
                .textFieldStyle(BrandTextFieldStyle())

            // Consumption chips
            Text("Consumption")
                .font(.captionText)
                .foregroundStyle(.gray)
            LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 3), spacing: 8) {
                ForEach(ConsumptionLevel.allCases, id: \.self) { level in
                    Button {
                        withAnimation(.spring(response: 0.25, dampingFraction: 0.7)) {
                            viewModel.consumptionLevel = level
                        }
                    } label: {
                        Text(level.displayName)
                            .font(.system(size: 13, weight: .semibold))
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 8)
                            .foregroundStyle(viewModel.consumptionLevel == level ? .white : Color.brandPurple)
                            .background(viewModel.consumptionLevel == level ? Color.brandPurple : Color.brandPurple.opacity(0.07))
                            .clipShape(RoundedRectangle(cornerRadius: 8))
                            .scaleEffect(viewModel.consumptionLevel == level ? 1.03 : 1.0)
                            .animation(.spring(response: 0.25, dampingFraction: 0.65), value: viewModel.consumptionLevel)
                    }
                }
            }

            HStack {
                Image(systemName: "drop.fill")
                    .foregroundStyle(.blue)
                Text("Fluid: \(viewModel.fluidVolumeMl) ml")
                    .font(.bodyText)
                Spacer()
                Stepper("", value: $viewModel.fluidVolumeMl, in: 0...500, step: 50)
                    .labelsHidden()
            }

            Picker("Fluid type", selection: $viewModel.fluidType) {
                Text("Water").tag("Water")
                Text("Milk").tag("Milk")
                Text("Juice").tag("Juice")
            }
            .pickerStyle(.segmented)
        }
    }
}

// MARK: - Activity Fields

private struct ActivityFields: View {
    @Bindable var viewModel: DiaryViewModel

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            TextField("Activity name", text: $viewModel.activityName)
                .textFieldStyle(BrandTextFieldStyle())

            Picker("EYFS Area", selection: $viewModel.eyfsArea) {
                ForEach(EYFSArea.allCases, id: \.self) { area in
                    Text(area.displayName).tag(area)
                }
            }
            .pickerStyle(.menu)
            .tint(Color.brandPurple)

            HStack {
                Image(systemName: "clock.fill")
                    .foregroundStyle(Color.brandPurple)
                Text("Duration: \(viewModel.durationMinutes) mins")
                    .font(.bodyText)
                Spacer()
                Stepper("", value: $viewModel.durationMinutes, in: 5...120, step: 5)
                    .labelsHidden()
            }
        }
    }
}

// MARK: - Nap Fields

private struct NapFields: View {
    @Bindable var viewModel: DiaryViewModel

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            DatePicker("Start time", selection: $viewModel.napStartTime, displayedComponents: .hourAndMinute)
                .tint(Color.brandPurple)
            DatePicker("End time", selection: $viewModel.napEndTime, displayedComponents: .hourAndMinute)
                .tint(Color.brandPurple)
            Picker("Sleep position", selection: $viewModel.sleepPosition) {
                ForEach(SleepPosition.allCases, id: \.self) { pos in
                    Text(pos.displayName).tag(pos)
                }
            }
            .pickerStyle(.segmented)
        }
    }
}

// MARK: - Nappy Fields

private struct NappyFields: View {
    @Bindable var viewModel: DiaryViewModel

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Nappy type")
                .font(.captionText)
                .foregroundStyle(.gray)

            HStack(spacing: 8) {
                ForEach(NappyType.allCases, id: \.self) { type in
                    Button {
                        withAnimation(.spring(response: 0.25, dampingFraction: 0.7)) {
                            viewModel.nappyType = type
                        }
                    } label: {
                        Text(type.displayName)
                            .font(.system(size: 13, weight: .semibold))
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 8)
                            .foregroundStyle(viewModel.nappyType == type ? .white : Color.brandPurple)
                            .background(viewModel.nappyType == type ? Color.brandPurple : Color.brandPurple.opacity(0.07))
                            .clipShape(RoundedRectangle(cornerRadius: 8))
                            .scaleEffect(viewModel.nappyType == type ? 1.03 : 1.0)
                            .animation(.spring(response: 0.25, dampingFraction: 0.65), value: viewModel.nappyType)
                    }
                }
            }

            Toggle(isOn: $viewModel.nappyConcerns) {
                Label("Any concerns noted?", systemImage: "exclamationmark.circle")
                    .font(.bodyText)
                    .foregroundStyle(.black)
            }
            .tint(Color.brandPurple)

            if viewModel.nappyConcerns {
                TextField("Describe concern...", text: $viewModel.concernsNotes)
                    .textFieldStyle(BrandTextFieldStyle())
                    .transition(.move(edge: .top).combined(with: .opacity))
            }
        }
        .animation(.spring(response: 0.3, dampingFraction: 0.75), value: viewModel.nappyConcerns)
    }
}

// MARK: - Mood Fields

private struct MoodFields: View {
    @Bindable var viewModel: DiaryViewModel

    private let moods: [(Int, String, String, Color)] = [
        (1, "face.smiling.fill",       "Happy",     .green),
        (2, "questionmark.circle.fill", "Unsettled", .orange),
        (3, "thermometer.medium",       "Poorly",    .red)
    ]

    var body: some View {
        HStack(spacing: 10) {
            ForEach(moods, id: \.0) { rating, icon, label, color in
                Button {
                    withAnimation(.spring(response: 0.28, dampingFraction: 0.65)) {
                        viewModel.moodRating = rating
                    }
                } label: {
                    VStack(spacing: 6) {
                        Image(systemName: icon)
                            .font(.system(size: 28, weight: .semibold))
                            .foregroundStyle(viewModel.moodRating == rating ? color : color.opacity(0.4))
                        Text(label)
                            .font(.captionText)
                            .foregroundStyle(.black)
                    }
                    .frame(maxWidth: .infinity)
                    .frame(height: 76)
                    .background(viewModel.moodRating == rating ? color.opacity(0.1) : Color.appBackground)
                    .clipShape(RoundedRectangle(cornerRadius: 14))
                    .overlay(
                        RoundedRectangle(cornerRadius: 14)
                            .stroke(viewModel.moodRating == rating ? color : Color.gray.opacity(0.15), lineWidth: viewModel.moodRating == rating ? 2 : 1)
                    )
                    .scaleEffect(viewModel.moodRating == rating ? 1.04 : 1.0)
                    .animation(.spring(response: 0.28, dampingFraction: 0.65), value: viewModel.moodRating)
                }
            }
        }
    }
}

// MARK: - Brand Text Field Style

struct BrandTextFieldStyle: TextFieldStyle {
    func _body(configuration: TextField<Self._Label>) -> some View {
        configuration
            .padding(12)
            .background(Color.appBackground)
            .clipShape(RoundedRectangle(cornerRadius: 10))
            .overlay(RoundedRectangle(cornerRadius: 10).stroke(Color.gray.opacity(0.15)))
    }
}
