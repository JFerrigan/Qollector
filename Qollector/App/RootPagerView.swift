import SwiftUI
import SwiftData

enum RootPage: Int, CaseIterable {
    case search
    case library
    case add
    case settings
}

struct RootPagerView: View {
    @Query private var settings: [AppSettings]
    @State private var selectedPage: RootPage = .library
    @State private var selectedRecord: RecordItem?

    var body: some View {
        NavigationStack {
            ZStack {
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
                .background(palette.background.ignoresSafeArea())

                if let selectedRecord {
                    RecordDetailView(
                        record: selectedRecord,
                        onClose: closeRecord
                    )
                    .zIndex(1)
                    .transition(.move(edge: .bottom).combined(with: .opacity))
                }
            }
            .animation(.spring(response: 0.32, dampingFraction: 0.86), value: selectedRecord != nil)
            .environment(\.appThemePalette, palette)
            .environment(\.appFontPreset, fontPreset)
        }
    }

    private func openRecord(_ record: RecordItem) {
        selectedRecord = record
    }

    private func closeRecord() {
        selectedRecord = nil
    }

    private var activeSettings: AppSettings? {
        settings.first
    }

    private var palette: AppThemePalette {
        AppTheme.palette(for: activeSettings?.backgroundPreset ?? .rose)
    }

    private var fontPreset: AppFontPreset {
        activeSettings?.fontPreset ?? .rounded
    }
}
