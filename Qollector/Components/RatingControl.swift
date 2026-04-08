import SwiftUI

struct RatingControl: View {
    @Environment(\.appThemePalette) private var palette
    @Environment(\.appFontPreset) private var fontPreset
    let style: RatingStyle
    @Binding var ratingValue: Int

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            if style == .stars {
                starSelector
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

    private var starSelector: some View {
        HStack(spacing: 8) {
            ForEach(1...StarRatingValue.starCount, id: \.self) { star in
                starCell(for: star)
            }
        }
        .accessibilityElement(children: .contain)
        .accessibilityLabel("Rating")
        .accessibilityValue(StarRatingValue.accessibilityLabel(for: ratingValue))
    }

    private func starCell(for star: Int) -> some View {
        let fillState = StarRatingValue.fillState(for: star, ratingValue: ratingValue)

        return ZStack {
            Circle()
                .fill(palette.secondaryBackground)
                .frame(width: 44, height: 44)

            Image(systemName: fillState.symbolName)
                .font(.system(size: 20))
                .foregroundStyle(fillState == .empty ? palette.textSecondary : .orange)

            HStack(spacing: 0) {
                starHalfButton(value: (star * 2) - 1)
                starHalfButton(value: star * 2)
            }
            .frame(width: 44, height: 44)
        }
    }

    private func starHalfButton(value: Int) -> some View {
        Button {
            ratingValue = value
        } label: {
            Color.clear
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .contentShape(Rectangle())
        }
        .buttonStyle(.plain)
        .accessibilityLabel(StarRatingValue.accessibilityLabel(for: value))
        .accessibilityAddTraits(value == ratingValue ? .isSelected : [])
    }
}
