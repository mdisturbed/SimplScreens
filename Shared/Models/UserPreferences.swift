import SwiftData
import Foundation

enum ShuffleMode: String, Codable {
    case sequential     // Play scenes in pack order
    case random         // Random within selected packs
    case smart          // Weight by time/weather match
}

@Model
final class UserPreferences {
    @Attribute(.unique) var id: UUID
    
    var selectedPackIDs: [UUID]     // Active packs for screensaver
    var transitionDuration: TimeInterval // Crossfade length (1-5s)
    var musicEnabled: Bool
    var musicVolume: Float          // 0.0-1.0
    var shuffleMode: ShuffleMode
    var weatherAwareEnabled: Bool   // Use weather for scene selection
    var idleTimeout: TimeInterval   // Seconds before screensaver starts (if auto-launched)
    
    init(id: UUID = UUID(), selectedPackIDs: [UUID] = [], 
         transitionDuration: TimeInterval = 2.0, musicEnabled: Bool = true,
         musicVolume: Float = 0.6, shuffleMode: ShuffleMode = .smart,
         weatherAwareEnabled: Bool = true, idleTimeout: TimeInterval = 300) {
        self.id = id
        self.selectedPackIDs = selectedPackIDs
        self.transitionDuration = transitionDuration
        self.musicEnabled = musicEnabled
        self.musicVolume = musicVolume
        self.shuffleMode = shuffleMode
        self.weatherAwareEnabled = weatherAwareEnabled
        self.idleTimeout = idleTimeout
    }
}
