import SwiftUI
import SwiftData

struct ContentView: View {
    @Environment(\.modelContext) private var modelContext
    @Query private var packs: [ContentPack]
    
    @State private var isFullscreenScreensaver = false
    
    var body: some View {
        TabView {
            // Play tab - trigger fullscreen presentation
            Button(action: {
                isFullscreenScreensaver = true
            }) {
                VStack(spacing: 20) {
                    Image(systemName: "play.circle.fill")
                        .font(.system(size: 120))
                        .foregroundColor(.white)
                    
                    Text("Start Screensaver")
                        .font(.title)
                        .foregroundColor(.white)
                }
            }
            .buttonStyle(.plain)
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(Color.black.ignoresSafeArea())
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
        .fullScreenCover(isPresented: $isFullscreenScreensaver) {
            ScreensaverView(isFullscreen: $isFullscreenScreensaver)
        }
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
            musicTrackFilename: "coastal-ambient.mp3",
            thumbnailFilename: "coastal-thumb.jpg"
        )
        
        let scenes = [
            SceneItem(filename: "golden-hour-beach.mp4", type: .video, timeOfDay: .morning, weatherCondition: .any, transitionStyle: .crossfade, duration: 23),
            SceneItem(filename: "lighthouse-sunrise.mp4", type: .video, timeOfDay: .morning, weatherCondition: .any, transitionStyle: .crossfade, duration: 15),
            SceneItem(filename: "seacoast-aerial.mp4", type: .video, timeOfDay: .morning, weatherCondition: .any, transitionStyle: .crossfade, duration: 24),
            SceneItem(filename: "slow-motion-waves.mp4", type: .video, timeOfDay: .morning, weatherCondition: .any, transitionStyle: .crossfade, duration: 85),
            SceneItem(filename: "sunrise-from-shore.mp4", type: .video, timeOfDay: .morning, weatherCondition: .any, transitionStyle: .crossfade, duration: 23),
            SceneItem(filename: "water-crashing-rocks.mp4", type: .video, timeOfDay: .morning, weatherCondition: .any, transitionStyle: .crossfade, duration: 8),
            SceneItem(filename: "waves-rushing-seashore.mp4", type: .video, timeOfDay: .morning, weatherCondition: .any, transitionStyle: .crossfade, duration: 25)
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
            musicTrackFilename: "tropical-ambient.mp3",
            thumbnailFilename: "tropical-thumb.jpg"
        )
        
        let scenes = [
            SceneItem(filename: "ocean-aerial.mp4", type: .video, timeOfDay: .any, weatherCondition: .any, transitionStyle: .crossfade, duration: 15),
            SceneItem(filename: "palm-beach-waves.mp4", type: .video, timeOfDay: .any, weatherCondition: .any, transitionStyle: .crossfade, duration: 23),
            SceneItem(filename: "tropical-flowers.mp4", type: .video, timeOfDay: .any, weatherCondition: .any, transitionStyle: .crossfade, duration: 20),
            SceneItem(filename: "tropical-waterfall.mp4", type: .video, timeOfDay: .any, weatherCondition: .any, transitionStyle: .crossfade, duration: 8),
            SceneItem(filename: "turquoise-water.mp4", type: .video, timeOfDay: .any, weatherCondition: .any, transitionStyle: .crossfade, duration: 21),
            SceneItem(filename: "underwater-reef.mp4", type: .video, timeOfDay: .any, weatherCondition: .any, transitionStyle: .crossfade, duration: 85)
        ]
        
        scenes.forEach { pack.scenes.append($0) }
        
        return pack
    }
}
