import SwiftUI

enum RootPage: Int, CaseIterable {
    case search
    case library
    case add
    case settings
}

struct RootPagerView: View {
    @State private var selectedPage: RootPage = .library
    @State private var selectedRecord: RecordItem?

    var body: some View {
        NavigationStack {
            TabView(selection: $selectedPage) {
                SearchPageView(onSelectRecord: openRecord)
                    .tag(RootPage.search)

                LibraryPageView(onSelectRecord: openRecord)
                    .tag(RootPage.library)

                AddRecordPageView {
                    selectedPage = .library
                }
                .tag(RootPage.add)

                SettingsPageView()
                    .tag(RootPage.settings)
            }
            .tabViewStyle(.page(indexDisplayMode: .never))
            .background(AppTheme.background.ignoresSafeArea())
            .sheet(item: $selectedRecord) { record in
                RecordDetailView(record: record)
            }
        }
    }

    private func openRecord(_ record: RecordItem) {
        selectedRecord = record
    }
}

