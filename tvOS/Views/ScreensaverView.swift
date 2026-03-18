import SwiftUI
import SwiftData

struct ScreensaverView: View {
    @Environment(\.modelContext) private var modelContext
    @Query private var preferences: [UserPreferences]
    @Query private var packs: [ContentPack]
    
    @State private var currentScene: Scene?
    @State private var showInfoOverlay = false
    @State private var sceneChangeTask: Task<Void, Never>?
    
    var body: some View {
        ZStack {
            Color.black.ignoresSafeArea()
            
            if let scene = currentScene {
                ScenePlayerView(scene: scene)
                    .transition(.opacity)
                    .id(scene.id)
            } else {
                VStack(spacing: 20) {
                    ProgressView()
                        .scaleEffect(2)
                    Text("Loading scenes...")
                        .font(.title3)
                        .foregroundColor(.white.opacity(0.7))
                }
            }
            
            if showInfoOverlay, let scene = currentScene {
                InfoOverlayView(scene: scene)
                    .transition(.opacity)
            }
        }
        .preferredColorScheme(.dark)
        .onAppear {
            startScreensaver()
        }
        .onDisappear {
            sceneChangeTask?.cancel()
        }
        .onTapGesture {
            withAnimation {
                showInfoOverlay.toggle()
            }
        }
    }
    
    private func startScreensaver() {
        guard let prefs = preferences.first else {
            let defaultPrefs = UserPreferences()
            modelContext.insert(defaultPrefs)
            try? modelContext.save()
            return
        }
        
        sceneChangeTask = Task {
            let engine = SceneEngine(preferences: prefs, availablePacks: packs.filter { $0.isAvailable })
            
            while !Task.isCancelled {
                if let nextScene = await engine.selectNextScene() {
                    await MainActor.run {
                        withAnimation(.easeInOut(duration: prefs.transitionDuration)) {
                            currentScene = nextScene
                        }
                    }
                    
                    try? await Task.sleep(for: .seconds(nextScene.duration))
                }
            }
        }
    }
}
