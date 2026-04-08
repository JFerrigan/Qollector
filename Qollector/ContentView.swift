import SwiftData
import SwiftUI

struct ContentView: View {
    @Environment(\.modelContext) private var modelContext
    @State private var didBootstrap = false

    var body: some View {
        RootPagerView()
            .task {
                guard !didBootstrap else { return }
                didBootstrap = true
                AppBootstrap.bootstrap(in: modelContext)
            }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .modelContainer(PreviewContainer.shared)
    }
}
