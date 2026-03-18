import Foundation
import SwiftData

@MainActor
final class SceneEngine: ObservableObject {
    @Published private(set) var currentScene: Scene?
    @Published private(set) var nextScene: Scene?
    
    private let preferences: UserPreferences
    private var availablePacks: [ContentPack]
    private var sceneHistory: [UUID] = []
    
    init(preferences: UserPreferences, availablePacks: [ContentPack]) {
        self.preferences = preferences
        self.availablePacks = availablePacks
    }
    
    func selectNextScene(currentWeather: WeatherCondition = .any) async -> Scene? {
        let currentTime = timeOfDay()
        
        let eligibleScenes = availableScenes()
            .filter { scene in
                (scene.timeOfDay == currentTime || scene.timeOfDay == .any) &&
                (scene.weatherCondition == currentWeather || scene.weatherCondition == .any) &&
                !sceneHistory.suffix(10).contains(scene.id)
            }
        
        guard !eligibleScenes.isEmpty else {
            return availableScenes().randomElement()
        }
        
        let selected: Scene?
        switch preferences.shuffleMode {
        case .sequential:
            selected = eligibleScenes.first
        case .random:
            selected = eligibleScenes.randomElement()
        case .smart:
            selected = weightedRandom(from: eligibleScenes, time: currentTime, weather: currentWeather)
        }
        
        if let scene = selected {
            sceneHistory.append(scene.id)
            if sceneHistory.count > 50 { sceneHistory.removeFirst() }
        }
        
        return selected
    }
    
    private func availableScenes() -> [Scene] {
        availablePacks
            .filter { pack in 
                pack.isAvailable && preferences.selectedPackIDs.contains(pack.id) 
            }
            .flatMap { $0.scenes }
    }
    
    private func timeOfDay() -> TimeOfDay {
        let hour = Calendar.current.component(.hour, from: Date())
        switch hour {
        case 6..<12: return .morning
        case 12..<18: return .afternoon
        case 18..<21: return .evening
        default: return .night
        }
    }
    
    private func weightedRandom(from scenes: [Scene], time: TimeOfDay, 
                               weather: WeatherCondition) -> Scene? {
        let weighted = scenes.map { scene -> (Scene, Int) in
            var weight = 1
            if scene.timeOfDay == time && scene.weatherCondition == weather {
                weight = 3
            } else if scene.timeOfDay == time || scene.weatherCondition == weather {
                weight = 2
            }
            return (scene, weight)
        }
        
        let totalWeight = weighted.reduce(0) { $0 + $1.1 }
        var random = Int.random(in: 0..<totalWeight)
        
        for (scene, weight) in weighted {
            random -= weight
            if random < 0 { return scene }
        }
        
        return weighted.first?.0
    }
}
