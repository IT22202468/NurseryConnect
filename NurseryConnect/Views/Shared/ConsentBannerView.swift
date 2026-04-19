import SwiftUI

struct ConsentBannerView: View {
    var body: some View {
        HStack(spacing: 8) {
            Image(systemName: "camera.slash.fill")
                .foregroundStyle(.white)
            Text("No Photography Consent — Do not photograph this child")
                .font(.system(size: 12, weight: .semibold))
                .foregroundStyle(.white)
            Spacer()
        }
        .padding(12)
        .frame(maxWidth: .infinity)
        .background(Color.red)
        .clipShape(RoundedRectangle(cornerRadius: 12))
    }
}
