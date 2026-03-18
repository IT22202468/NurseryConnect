
//  BodyMapView.swift
//  NurseryConnect

import SwiftUI

// MARK: - Human Body Shape -----------------------------------------------

/// A single-path silhouette of a standing human figure.
/// The bounding rect determines the size; all control points are normalised (0–1).
struct HumanBodyShape: Shape {

    func path(in rect: CGRect) -> Path {
        let w = rect.width
        let h = rect.height

        func pt(_ nx: CGFloat, _ ny: CGFloat) -> CGPoint {
            CGPoint(x: rect.minX + nx * w, y: rect.minY + ny * h)
        }

        var path = Path()

        // ── Head (separate ellipse sub-path) ────────────────────────────
        path.addEllipse(in: CGRect(
            x: rect.minX + 0.375 * w,
            y: rect.minY,
            width:  0.25  * w,
            height: 0.175 * h
        ))

        // ── Body silhouette ─────────────────────────────────────────────
        // Clockwise from left-neck base → left shoulder → left arm →
        // left torso → left leg → crotch → right leg → right torso →
        // right arm → right shoulder → right-neck base → close (neck line).

        path.move(to: pt(0.44, 0.175))          // left neck base

        // left neck → left shoulder
        path.addCurve(to:      pt(0.195, 0.265),
                      control1: pt(0.370, 0.195),
                      control2: pt(0.265, 0.233))

        // left shoulder → arm outer (elbow region)
        path.addCurve(to:      pt(0.125, 0.555),
                      control1: pt(0.155, 0.310),
                      control2: pt(0.113, 0.445))

        // arm outer → left hand tip (outer side)
        path.addCurve(to:      pt(0.114, 0.635),
                      control1: pt(0.120, 0.575),
                      control2: pt(0.107, 0.605))

        // left hand bottom: outer → inner (rounded)
        path.addCurve(to:      pt(0.215, 0.640),
                      control1: pt(0.110, 0.668),
                      control2: pt(0.204, 0.668))

        // left arm inner: hand → wrist → armpit
        path.addCurve(to:      pt(0.278, 0.305),
                      control1: pt(0.225, 0.580),
                      control2: pt(0.248, 0.440))

        // left torso: armpit → waist → hip outer
        path.addCurve(to:      pt(0.268, 0.595),
                      control1: pt(0.264, 0.400),
                      control2: pt(0.255, 0.515))

        // left hip flare
        path.addCurve(to:      pt(0.307, 0.625),
                      control1: pt(0.262, 0.622),
                      control2: pt(0.277, 0.634))

        // left leg outer: hip → knee → ankle
        path.addCurve(to:      pt(0.287, 0.896),
                      control1: pt(0.284, 0.725),
                      control2: pt(0.276, 0.833))

        // left foot outer
        path.addCurve(to:      pt(0.194, 0.946),
                      control1: pt(0.281, 0.929),
                      control2: pt(0.222, 0.946))

        // left foot sole
        path.addLine(to: pt(0.388, 0.956))

        // left foot inner / ankle inner
        path.addCurve(to:      pt(0.387, 0.902),
                      control1: pt(0.395, 0.964),
                      control2: pt(0.395, 0.936))

        // left leg inner: ankle → knee → crotch
        path.addCurve(to:      pt(0.415, 0.626),
                      control1: pt(0.392, 0.830),
                      control2: pt(0.403, 0.725))

        // crotch arch
        path.addCurve(to:      pt(0.585, 0.626),
                      control1: pt(0.428, 0.672),
                      control2: pt(0.572, 0.672))

        // right leg inner: crotch → knee → ankle
        path.addCurve(to:      pt(0.613, 0.902),
                      control1: pt(0.597, 0.725),
                      control2: pt(0.608, 0.830))

        // right foot inner / ankle inner
        path.addCurve(to:      pt(0.612, 0.956),
                      control1: pt(0.605, 0.936),
                      control2: pt(0.605, 0.964))

        // right foot sole
        path.addLine(to: pt(0.806, 0.946))

        // right foot outer
        path.addCurve(to:      pt(0.713, 0.896),
                      control1: pt(0.778, 0.946),
                      control2: pt(0.719, 0.929))

        // right leg outer: ankle → knee → hip
        path.addCurve(to:      pt(0.693, 0.625),
                      control1: pt(0.724, 0.833),
                      control2: pt(0.716, 0.725))

        // right hip
        path.addCurve(to:      pt(0.732, 0.595),
                      control1: pt(0.723, 0.634),
                      control2: pt(0.738, 0.622))

        // right torso: hip → waist → armpit
        path.addCurve(to:      pt(0.722, 0.305),
                      control1: pt(0.745, 0.515),
                      control2: pt(0.736, 0.400))

        // right arm inner: armpit → wrist
        path.addCurve(to:      pt(0.785, 0.640),
                      control1: pt(0.752, 0.440),
                      control2: pt(0.775, 0.580))

        // right hand: inner → bottom → outer (rounded)
        path.addCurve(to:      pt(0.886, 0.635),
                      control1: pt(0.796, 0.668),
                      control2: pt(0.879, 0.668))

        path.addCurve(to:      pt(0.875, 0.555),
                      control1: pt(0.893, 0.605),
                      control2: pt(0.881, 0.575))

        // right arm outer: wrist → elbow → shoulder
        path.addCurve(to:      pt(0.805, 0.265),
                      control1: pt(0.887, 0.445),
                      control2: pt(0.845, 0.310))

        // right shoulder → right neck base
        path.addCurve(to:      pt(0.560, 0.175),
                      control1: pt(0.735, 0.233),
                      control2: pt(0.630, 0.195))

        path.closeSubpath()     // straight neck line back to start

        return path
    }
}

