import SwiftUI
import SwiftData

struct LibraryPickerBar: View {
    @Environment(\.appThemePalette) private var palette
    @Environment(\.appFontPreset) private var fontPreset
    let libraries: [Library]
    @Binding var selectedLibraryID: PersistentIdentifier?
    var trailingActionTitle: String?
    var trailingAction: (() -> Void)?

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 10) {
                    ForEach(libraries) { library in
                        Button {
                            selectedLibraryID = library.persistentModelID
                        } label: {
                            Text(library.name)
                                .font(fontPreset.textStyle(.subheadline, weight: .semibold))
                                .foregroundStyle(isSelected(library) ? palette.accentContent : palette.textPrimary)
                                .padding(.horizontal, 14)
                                .padding(.vertical, 10)
                                .background(
                                    RoundedRectangle(cornerRadius: 16, style: .continuous)
                                        .fill(isSelected(library) ? palette.accentFill : palette.secondaryBackground)
                                )
                        }
                        .buttonStyle(.plain)
                    }
                }
            }

            if let trailingActionTitle, let trailingAction {
                Button(trailingActionTitle, action: trailingAction)
                    .font(fontPreset.textStyle(.subheadline, weight: .semibold))
                    .foregroundStyle(palette.textPrimary)
            }
        }
    }

    private func isSelected(_ library: Library) -> Bool {
        selectedLibraryID == library.persistentModelID
    }
}
