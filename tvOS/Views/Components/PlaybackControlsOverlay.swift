import SwiftUI
import SwiftData

struct PlaybackControlsOverlay: View {
    @Environment(\.modelContext) private var modelContext
    @Query private var preferences: [UserPreferences]
    
    @ObservedObject var musicPlayer: MusicPlayer
    @Binding var isPlaying: Bool
    @Binding var isVisible: Bool
    
    let currentPackName: String?
    let onExitFullscreen: () -> Void
    let onSettingsTapped: () -> Void
    
    var body: some View {
        VStack {
            Spacer()
            
            HStack(spacing: 40) {
                // Current pack name
                if let packName = currentPackName {
                    Text(packName)
                        .font(.title3)
                        .foregroundColor(.white)
                        .frame(maxWidth: 300, alignment: .leading)
                } else {
                    Text("SimplScreens")
                        .font(.title3)
                        .foregroundColor(.white.opacity(0.6))
                }
                
                Spacer()
                
                // Play/Pause toggle
                Button(action: togglePlayback) {
                    Image(systemName: isPlaying ? "pause.circle.fill" : "play.circle.fill")
                        .font(.system(size: 44))
                        .foregroundColor(.white)
                }
                .buttonStyle(.plain)
                
                // Audio toggle
                Button(action: toggleAudio) {
                    Image(systemName: audioIcon)
                        .font(.system(size: 44))
                        .foregroundColor(.white)
                }
                .buttonStyle(.plain)
                
                // Settings
                Button(action: onSettingsTapped) {
                    Image(systemName: "gear")
                        .font(.system(size: 44))
                        .foregroundColor(.white)
                }
                .buttonStyle(.plain)
                
                // Exit fullscreen
                Button(action: onExitFullscreen) {
                    Image(systemName: "xmark.circle.fill")
                        .font(.system(size: 44))
                        .foregroundColor(.white.opacity(0.8))
                }
                .buttonStyle(.plain)
            }
            .padding(.horizontal, 60)
            .padding(.vertical, 30)
            .background(
                Color.black.opacity(0.75)
                    .blur(radius: 20)
            )
            .cornerRadius(16)
            .padding(40)
        }
        .opacity(isVisible ? 1.0 : 0.0)
        .animation(.easeInOut(duration: 0.3), value: isVisible)
    }
    
    private var audioIcon: String {
        guard let prefs = preferences.first else { return "speaker.slash.fill" }
        return prefs.musicEnabled ? "speaker.wave.2.fill" : "speaker.slash.fill"
    }
    
    private func togglePlayback() {
        isPlaying.toggle()
    }
    
    private func toggleAudio() {
        guard let prefs = preferences.first else { return }
        
        prefs.musicEnabled.toggle()
        try? modelContext.save()
        
        if prefs.musicEnabled {
            // Resume music
            musicPlayer.resume()
        } else {
            // Stop music
            musicPlayer.pause()
        }
    }
}
