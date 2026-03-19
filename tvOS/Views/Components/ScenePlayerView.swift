import SwiftUI
import AVKit

struct ScenePlayerView: View {
    let scene: Scene
    
    @State private var player: AVPlayer?
    
    var body: some View {
        Group {
            if scene.type == .video, let videoURL = getVideoURL() {
                VideoPlayer(player: player)
                    .ignoresSafeArea()
                    .onAppear {
                        setupPlayer(url: videoURL)
                    }
                    .onDisappear {
                        cleanupPlayer()
                    }
            } else {
                // Fallback gradient for missing videos or photo type
                ZStack {
                    LinearGradient(
                        colors: gradientColors,
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                    
                    VStack(spacing: 12) {
                        Image(systemName: sceneIcon)
                            .font(.system(size: 80))
                            .foregroundColor(.white.opacity(0.6))
                        
                        Text(scene.filename)
                            .font(.title3)
                            .foregroundColor(.white.opacity(0.8))
                        
                        Text("\(scene.timeOfDay.rawValue) • \(scene.weatherCondition.rawValue)")
                            .font(.caption)
                            .foregroundColor(.white.opacity(0.5))
                    }
                }
            }
        }
    }
    
    private func getVideoURL() -> URL? {
        let filename = scene.filename.replacingOccurrences(of: ".mp4", with: "")
        return Bundle.main.url(forResource: filename, withExtension: "mp4")
    }
    
    private func setupPlayer(url: URL) {
        let playerItem = AVPlayerItem(url: url)
        player = AVPlayer(playerItem: playerItem)
        player?.isMuted = true // Ambient app - video audio off by default
        player?.play()
        
        // Loop video indefinitely
        NotificationCenter.default.addObserver(
            forName: .AVPlayerItemDidPlayToEndTime,
            object: playerItem,
            queue: .main
        ) { _ in
            player?.seek(to: .zero)
            player?.play()
        }
    }
    
    private func cleanupPlayer() {
        player?.pause()
        player = nil
        NotificationCenter.default.removeObserver(self)
    }
    
    private var gradientColors: [Color] {
        switch scene.timeOfDay {
        case .morning:
            return [.orange.opacity(0.4), .yellow.opacity(0.3)]
        case .afternoon:
            return [.blue.opacity(0.4), .cyan.opacity(0.3)]
        case .evening:
            return [.purple.opacity(0.4), .pink.opacity(0.3)]
        case .night:
            return [.indigo.opacity(0.4), .purple.opacity(0.3)]
        case .any:
            return [.blue.opacity(0.3), .purple.opacity(0.3)]
        }
    }
    
    private var sceneIcon: String {
        switch scene.weatherCondition {
        case .clear: return "sun.max.fill"
        case .rain: return "cloud.rain.fill"
        case .snow: return "cloud.snow.fill"
        case .cloudy: return "cloud.fill"
        case .any: return "photo.fill"
        }
    }
}
