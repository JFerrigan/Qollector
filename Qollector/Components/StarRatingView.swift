import SwiftUI

struct StarRatingView: View {
    let ratingValue: Int
    var size: CGFloat = 16
    var activeColor: Color = .orange
    var inactiveColor: Color = .secondary

    var body: some View {
        HStack(spacing: 4) {
            ForEach(1...5, id: \.self) { index in
                Image(systemName: symbolName(for: index))
                    .font(.system(size: size))
                    .foregroundStyle(symbolName(for: index) == "star" ? inactiveColor : activeColor)
            }
        }
        .accessibilityElement(children: .ignore)
        .accessibilityLabel(accessibilityLabel)
    }

    private func symbolName(for index: Int) -> String {
        let threshold = index * 2
        if ratingValue >= threshold {
            return "star.fill"
        }

        if ratingValue == threshold - 1 {
            return "star.leadinghalf.filled"
        }

        return "star"
    }

    private var accessibilityLabel: String {
        let stars = Double(ratingValue) / 2.0
        return "\(stars.formatted(.number.precision(.fractionLength(ratingValue.isMultiple(of: 2) ? 0 : 1)))) stars"
    }
}