// MARK: - Marker Dot View ------------------------------------------------

private struct MarkerDotView: View {
    let isPulsing: Bool

    @State private var pulseScale:   CGFloat = 1.0
    @State private var pulseOpacity: Double  = 0.55

    var body: some View {
        ZStack {
            if isPulsing {
                Circle()
                    .fill(Color.red.opacity(pulseOpacity))
                    .frame(width: 30, height: 30)
                    .scaleEffect(pulseScale)
                    .onAppear {
                        withAnimation(
                            .easeOut(duration: 0.9)
                            .repeatForever(autoreverses: false)
                        ) {
                            pulseScale   = 2.4
                            pulseOpacity = 0.0
                        }
                    }
            }

            Circle()
                .fill(
                    RadialGradient(
                        colors: [Color.red.opacity(0.9), Color.red],
                        center: .top,
                        startRadius: 0,
                        endRadius: 10
                    )
                )
                .frame(width: 14, height: 14)
                .overlay(Circle().stroke(Color.white, lineWidth: 1.5))
                .shadow(color: .red.opacity(0.45), radius: 4, x: 0, y: 2)
        }
    }
}

// MARK: - Marker Popover -------------------------------------------------

private struct MarkerPopover: View {
    @Binding var description: String
    let onSave:   () -> Void
    let onDelete: () -> Void

    @Environment(\.dismiss) private var dismiss
    @FocusState private var textFocused: Bool

    var body: some View {
        NavigationStack {
            Form {
                Section {
                    TextEditor(text: $description)
                        .frame(minHeight: 100)
                        .focused($textFocused)
                } header: {
                    Text("Injury Description")
                } footer: {
                    Text("Describe the location and nature of the injury.")
                        .font(.caption)
                }

                Section {
                    Button("Delete Marker", role: .destructive, action: onDelete)
                }
            }
            .navigationTitle("Edit Marker")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button("Save") { onSave() }
                        .fontWeight(.semibold)
                }
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") { dismiss() }
                }
            }
            .onAppear { textFocused = true }
        }
        .presentationDetents([.medium, .large])
        .presentationDragIndicator(.visible)
    }
}

// MARK: - Body Map View --------------------------------------------------

struct BodyMapView: View {
    @Binding var markers: [BodyMapMarker]

    @State private var selectedBodyView: BodyView     = .front
    @State private var scale:            CGFloat      = 1.0
    @State private var lastScale:        CGFloat      = 1.0
    @State private var newMarkerIDs:     Set<UUID>    = []
    @State private var selectedMarker:   BodyMapMarker?
    @State private var editDescription:  String       = ""

    private let haptic = UIImpactFeedbackGenerator(style: .medium)

    // MARK: Helpers

    private var visibleMarkers: [BodyMapMarker] {
        markers.filter { $0.bodyView == selectedBodyView }
    }

    // MARK: Body

