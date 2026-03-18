import SwiftUI
import SwiftData

struct ContentView: View {
    @Environment(\.modelContext) private var modelContext
    @Query private var packs: [ContentPack]
    
    var body: some View {
        TabView {
            ScreensaverView()
                .tabItem {
                    Label("Play", systemImage: "play.circle.fill")
                }
            
            PackBrowserView()
                .tabItem {
                    Label("Packs", systemImage: "square.stack.3d.up")
                }
            
            SettingsView()
                .tabItem {
                    Label("Settings", systemImage: "gear")
                }
        }
        .preferredColorScheme(.dark)
        .onAppear {
            initializePlaceholderData()
        }
    }
    
    private func initializePlaceholderData() {
        guard packs.isEmpty else { return }
        
        Logger.shared.info("Initializing placeholder packs...")
        
        let coastalPack = createCoastalMorningsPack()
        let tropicalPack = createTropicalCalmPack()
        
        modelContext.insert(coastalPack)
        modelContext.insert(tropicalPack)
        
        let prefs = UserPreferences(
            selectedPackIDs: [coastalPack.id, tropicalPack.id]
        )
        modelContext.insert(prefs)
        
        try? modelContext.save()
        
        Logger.shared.info("✅ Placeholder data initialized")
    }
    
    private func createCoastalMorningsPack() -> ContentPack {
        let pack = ContentPack(
            name: "Coastal Mornings",
            theme: "Pacific Northwest beaches, tide pools, morning fog",
            price: nil,
            productID: nil,
            isPurchased: true,
            musicTrackFilename: nil,
            thumbnailFilename: "coastal-thumb.jpg"
        )
        
        let scenes = [
            Scene(filename: "coastal-1", type: .photo, timeOfDay: .morning, weatherCondition: .clear, transitionStyle: .kenBurns, duration: 30),
            Scene(filename: "coastal-2", type: .photo, timeOfDay: .morning, weatherCondition: .cloudy, transitionStyle: .kenBurns, duration: 30),
            Scene(filename: "coastal-3", type: .photo, timeOfDay: .afternoon, weatherCondition: .any, transitionStyle: .crossfade, duration: 30),
            Scene(filename: "coastal-4", type: .photo, timeOfDay: .evening, weatherCondition: .clear, transitionStyle: .kenBurns, duration: 30),
            Scene(filename: "coastal-5", type: .photo, timeOfDay: .any, weatherCondition: .rain, transitionStyle: .crossfade, duration: 30)
        ]
        
        scenes.forEach { pack.scenes.append($0) }
        
        return pack
    }
    
    private func createTropicalCalmPack() -> ContentPack {
        let pack = ContentPack(
            name: "Tropical Calm",
            theme: "Waterfalls, jungle canopies, island sunsets",
            price: nil,
            productID: nil,
            isPurchased: true,
            musicTrackFilename: nil,
            thumbnailFilename: "tropical-thumb.jpg"
        )
        
        let scenes = [
            Scene(filename: "tropical-1", type: .photo, timeOfDay: .morning, weatherCondition: .clear, transitionStyle: .kenBurns, duration: 30),
            Scene(filename: "tropical-2", type: .photo, timeOfDay: .afternoon, weatherCondition: .clear, transitionStyle: .parallax, duration: 30),
            Scene(filename: "tropical-3", type: .photo, timeOfDay: .evening, weatherCondition: .clear, transitionStyle: .kenBurns, duration: 30),
            Scene(filename: "tropical-4", type: .photo, timeOfDay: .any, weatherCondition: .rain, transitionStyle: .crossfade, duration: 30),
            Scene(filename: "tropical-5", type: .photo, timeOfDay: .night, weatherCondition: .any, transitionStyle: .kenBurns, duration: 30)
        ]
        
        scenes.forEach { pack.scenes.append($0) }
        
        return pack
    }
}
