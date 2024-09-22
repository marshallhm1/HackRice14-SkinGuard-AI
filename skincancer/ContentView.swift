import SwiftUI
import SwiftData

struct ContentView: View {
    @Environment(\.modelContext) private var modelContext

    var body: some View {
        TabView {
            HomeView()
                .tabItem {
                    Image(systemName: "house.fill")
                    Text("Home")
                }

            ReportsView()
                .tabItem {
                    Image(systemName: "doc.plaintext")
                    Text("Reports")
                }

            CameraView()
                .tabItem {
                    Image(systemName: "camera.fill")
                    Text("Analyze")
                }

            TipsView()
                .tabItem {
                    Image(systemName: "lightbulb.fill")
                    Text("Prevention")
                }

        }
    }
}
