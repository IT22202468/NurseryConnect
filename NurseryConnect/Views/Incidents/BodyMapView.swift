import SwiftUI

// MARK: - Human Body Shape

/// Single-path silhouette of a standing human. All control points are normalised (0–1).
struct HumanBodyShape: Shape {
    func path(in rect: CGRect) -> Path {
        let w = rect.width
        let h = rect.height

        func pt(_ nx: CGFloat, _ ny: CGFloat) -> CGPoint {
            CGPoint(x: rect.minX + nx * w, y: rect.minY + ny * h)
        }

        var path = Path()

        // Head
        path.addEllipse(in: CGRect(
            x: rect.minX + 0.375 * w,
            y: rect.minY,
            width:  0.25  * w,
            height: 0.175 * h
        ))

        // Body silhouette
        path.move(to: pt(0.44, 0.175))

        path.addCurve(to: pt(0.195, 0.265), control1: pt(0.370, 0.195), control2: pt(0.265, 0.233))
        path.addCurve(to: pt(0.125, 0.555), control1: pt(0.155, 0.310), control2: pt(0.113, 0.445))
        path.addCurve(to: pt(0.114, 0.635), control1: pt(0.120, 0.575), control2: pt(0.107, 0.605))
        path.addCurve(to: pt(0.215, 0.640), control1: pt(0.110, 0.668), control2: pt(0.204, 0.668))
        path.addCurve(to: pt(0.278, 0.305), control1: pt(0.225, 0.580), control2: pt(0.248, 0.440))
        path.addCurve(to: pt(0.268, 0.595), control1: pt(0.264, 0.400), control2: pt(0.255, 0.515))
        path.addCurve(to: pt(0.307, 0.625), control1: pt(0.262, 0.622), control2: pt(0.277, 0.634))
        path.addCurve(to: pt(0.287, 0.896), control1: pt(0.284, 0.725), control2: pt(0.276, 0.833))
        path.addCurve(to: pt(0.194, 0.946), control1: pt(0.281, 0.929), control2: pt(0.222, 0.946))
        path.addLine(to: pt(0.388, 0.956))
        path.addCurve(to: pt(0.387, 0.902), control1: pt(0.395, 0.964), control2: pt(0.395, 0.936))
        path.addCurve(to: pt(0.415, 0.626), control1: pt(0.392, 0.830), control2: pt(0.403, 0.725))
        path.addCurve(to: pt(0.585, 0.626), control1: pt(0.428, 0.672), control2: pt(0.572, 0.672))
        path.addCurve(to: pt(0.613, 0.902), control1: pt(0.597, 0.725), control2: pt(0.608, 0.830))
        path.addCurve(to: pt(0.612, 0.956), control1: pt(0.605, 0.936), control2: pt(0.605, 0.964))
        path.addLine(to: pt(0.806, 0.946))
        path.addCurve(to: pt(0.713, 0.896), control1: pt(0.778, 0.946), control2: pt(0.719, 0.929))
        path.addCurve(to: pt(0.693, 0.625), control1: pt(0.724, 0.833), control2: pt(0.716, 0.725))
        path.addCurve(to: pt(0.732, 0.595), control1: pt(0.723, 0.634), control2: pt(0.738, 0.622))
        path.addCurve(to: pt(0.722, 0.305), control1: pt(0.745, 0.515), control2: pt(0.736, 0.400))
        path.addCurve(to: pt(0.785, 0.640), control1: pt(0.752, 0.440), control2: pt(0.775, 0.580))
        path.addCurve(to: pt(0.886, 0.635), control1: pt(0.796, 0.668), control2: pt(0.879, 0.668))
        path.addCurve(to: pt(0.875, 0.555), control1: pt(0.893, 0.605), control2: pt(0.881, 0.575))
        path.addCurve(to: pt(0.805, 0.265), control1: pt(0.887, 0.445), control2: pt(0.845, 0.310))
        path.addCurve(to: pt(0.560, 0.175), control1: pt(0.735, 0.233), control2: pt(0.630, 0.195))
        path.closeSubpath()

        return path
    }
}

// MARK: - Body Map View

