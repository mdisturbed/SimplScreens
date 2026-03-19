import SwiftData
import Foundation

enum SceneType: String, Codable {
    case photo
    case video
}

enum TimeOfDay: String, Codable, CaseIterable {
    case morning    // 6am-12pm
    case afternoon  // 12pm-6pm
    case evening    // 6pm-9pm
    case night      // 9pm-6am
    case any        // Anytime (no time preference)
}

enum WeatherCondition: String, Codable, CaseIterable {
    case clear
    case rain
    case snow
    case cloudy
    case any        // No weather preference
}

enum TransitionStyle: String, Codable {
    case crossfade
    case kenBurns   // Slow zoom + pan (photos only)
    case parallax   // Layered motion (photos with depth)
    case cut        // Instant (rarely used)
}

@Model
final class SceneItem {
    @Attribute(.unique) var id: UUID
    var filename: String        // Relative to pack directory
    var type: SceneType
    var timeOfDay: TimeOfDay
    var weatherCondition: WeatherCondition
    var transitionStyle: TransitionStyle
    var duration: TimeInterval  // How long to display (15-60s)
    
    @Relationship(inverse: \ContentPack.scenes)
    var pack: ContentPack?
    
    var fileURL: URL? {
        guard let pack = pack else { return nil }
        return Bundle.main.url(forResource: filename, withExtension: nil)
    }
    
    init(id: UUID = UUID(), filename: String, type: SceneType, 
         timeOfDay: TimeOfDay, weatherCondition: WeatherCondition,
         transitionStyle: TransitionStyle, duration: TimeInterval = 30) {
        self.id = id
        self.filename = filename
        self.type = type
        self.timeOfDay = timeOfDay
        self.weatherCondition = weatherCondition
        self.transitionStyle = transitionStyle
        self.duration = duration
    }
}
