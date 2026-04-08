import SwiftData
import SwiftUI

struct EditRecordView: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(\.modelContext) private var modelContext
    @Query private var settings: [AppSettings]
    @State private var draft: RecordDraft
    let record: RecordItem

    init(record: RecordItem) {
        self.record = record
        _draft = State(initialValue: RecordDraft(record: record))
    }

    var body: some View {
        NavigationStack {
            RecordFormView(
                title: "",
                saveButtonTitle: "Save",
                ratingStyle: settings.first?.preferredRatingStyle ?? .stars,
                draft: $draft
            ) {
                RecordEditor.update(record: record, from: draft, in: modelContext)
                dismiss()
            }
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button("Close") { dismiss() }
                }
            }
        }
    }
}
