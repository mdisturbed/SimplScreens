import SwiftUI
import SwiftData

@main
struct SimplScreensApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
                .preferredColorScheme(.dark) // MANDATORY — Jay has vision issues
        }
        .modelContainer(for: [ContentPack.self, Scene.self, UserPreferences.self])
    }
}
