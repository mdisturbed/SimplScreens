import SwiftUI
import SwiftData

struct ScreensaverView: View {
    @Environment(\.modelContext) private var modelContext
    @Query private var preferences: [UserPreferences]
    @Query private var packs: [ContentPack]
    
    @State private var currentScene: SceneItem?
    @State private var currentPack: ContentPack?
    @State private var showInfoOverlay = false
    @State private var showControlsOverlay = true
    @State private var sceneChangeTask: Task<Void, Never>?
    @State private var autoHideTask: Task<Void, Never>?
    @State private var isPlaying = true
    @StateObject private var musicPlayer = MusicPlayer()
    
    // Binding for fullscreen presentation (set externally)
    @Binding var isFullscreen: Bool
    
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
            
            // Info overlay (tap to show scene details)
            if showInfoOverlay, let scene = currentScene {
                InfoOverlayView(scene: scene)
                    .transition(.opacity)
            }
            
            // Playback controls overlay (auto-hides)
            PlaybackControlsOverlay(
                musicPlayer: musicPlayer,
                isPlaying: $isPlaying,
                isVisible: $showControlsOverlay,
                currentPackName: currentPack?.name,
                onExitFullscreen: { isFullscreen = false },
                onSettingsTapped: {
                    // Exit fullscreen to show settings tab
                    isFullscreen = false
                }
            )
        }
        .preferredColorScheme(.dark)
        .onAppear {
            startScreensaver()
            startMusic()
            startAutoHideTimer()
        }
        .onDisappear {
            sceneChangeTask?.cancel()
            autoHideTask?.cancel()
            musicPlayer.stop()
        }
        .onTapGesture {
            // Tap shows info overlay AND resets controls auto-hide
            withAnimation {
                showInfoOverlay.toggle()
            }
            showControlsAndResetTimer()
        }
        .onMoveCommand { _ in
            // Siri Remote directional input
            showControlsAndResetTimer()
        }
        .onPlayPauseCommand {
            // Siri Remote play/pause button
            togglePlayback()
            showControlsAndResetTimer()
        }
        .onExitCommand {
            // Siri Remote menu button
            isFullscreen = false
        }
        .onChange(of: isPlaying) { _, newValue in
            if newValue {
                sceneChangeTask?.cancel()
                startScreensaver()
            } else {
                sceneChangeTask?.cancel()
            }
        }
    }
    
    private func startMusic() {
        guard let prefs = preferences.first, prefs.musicEnabled else { return }
        // Play music from the first available pack
        if let pack = packs.first(where: { $0.isAvailable }),
           let trackFilename = pack.musicTrackFilename {
            currentPack = pack
            musicPlayer.play(track: trackFilename, volume: prefs.musicVolume, fadeIn: true)
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
                    // Check if we've switched packs (crossfade music if needed)
                    await MainActor.run {
                        if let newPack = nextScene.pack, newPack.id != currentPack?.id {
                            currentPack = newPack
                            
                            if prefs.musicEnabled, let trackFilename = newPack.musicTrackFilename {
                                musicPlayer.crossfade(to: trackFilename, volume: prefs.musicVolume, duration: 2.0)
                            }
                        }
                        
                        withAnimation(.easeInOut(duration: prefs.transitionDuration)) {
                            currentScene = nextScene
                        }
                    }
                    
                    try? await Task.sleep(for: .seconds(nextScene.duration))
                }
            }
        }
    }
    
    private func startAutoHideTimer() {
        autoHideTask?.cancel()
        
        autoHideTask = Task {
            try? await Task.sleep(for: .seconds(30))
            
            if !Task.isCancelled {
                await MainActor.run {
                    withAnimation {
                        showControlsOverlay = false
                    }
                }
            }
        }
    }
    
    private func showControlsAndResetTimer() {
        withAnimation {
            showControlsOverlay = true
        }
        startAutoHideTimer()
    }
    
    private func togglePlayback() {
        isPlaying.toggle()
    }
}

// Convenience initializer for non-fullscreen usage (if needed elsewhere)
extension ScreensaverView {
    init() {
        self._isFullscreen = .constant(false)
    }
}
