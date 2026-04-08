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
                        let selected = starValue >= star
                        Button {
                            ratingValue = star * 2
                        } label: {
                            Image(systemName: selected ? "star.fill" : "star")
                                .font(.title3)
                                .foregroundStyle(selected ? Color.orange : palette.textSecondary)
                                .frame(width: 36, height: 36)
                                .background(
                                    Circle()
                                        .fill(palette.secondaryBackground)
                                )
                        }
                        .buttonStyle(.plain)
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
                                .foregroundStyle(value == ratingValue ? Color.white : palette.textPrimary)
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, 10)
                                .background(
                                    RoundedRectangle(cornerRadius: 14, style: .continuous)
                                        .fill(value == ratingValue ? palette.textPrimary : palette.secondaryBackground)
                                )
                        }
                        .buttonStyle(.plain)
                    }
                }
            }
        }
    }

    private var starValue: Int {
        max(1, Int(round(Double(ratingValue) / 2.0)))
    }
}
