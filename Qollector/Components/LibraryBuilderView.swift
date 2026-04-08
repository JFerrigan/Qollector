import SwiftUI

struct LibraryBuilderView: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(\.appThemePalette) private var palette
    @Environment(\.appFontPreset) private var fontPreset
    @State private var draft: LibraryDraft
    let onCreate: (LibraryDraft) -> Void

    init(initialDraft: LibraryDraft = LibraryDraft(), onCreate: @escaping (LibraryDraft) -> Void) {
        self._draft = State(initialValue: initialDraft)
        self.onCreate = onCreate
    }

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: AppTheme.sectionSpacing) {
                    presetSection
                        .cardSurface(palette.surfaceButter)

                    basicsSection
                        .cardSurface(palette.surfaceRose)

                    mappingSection
                        .cardSurface(palette.surfaceMint)

                    previewSection
                        .cardSurface(palette.surfaceSky)
                }
                .padding(AppTheme.outerPadding)
            }
            .background(palette.background)
            .navigationTitle("New Library")
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button("Close") { dismiss() }
                }

                ToolbarItem(placement: .topBarTrailing) {
                    Button("Create") {
                        onCreate(draft.normalized())
                        dismiss()
                    }
                    .disabled(!canCreate)
                }
            }
        }
    }

    private var presetSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Preset")
                .font(fontPreset.textStyle(.headline, weight: .semibold))
                .foregroundStyle(palette.textPrimary)

            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 10) {
                    ForEach(LibraryPresetDefinition.allCases) { preset in
                        Button {
                            draft = LibraryDraft(preset: preset)
                        } label: {
                            VStack(alignment: .leading, spacing: 8) {
                                Text(preset.kind.title)
                                    .font(fontPreset.textStyle(.subheadline, weight: .semibold))
                                Text(preset.name)
                                    .font(fontPreset.textStyle(.caption))
                                    .foregroundStyle(palette.textSecondary)
                            }
                            .frame(width: 140, alignment: .leading)
                            .padding(14)
                            .background(
                                RoundedRectangle(cornerRadius: 18, style: .continuous)
                                    .fill(draft.presetKind == preset.kind ? palette.accentFill.opacity(0.16) : palette.secondaryBackground)
                            )
                        }
                        .buttonStyle(.plain)
                    }

                    Button {
                        draft = LibraryDraft()
                    } label: {
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Custom")
                                .font(fontPreset.textStyle(.subheadline, weight: .semibold))
                            Text("Start from scratch")
                                .font(fontPreset.textStyle(.caption))
                                .foregroundStyle(palette.textSecondary)
                        }
                        .frame(width: 140, alignment: .leading)
                        .padding(14)
                        .background(
                            RoundedRectangle(cornerRadius: 18, style: .continuous)
                                .fill(draft.presetKind == .custom ? palette.accentFill.opacity(0.16) : palette.secondaryBackground)
                        )
                    }
                    .buttonStyle(.plain)
                }
            }
        }
    }

    private var basicsSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Fields")
                .font(fontPreset.textStyle(.headline, weight: .semibold))
                .foregroundStyle(palette.textPrimary)

            TextField("Library Name", text: $draft.name)
                .font(fontPreset.textStyle(.body))
                .padding(14)
                .background(
                    RoundedRectangle(cornerRadius: AppTheme.innerRadius, style: .continuous)
                        .fill(palette.secondaryBackground)
                )

            ForEach(Array(draft.fieldDefinitions.enumerated()), id: \.element.id) { index, field in
                VStack(alignment: .leading, spacing: 8) {
                    TextField("Field Label", text: binding(for: index, keyPath: \.label))
                        .font(fontPreset.textStyle(.body))
                        .padding(12)
                        .background(
                            RoundedRectangle(cornerRadius: 14, style: .continuous)
                                .fill(palette.secondaryBackground)
                        )

                    HStack {
                        ForEach(LibraryFieldType.allCases) { type in
                            Button {
                                draft.fieldDefinitions[index].type = type
                            } label: {
                                Text(type.title)
                                    .font(fontPreset.textStyle(.caption, weight: .semibold))
                                    .foregroundStyle(draft.fieldDefinitions[index].type == type ? palette.accentContent : palette.textPrimary)
                                    .padding(.horizontal, 10)
                                    .padding(.vertical, 8)
                                    .background(
                                        RoundedRectangle(cornerRadius: 12, style: .continuous)
                                            .fill(draft.fieldDefinitions[index].type == type ? palette.accentFill : palette.secondaryBackground)
                                    )
                            }
                            .buttonStyle(.plain)
                        }

                        Spacer()

                        Button("Remove") {
                            removeField(at: index)
                        }
                        .font(fontPreset.textStyle(.caption, weight: .semibold))
                        .foregroundStyle(.red)
                    }
                }
            }

            Button("Add Field") {
                draft.fieldDefinitions.append(
                    LibraryFieldDefinition(label: "New Field", type: .text)
                )
            }
            .font(fontPreset.textStyle(.subheadline, weight: .semibold))
        }
    }

    private var mappingSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Card Layout")
                .font(fontPreset.textStyle(.headline, weight: .semibold))
                .foregroundStyle(palette.textPrimary)

            mappingSelector(title: "Title", selection: $draft.cardConfiguration.titleFieldID)

            mappingSelector(title: "Subtitle", selection: Binding(
                get: { draft.cardConfiguration.subtitleFieldID ?? "" },
                set: { draft.cardConfiguration.subtitleFieldID = $0.isEmpty ? nil : $0 }
            ), allowEmpty: true)

            metadataSelector
        }
    }

    private var metadataSelector: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Metadata")
                .font(fontPreset.textStyle(.subheadline, weight: .semibold))

            ForEach(0..<2, id: \.self) { index in
                mappingSelector(
                    title: "Slot \(index + 1)",
                    selection: Binding(
                        get: { draft.cardConfiguration.metadataFieldIDs.indices.contains(index) ? draft.cardConfiguration.metadataFieldIDs[index] : "" },
                        set: { updateMetadataField(at: index, with: $0) }
                    ),
                    allowEmpty: true
                )
            }
        }
    }

    private var previewSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Preview")
                .font(fontPreset.textStyle(.headline, weight: .semibold))
                .foregroundStyle(palette.textPrimary)

            previewCard(snapshot: LibraryCardSnapshot(draft: draft.normalized()))
        }
    }

    private func previewCard(snapshot: LibraryCardSnapshot) -> some View {
        HStack(alignment: .top, spacing: 16) {
            RoundedRectangle(cornerRadius: 16, style: .continuous)
                .fill(palette.surfaceMint)
                .frame(width: 78, height: 78)

            VStack(alignment: .leading, spacing: 8) {
                Text(snapshot.title)
                    .font(fontPreset.textStyle(.headline, weight: .semibold))
                    .foregroundStyle(palette.textPrimary)

                if let subtitle = snapshot.subtitle {
                    Text(subtitle)
                        .font(fontPreset.textStyle(.subheadline))
                        .foregroundStyle(palette.textSecondary)
                }

                ForEach(snapshot.metadata, id: \.self) { value in
                    Text(value)
                        .font(fontPreset.textStyle(.caption))
                        .foregroundStyle(palette.textSecondary)
                }
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(16)
        .background(
            RoundedRectangle(cornerRadius: 22, style: .continuous)
                .fill(palette.secondaryBackground)
        )
    }

    private func mappingSelector(title: String, selection: Binding<String>, allowEmpty: Bool = false) -> some View {
        VStack(alignment: .leading, spacing: 6) {
            Text(title)
                .font(fontPreset.textStyle(.subheadline, weight: .semibold))

            Menu {
                if allowEmpty {
                    Button("None") { selection.wrappedValue = "" }
                }

                ForEach(draft.fieldDefinitions) { field in
                    Button(field.label) {
                        selection.wrappedValue = field.id
                    }
                }
            } label: {
                HStack {
                    Text(selectedFieldLabel(for: selection.wrappedValue) ?? "None")
                    Spacer()
                    Image(systemName: "chevron.down")
                }
                .font(fontPreset.textStyle(.body))
                .foregroundStyle(palette.textPrimary)
                .padding(12)
                .background(
                    RoundedRectangle(cornerRadius: 14, style: .continuous)
                        .fill(palette.secondaryBackground)
                )
            }
        }
    }

    private func selectedFieldLabel(for fieldID: String) -> String? {
        draft.fieldDefinitions.first(where: { $0.id == fieldID })?.label
    }

    private func updateMetadataField(at index: Int, with fieldID: String) {
        while draft.cardConfiguration.metadataFieldIDs.count <= index {
            draft.cardConfiguration.metadataFieldIDs.append("")
        }

        draft.cardConfiguration.metadataFieldIDs[index] = fieldID
    }

    private func removeField(at index: Int) {
        let removed = draft.fieldDefinitions[index]
        draft.fieldDefinitions.remove(at: index)
        if draft.cardConfiguration.titleFieldID == removed.id {
            draft.cardConfiguration.titleFieldID = draft.fieldDefinitions.first?.id ?? ""
        }
        if draft.cardConfiguration.subtitleFieldID == removed.id {
            draft.cardConfiguration.subtitleFieldID = nil
        }
        draft.cardConfiguration.metadataFieldIDs.removeAll { $0 == removed.id }
    }

    private func binding(for index: Int, keyPath: WritableKeyPath<LibraryFieldDefinition, String>) -> Binding<String> {
        Binding(
            get: { draft.fieldDefinitions[index][keyPath: keyPath] },
            set: { draft.fieldDefinitions[index][keyPath: keyPath] = $0 }
        )
    }

    private var canCreate: Bool {
        !draft.name.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty &&
        !draft.fieldDefinitions.isEmpty &&
        !draft.cardConfiguration.titleFieldID.isEmpty
    }
}

private extension LibraryDraft {
    func normalized() -> LibraryDraft {
        var copy = self
        copy.name = copy.name.trimmingCharacters(in: .whitespacesAndNewlines)
        copy.fieldDefinitions = copy.fieldDefinitions.enumerated().map { index, field in
            var updated = field
            updated.label = field.label.trimmingCharacters(in: .whitespacesAndNewlines)
            if updated.label.isEmpty {
                updated.label = "Field \(index + 1)"
            }
            return updated
        }
        copy.cardConfiguration.metadataFieldIDs = Array(copy.sortedMetadataFieldIDs.prefix(2))
        if copy.cardConfiguration.titleFieldID.isEmpty {
            copy.cardConfiguration.titleFieldID = copy.fieldDefinitions.first?.id ?? ""
        }
        return copy
    }
}