struct BodyMapView: View {
    @Binding var annotations: [BodyMapAnnotation]
    @Binding var currentSide: BodySide

    @State private var pendingAnnotation: BodyMapAnnotation? = nil
    @State private var pendingNote: String = ""

    private let haptic = UIImpactFeedbackGenerator(style: .medium)

    private var visibleAnnotations: [BodyMapAnnotation] {
        annotations.filter { $0.side == currentSide }
    }

    var body: some View {
        VStack(spacing: 0) {
            GeometryReader { proxy in
                let size = proxy.size

                ZStack(alignment: .bottom) {
                    Color.white

                    // Silhouette
                    HumanBodyShape()
                        .fill(Color.gray.opacity(0.15))
                    HumanBodyShape()
                        .stroke(Color.gray.opacity(0.4), style: StrokeStyle(lineWidth: 1.5, lineJoin: .round))

                    // Side label
                    Text(currentSide.displayName.uppercased())
                        .font(.system(size: 10, weight: .semibold))
                        .foregroundStyle(Color.gray.opacity(0.4))
                        .padding(.bottom, 8)

                    // Annotation dots
                    ForEach(visibleAnnotations) { annotation in
                        Circle()
                            .fill(Color.brandPurple)
                            .frame(width: 12, height: 12)
                            .position(
                                x: CGFloat(annotation.x) * size.width,
                                y: CGFloat(annotation.y) * size.height
                            )
                    }

                    // Inline note prompt
                    if pendingAnnotation != nil {
                        VStack(spacing: 8) {
                            Text("Describe the injury location")
                                .font(.captionText)
                                .foregroundStyle(.gray)
                            TextField("e.g. Graze on left knee", text: $pendingNote)
                                .textFieldStyle(BrandTextFieldStyle())
                            HStack(spacing: 12) {
                                Button("Cancel") {
                                    pendingAnnotation = nil
                                    pendingNote = ""
                                }
                                .foregroundStyle(.gray)
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, 8)
                                .background(Color.gray.opacity(0.1))
                                .clipShape(RoundedRectangle(cornerRadius: 8))

                                Button("Add") {
                                    if var ann = pendingAnnotation {
                                        ann.note = pendingNote
                                        withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                                            annotations.append(ann)
                                        }
                                    }
                                    pendingAnnotation = nil
                                    pendingNote = ""
                                }
                                .foregroundStyle(.white)
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, 8)
                                .background(Color.brandPurple)
                                .clipShape(RoundedRectangle(cornerRadius: 8))
                            }
                        }
                        .padding(12)
                        .background(Color.white.opacity(0.97))
                        .clipShape(RoundedRectangle(cornerRadius: 12))
                        .shadow(color: .black.opacity(0.1), radius: 8)
                        .padding(.horizontal, 16)
                        .padding(.bottom, 12)
                        .transition(.move(edge: .bottom).combined(with: .opacity))
                    }
                }
                .contentShape(Rectangle())
                .onTapGesture { location in
                    guard pendingAnnotation == nil else { return }
                    let nx = Float((location.x / size.width).clamped(to: 0...1))
                    let ny = Float((location.y / size.height).clamped(to: 0...1))

                    // Dedup: don't place within ~22pt of existing
                    let thresh = Float(22.0 / min(size.width, size.height))
                    guard !visibleAnnotations.contains(where: {
                        abs($0.x - nx) < thresh && abs($0.y - ny) < thresh
                    }) else { return }

                    haptic.impactOccurred()
                    withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                        pendingAnnotation = BodyMapAnnotation(x: nx, y: ny, side: currentSide, note: "")
                    }
                }
            }
            .clipShape(RoundedRectangle(cornerRadius: 16))
            .overlay(RoundedRectangle(cornerRadius: 16).stroke(Color.gray.opacity(0.2), lineWidth: 1))
        }
        .animation(.spring(response: 0.3, dampingFraction: 0.7), value: pendingAnnotation == nil)
    }
}

// MARK: - Clamping helper

private extension Comparable {
    func clamped(to range: ClosedRange<Self>) -> Self {
        Swift.min(Swift.max(self, range.lowerBound), range.upperBound)
    }
}
