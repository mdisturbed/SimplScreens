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
            theme: "Ocean waves, sunrise, and coastal scenery",
            price: nil,
            productID: nil,
            isPurchased: true,
            musicTrackFilename: nil,
            thumbnailFilename: "coastal-thumb.jpg"
        )
        
        let scenes = [
            Scene(filename: "golden-hour-beach.mp4", type: .video, timeOfDay: .morning, weatherCondition: .any, transitionStyle: .crossfade, duration: 23),
            Scene(filename: "lighthouse-sunrise.mp4", type: .video, timeOfDay: .morning, weatherCondition: .any, transitionStyle: .crossfade, duration: 15),
            Scene(filename: "seacoast-aerial.mp4", type: .video, timeOfDay: .morning, weatherCondition: .any, transitionStyle: .crossfade, duration: 24),
            Scene(filename: "slow-motion-waves.mp4", type: .video, timeOfDay: .morning, weatherCondition: .any, transitionStyle: .crossfade, duration: 85),
            Scene(filename: "sunrise-from-shore.mp4", type: .video, timeOfDay: .morning, weatherCondition: .any, transitionStyle: .crossfade, duration: 23),
            Scene(filename: "water-crashing-rocks.mp4", type: .video, timeOfDay: .morning, weatherCondition: .any, transitionStyle: .crossfade, duration: 8),
            Scene(filename: "waves-rushing-seashore.mp4", type: .video, timeOfDay: .morning, weatherCondition: .any, transitionStyle: .crossfade, duration: 25)
        ]
        
        scenes.forEach { pack.scenes.append($0) }
        
        return pack
    }
    
    private func createTropicalCalmPack() -> ContentPack {
        let pack = ContentPack(
            name: "Tropical Calm",
            theme: "Tropical beaches, waterfalls, and underwater scenes",
            price: nil,
            productID: nil,
            isPurchased: true,
            musicTrackFilename: nil,
            thumbnailFilename: "tropical-thumb.jpg"
        )
        
        let scenes = [
            Scene(filename: "ocean-aerial.mp4", type: .video, timeOfDay: .any, weatherCondition: .any, transitionStyle: .crossfade, duration: 15),
            Scene(filename: "palm-beach-waves.mp4", type: .video, timeOfDay: .any, weatherCondition: .any, transitionStyle: .crossfade, duration: 23),
            Scene(filename: "tropical-flowers.mp4", type: .video, timeOfDay: .any, weatherCondition: .any, transitionStyle: .crossfade, duration: 20),
            Scene(filename: "tropical-waterfall.mp4", type: .video, timeOfDay: .any, weatherCondition: .any, transitionStyle: .crossfade, duration: 8),
            Scene(filename: "turquoise-water.mp4", type: .video, timeOfDay: .any, weatherCondition: .any, transitionStyle: .crossfade, duration: 21),
            Scene(filename: "underwater-reef.mp4", type: .video, timeOfDay: .any, weatherCondition: .any, transitionStyle: .crossfade, duration: 85)
        ]
        
        scenes.forEach { pack.scenes.append($0) }
        
        return pack
    }
}
