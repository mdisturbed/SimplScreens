import SwiftUI

struct ScenePlayerView: View {
    let scene: Scene
    
    @State private var offset: CGSize = .zero
    @State private var scale: CGFloat = 1.0
    
    var body: some View {
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
        .scaleEffect(scale)
        .offset(offset)
        .onAppear {
            applyTransition()
        }
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
    
    private func applyTransition() {
        guard scene.transitionStyle != .cut else { return }
        
        withAnimation(.easeInOut(duration: scene.duration * 0.8)) {
            switch scene.transitionStyle {
            case .kenBurns:
                scale = 1.2
                offset = CGSize(
                    width: CGFloat.random(in: -50...50),
                    height: CGFloat.random(in: -50...50)
                )
            case .parallax:
                offset = CGSize(
                    width: CGFloat.random(in: -30...30),
                    height: CGFloat.random(in: -30...30)
                )
            default:
                break
            }
        }
    }
}
