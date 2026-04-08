import SwiftUI

struct TagChipView: View {
    let title: String
    let colorToken: VinylColorToken

    var body: some View {
        Text(title)
            .font(.caption.weight(.semibold))
            .foregroundStyle(AppTheme.textPrimary)
            .padding(.horizontal, 10)
            .padding(.vertical, 6)
            .background(
                Capsule(style: .continuous)
                    .fill(colorToken.color.opacity(0.55))
            )
            .overlay(
                Capsule(style: .continuous)
                    .stroke(AppTheme.line.opacity(0.35), lineWidth: 1)
            )
    }
}

