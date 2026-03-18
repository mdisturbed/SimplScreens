import SwiftUI
import SwiftData

struct PackBrowserView: View {
    @Query private var packs: [ContentPack]
    
    var body: some View {
        NavigationStack {
            ScrollView {
                LazyVGrid(columns: [
                    GridItem(.adaptive(minimum: 400, maximum: 500), spacing: 40)
                ], spacing: 40) {
                    ForEach(packs) { pack in
                        PackCard(pack: pack)
                    }
                }
                .padding(40)
            }
            .navigationTitle("Content Packs")
            .preferredColorScheme(.dark)
        }
    }
}

struct PackCard: View {
    let pack: ContentPack
    @FocusState private var isFocused: Bool
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            ZStack {
                LinearGradient(
                    colors: [.blue.opacity(0.3), .purple.opacity(0.3)],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
                
                VStack {
                    Image(systemName: "photo.stack")
                        .font(.system(size: 60))
                        .foregroundColor(.white.opacity(0.6))
                    Text("\(pack.scenes.count) scenes")
                        .font(.caption)
                        .foregroundColor(.white.opacity(0.6))
                }
            }
            .frame(height: 225)
            .cornerRadius(12)
            
            VStack(alignment: .leading, spacing: 4) {
                Text(pack.name)
                    .font(.headline)
                
                Text(pack.theme)
                    .font(.caption)
                    .foregroundColor(.secondary)
                    .lineLimit(2)
                
                if pack.isAvailable {
                    Label("Owned", systemImage: "checkmark.circle.fill")
                        .font(.caption)
                        .foregroundColor(.green)
                } else if let price = pack.price {
                    Text("$\(price, format: .number.precision(.fractionLength(2)))")
                        .font(.caption)
                        .foregroundColor(.blue)
                }
            }
        }
        .scaleEffect(isFocused ? 1.05 : 1.0)
        .shadow(radius: isFocused ? 20 : 5)
        .animation(.spring(duration: 0.2), value: isFocused)
        .focusable()
        .focused($isFocused)
    }
}
