import SwiftUI

struct RecordArtworkView: View {
    let recipe: RecordIconRecipe
    var size: CGFloat = 96

    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: size * 0.22, style: .continuous)
                .fill(recipe.baseColor.color)

            patternView
                .clipShape(RoundedRectangle(cornerRadius: size * 0.22, style: .continuous))

            Circle()
                .fill(recipe.labelColor.color)
                .frame(width: size * 0.42)

            Circle()
                .fill(recipe.accentColor.color.opacity(0.85))
                .frame(width: size * 0.11)
        }
        .frame(width: size, height: size)
        .overlay(
            RoundedRectangle(cornerRadius: size * 0.22, style: .continuous)
                .stroke(AppTheme.line.opacity(0.35), lineWidth: 1)
        )
    }

    @ViewBuilder
    private var patternView: some View {
        switch recipe.pattern {
        case .rings:
            ZStack {
                Circle().stroke(recipe.accentColor.color.opacity(0.4), lineWidth: size * 0.08).padding(size * 0.08)
                Circle().stroke(recipe.accentColor.color.opacity(0.22), lineWidth: size * 0.06).padding(size * 0.20)
            }
        case .split:
            HStack(spacing: 0) {
                recipe.accentColor.color.opacity(0.85)
                recipe.baseColor.color.opacity(0.0)
            }
        case .waves:
            VStack(spacing: size * 0.08) {
                ForEach(0..<4, id: \.self) { _ in
                    Capsule()
                        .fill(recipe.accentColor.color.opacity(0.28))
                        .frame(height: size * 0.1)
                }
            }
            .padding(size * 0.12)
        case .orbit:
            Circle()
                .stroke(recipe.accentColor.color.opacity(0.35), lineWidth: size * 0.06)
                .padding(size * 0.12)
                .overlay(alignment: .topTrailing) {
                    Circle()
                        .fill(recipe.accentColor.color.opacity(0.9))
                        .frame(width: size * 0.14)
                        .padding(size * 0.12)
                }
        case .checker:
            VStack(spacing: 0) {
                ForEach(0..<4, id: \.self) { row in
                    HStack(spacing: 0) {
                        ForEach(0..<4, id: \.self) { column in
                            Rectangle()
                                .fill((row + column).isMultiple(of: 2) ? recipe.accentColor.color.opacity(0.25) : .clear)
                        }
                    }
                }
            }
            .padding(size * 0.1)
        }
    }
}

