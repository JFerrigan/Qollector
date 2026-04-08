import SwiftUI

struct RatingControl: View {
    @Environment(\.appThemePalette) private var palette
    @Environment(\.appFontPreset) private var fontPreset
    let style: RatingStyle
    @Binding var ratingValue: Int

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            if style == .stars {
                HStack(spacing: 10) {
                    ForEach(1...5, id: \.self) { star in
                        ZStack {
                            StarRatingView(
                                ratingValue: symbolValue(for: star),
                                size: 20,
                                activeColor: .orange,
                                inactiveColor: palette.textSecondary
                            )

                            HStack(spacing: 0) {
                                Button {
                                    ratingValue = (star * 2) - 1
                                } label: {
                                    Color.clear
                                }

                                Button {
                                    ratingValue = star * 2
                                } label: {
                                    Color.clear
                                }
                            }
                            .buttonStyle(.plain)
                        }
                        .frame(width: 36, height: 36)
                        .background(
                            Circle()
                                .fill(palette.secondaryBackground)
                        )
                    }
                }
            } else {
                LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: 8), count: 5), spacing: 8) {
                    ForEach(1...10, id: \.self) { value in
                        Button {
                            ratingValue = value
                        } label: {
                            Text("\(value)")
                                .font(fontPreset.textStyle(.subheadline, weight: .semibold))
                                .foregroundStyle(value == ratingValue ? palette.accentContent : palette.textPrimary)
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, 10)
                                .background(
                                    RoundedRectangle(cornerRadius: 14, style: .continuous)
                                        .fill(value == ratingValue ? palette.accentFill : palette.secondaryBackground)
                                )
                        }
                        .buttonStyle(.plain)
                    }
                }
            }
        }
    }

    private func symbolValue(for star: Int) -> Int {
        min(max(ratingValue - ((star - 1) * 2), 0), 2)
    }
}
