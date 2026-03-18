import AVFoundation

@MainActor
final class MusicPlayer: ObservableObject {
    @Published private(set) var isPlaying = false
    
    private var primaryPlayer: AVAudioPlayer?
    private var secondaryPlayer: AVAudioPlayer?
    private var fadeTimer: Timer?
    
    func play(track filename: String, volume: Float, looping: Bool = true) {
        guard let url = Bundle.main.url(forResource: filename, withExtension: nil) else {
            print("❌ Music track not found: \(filename)")
            return
        }
        
        do {
            let player = try AVAudioPlayer(contentsOf: url)
            player.numberOfLoops = looping ? -1 : 0
            player.volume = volume
            player.prepareToPlay()
            player.play()
            
            primaryPlayer = player
            isPlaying = true
        } catch {
            print("❌ Failed to play music: \(error)")
        }
    }
    
    func stop() {
        primaryPlayer?.stop()
        secondaryPlayer?.stop()
        fadeTimer?.invalidate()
        isPlaying = false
    }
}
