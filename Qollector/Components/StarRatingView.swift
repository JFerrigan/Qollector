import SwiftUI

struct StarRatingView: View {
    let ratingValue: Int
    var size: CGFloat = 16
    var activeColor: Color = .orange
    var inactiveColor: Color = .secondary

    var body: some View {
        HStack(spacing: 4) {
            ForEach(1...5, id: \.self) { index in
                let fillState = StarRatingValue.fillState(for: index, ratingValue: ratingValue)

                Image(systemName: fillState.symbolName)
                    .font(.system(size: size))
                    .foregroundStyle(fillState == .empty ? inactiveColor : activeColor)
            }
        }
        .accessibilityElement(children: .ignore)
        .accessibilityLabel(StarRatingValue.accessibilityLabel(for: ratingValue))
    }
}
