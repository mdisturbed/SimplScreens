import SwiftUI

struct InfoOverlayView: View {
    let scene: SceneItem
    
    var body: some View {
        VStack {
            Spacer()
            
            HStack {
                VStack(alignment: .leading, spacing: 8) {
                    if let packName = scene.pack?.name {
                        Text(packName)
                            .font(.title2)
                            .bold()
                    }
                    
                    HStack(spacing: 16) {
                        Label(scene.timeOfDay.rawValue.capitalized, systemImage: "clock")
                        Label(scene.weatherCondition.rawValue.capitalized, systemImage: weatherIcon)
                        Label(scene.type.rawValue.capitalized, systemImage: scene.type == .photo ? "photo" : "video")
                    }
                    .font(.caption)
                    .foregroundColor(.white.opacity(0.8))
                }
                
                Spacer()
                
                Text("Press Select to dismiss")
                    .font(.caption2)
                    .foregroundColor(.white.opacity(0.5))
            }
            .padding(24)
            .background(
                Color.black.opacity(0.7)
                    .blur(radius: 10)
            )
            .cornerRadius(12)
            .padding(40)
        }
    }
    
    private var weatherIcon: String {
        switch scene.weatherCondition {
        case .clear: return "sun.max"
        case .rain: return "cloud.rain"
        case .snow: return "cloud.snow"
        case .cloudy: return "cloud"
        case .any: return "globe"
        }
    }
}
