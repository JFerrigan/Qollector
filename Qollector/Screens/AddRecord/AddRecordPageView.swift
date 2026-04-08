import SwiftData
import SwiftUI

struct AddRecordPageView: View {
    @Environment(\.modelContext) private var modelContext
    @Query private var settings: [AppSettings]
    @State private var draft = RecordDraft()
    let onSaveCompleted: () -> Void

    var body: some View {
        RecordFormView(
            title: "",
            saveButtonTitle: "Save",
            ratingStyle: settings.first?.preferredRatingStyle ?? .stars,
            draft: $draft
        ) {
            RecordEditor.createRecord(from: draft, in: modelContext)
            draft = RecordDraft()
            onSaveCompleted()
        }
        .accessibilityIdentifier("page.add")
    }
}
