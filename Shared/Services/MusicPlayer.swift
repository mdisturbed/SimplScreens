import AVFoundation

// Helper class for mutable fade state
private class FadeState {
    var currentStep: Int
    let steps: Int
    
    init(currentStep: Int, steps: Int) {
        self.currentStep = currentStep
        self.steps = steps
    }
}

@MainActor
final class MusicPlayer: ObservableObject {
    @Published private(set) var isPlaying = false
    @Published private(set) var currentTrack: String?
    
    private var primaryPlayer: AVAudioPlayer?
    private var secondaryPlayer: AVAudioPlayer?
    private var fadeTimer: Timer?
    private var targetVolume: Float = 0.6
    
    /// Play a track with optional fade-in
    func play(track filename: String, volume: Float, looping: Bool = true, fadeIn shouldFadeIn: Bool = true) {
        guard let url = Bundle.main.url(forResource: filename, withExtension: nil) else {
            print("❌ Music track not found: \(filename)")
            return
        }
        
        do {
            let player = try AVAudioPlayer(contentsOf: url)
            player.numberOfLoops = looping ? -1 : 0
            player.volume = shouldFadeIn ? 0.0 : volume
            player.prepareToPlay()
            player.play()
            
            primaryPlayer = player
            currentTrack = filename
            targetVolume = volume
            isPlaying = true
            
            // Gentle fade-in for single track loops
            if shouldFadeIn {
                performFadeIn(player: player, to: volume, duration: 1.0)
            }
        } catch {
            print("❌ Failed to play music: \(error)")
        }
    }
    
    /// Crossfade from current track to a new track
    func crossfade(to newTrack: String, volume: Float, duration: TimeInterval = 2.0) {
        guard let url = Bundle.main.url(forResource: newTrack, withExtension: nil) else {
            print("❌ Music track not found: \(newTrack)")
            return
        }
        
        // If no track is currently playing, just play the new one
        guard let currentPlayer = primaryPlayer, currentPlayer.isPlaying else {
            play(track: newTrack, volume: volume, fadeIn: true)
            return
        }
        
        // If trying to play the same track, do nothing
        if currentTrack == newTrack {
            return
        }
        
        do {
            // Set up secondary player at volume 0
            let newPlayer = try AVAudioPlayer(contentsOf: url)
            newPlayer.numberOfLoops = -1
            newPlayer.volume = 0.0
            newPlayer.prepareToPlay()
            newPlayer.play()
            
            secondaryPlayer = newPlayer
            targetVolume = volume
            
            // Cancel any existing fade
            fadeTimer?.invalidate()
            
            // Crossfade using a class to hold mutable state
            let fadeState = FadeState(currentStep: 0, steps: 40)
            let stepDuration = duration / Double(fadeState.steps)
            let initialVolume = currentPlayer.volume
            
            fadeTimer = Timer.scheduledTimer(withTimeInterval: stepDuration, repeats: true) { [weak self] timer in
                guard let self = self else {
                    timer.invalidate()
                    return
                }
                
                fadeState.currentStep += 1
                
                let progress = Float(fadeState.currentStep) / Float(fadeState.steps)
                newPlayer.volume = volume * progress
                currentPlayer.volume = initialVolume * (1.0 - progress)
                
                if fadeState.currentStep >= fadeState.steps {
                    timer.invalidate()
                    
                    // Swap players
                    currentPlayer.stop()
                    self.primaryPlayer = newPlayer
                    self.secondaryPlayer = nil
                    self.currentTrack = newTrack
                    self.isPlaying = true
                }
            }
        } catch {
            print("❌ Failed to crossfade: \(error)")
        }
    }
    
    /// Fade in a player to target volume
    private func performFadeIn(player: AVAudioPlayer, to volume: Float, duration: TimeInterval) {
        let steps = 20
        let stepDuration = duration / Double(steps)
        var currentStep = 0
        
        fadeTimer?.invalidate()
        fadeTimer = Timer.scheduledTimer(withTimeInterval: stepDuration, repeats: true) { timer in
            currentStep += 1
            player.volume = min(volume * (Float(currentStep) / Float(steps)), volume)
            
            if currentStep >= steps {
                timer.invalidate()
            }
        }
    }
    
    /// Update volume of currently playing track
    func setVolume(_ volume: Float) {
        targetVolume = volume
        primaryPlayer?.volume = volume
        secondaryPlayer?.volume = volume
    }
    
    func stop() {
        fadeTimer?.invalidate()
        primaryPlayer?.stop()
        secondaryPlayer?.stop()
        primaryPlayer = nil
        secondaryPlayer = nil
        currentTrack = nil
        isPlaying = false
    }
    
    func pause() {
        primaryPlayer?.pause()
        isPlaying = false
    }
    
    func resume() {
        primaryPlayer?.play()
        isPlaying = true
    }
}