    var body: some View {
        VStack(spacing: 0) {
            // ── View picker ─────────────────────────────────────────────
            Picker("Body View", selection: $selectedBodyView) {
                ForEach(BodyView.allCases, id: \.self) { v in
                    Text(v.displayName).tag(v)
                }
            }
            .pickerStyle(.segmented)
            .padding(.horizontal, 16)
            .padding(.vertical, 12)

            // ── Canvas ──────────────────────────────────────────────────
            GeometryReader { proxy in
                let size = proxy.size

                ZStack(alignment: .topTrailing) {
                    // Background
                    Color.white

                    // Body fill + stroke
                    HumanBodyShape()
                        .fill(Color(.systemGray6))
                    HumanBodyShape()
                        .stroke(Color(.systemGray3), style: StrokeStyle(lineWidth: 1.5, lineJoin: .round))

                    // Subtle view label
                    Text(selectedBodyView.displayName.uppercased())
                        .font(.caption2.weight(.semibold))
                        .foregroundStyle(Color(.systemGray3))
                        .padding(10)

                    // Marker dots
                    ForEach(visibleMarkers, id: \.id) { marker in
                        MarkerDotView(isPulsing: newMarkerIDs.contains(marker.id))
                            .position(
                                x: marker.xPosition * size.width,
                                y: marker.yPosition * size.height
                            )
                            .onTapGesture {
                                selectedMarker  = marker
                                editDescription = marker.injuryDescription
                            }
                    }
                }
                // Zoom
                .scaleEffect(scale, anchor: .center)
                // Place marker on tap
                .onTapGesture { location in
                    placeMarker(at: location, in: size)
                }
                // Pinch to zoom
                .gesture(
                    MagnificationGesture()
                        .onChanged { value in
                            scale = (lastScale * value).clamped(to: 1.0...4.0)
                        }
                        .onEnded { _ in
                            lastScale = scale
                        }
                )
            }
            .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
            .overlay(
                RoundedRectangle(cornerRadius: 16, style: .continuous)
                    .stroke(Color(.systemGray4), lineWidth: 1)
            )
            .padding(.horizontal, 16)
            .padding(.bottom, 8)

            // ── Marker count badge ──────────────────────────────────────
            markerCountRow
                .padding(.horizontal, 16)
                .padding(.bottom, 8)
        }
        .background(Color(.systemGroupedBackground))
        // ── Toolbar ─────────────────────────────────────────────────────
        .toolbar {
            ToolbarItemGroup(placement: .topBarTrailing) {
                Button {
                    undoLastMarker()
                } label: {
                    Label("Undo", systemImage: "arrow.uturn.backward")
                        .labelStyle(.iconOnly)
                }
                .disabled(visibleMarkers.isEmpty)

                Button(role: .destructive) {
                    clearAllMarkers()
                } label: {
                    Label("Clear All", systemImage: "trash")
                        .labelStyle(.iconOnly)
                }
                .disabled(visibleMarkers.isEmpty)

                Button {
                    withAnimation(.spring(response: 0.35, dampingFraction: 0.7)) {
                        scale     = 1.0
                        lastScale = 1.0
                    }
                } label: {
                    Label("Reset Zoom", systemImage: "arrow.up.left.and.arrow.down.right")
                        .labelStyle(.iconOnly)
                }
                .disabled(scale == 1.0)
            }
        }
        // ── Marker edit popover ─────────────────────────────────────────
        .popover(item: $selectedMarker) { marker in
            MarkerPopover(
                description: $editDescription,
                onSave: {
                    if let idx = markers.firstIndex(where: { $0.id == marker.id }) {
                        markers[idx].injuryDescription = editDescription
                    }
                    selectedMarker = nil
                },
                onDelete: {
                    withAnimation(.easeOut(duration: 0.2)) {
                        markers.removeAll { $0.id == marker.id }
                    }
                    selectedMarker = nil
                }
            )
        }
    }

    // MARK: - Marker Count Row

    @ViewBuilder
    private var markerCountRow: some View {
        HStack(spacing: 6) {
            Image(systemName: "mappin.circle.fill")
                .foregroundStyle(.red)
                .font(.subheadline)
            let total = markers.count
            let front = markers.filter { $0.bodyView == .front }.count
            let back  = markers.filter { $0.bodyView == .back  }.count
            if total == 0 {
                Text("No markers placed")
                    .font(.caption)
                    .foregroundStyle(.secondary)
            } else {
                Text("\(front) front · \(back) back")
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
            Spacer()
            if !visibleMarkers.isEmpty {
                Text("Tap marker to edit")
                    .font(.caption2)
                    .foregroundStyle(.tertiary)
            }
        }
    }

    // MARK: - Actions

    private func placeMarker(at location: CGPoint, in size: CGSize) {
        // Map tap location from visual (scaled) space back to content space.
        let cx = size.width  / 2
        let cy = size.height / 2
        let contentX = (location.x - cx) / scale + cx
        let contentY = (location.y - cy) / scale + cy

        let nx = (contentX / size.width ).clamped(to: 0...1)
        let ny = (contentY / size.height).clamped(to: 0...1)

        // Skip if tapping within 22 pt of an existing marker (normalised threshold).
        let thresh = 22.0 / min(size.width, size.height)
        guard !visibleMarkers.contains(where: {
            abs($0.xPosition - nx) < thresh && abs($0.yPosition - ny) < thresh
        }) else { return }

        haptic.impactOccurred()

        let newMarker = BodyMapMarker(
            xPosition: nx,
            yPosition: ny,
            bodyView: selectedBodyView,
            injuryDescription: ""
        )

        withAnimation(.spring(response: 0.28, dampingFraction: 0.55)) {
            markers.append(newMarker)
        }

        newMarkerIDs.insert(newMarker.id)
        DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) {
            newMarkerIDs.remove(newMarker.id)
        }
    }

    private func undoLastMarker() {
        guard let idx = markers.indices.last(where: {
            markers[$0].bodyView == selectedBodyView
        }) else { return }
        withAnimation(.easeOut(duration: 0.2)) {
            markers.remove(at: idx)
        }
    }

    private func clearAllMarkers() {
        withAnimation(.easeOut(duration: 0.22)) {
            markers.removeAll { $0.bodyView == selectedBodyView }
        }
    }
}

// MARK: - Clamping helper ------------------------------------------------

private extension Comparable {
    func clamped(to range: ClosedRange<Self>) -> Self {
        Swift.min(Swift.max(self, range.lowerBound), range.upperBound)
    }
}

// MARK: - Preview --------------------------------------------------------

#Preview {
    @Previewable @State var markers: [BodyMapMarker] = []
    NavigationStack {
        BodyMapView(markers: $markers)
            .navigationTitle("Body Map")
            .navigationBarTitleDisplayMode(.inline)
    }
}
