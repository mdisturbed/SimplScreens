import SwiftUI
import SwiftData

struct SettingsView: View {
    @Environment(\.modelContext) private var modelContext
    @Query private var preferences: [UserPreferences]
    @Query private var packs: [ContentPack]
    
    @State private var selectedPackIDs: Set<UUID> = []
    @State private var musicEnabled = true
    @State private var musicVolume: Float = 0.6
    @State private var weatherAware = true
    @State private var shuffleMode: ShuffleMode = .smart
    
    var body: some View {
        NavigationStack {
            Form {
                Section("Active Packs") {
                    ForEach(packs.filter { $0.isAvailable }) { pack in
                        Toggle(pack.name, isOn: Binding(
                            get: { selectedPackIDs.contains(pack.id) },
                            set: { isOn in
                                if isOn {
                                    selectedPackIDs.insert(pack.id)
                                } else {
                                    selectedPackIDs.remove(pack.id)
                                }
                            }
                        ))
                    }
                }
                
                Section("Music") {
                    Toggle("Enable Music", isOn: $musicEnabled)
                    
                    if musicEnabled {
                        Picker("Volume", selection: Binding(
                            get: { Int(musicVolume * 10) },
                            set: { musicVolume = Float($0) / 10.0 }
                        )) {
                            ForEach(0...10, id: \.self) { level in
                                Text("\(level * 10)%").tag(level)
                            }
                        }
                    }
                }
                
                Section("Scene Selection") {
                    Toggle("Weather-Aware", isOn: $weatherAware)
                    
                    Picker("Shuffle Mode", selection: $shuffleMode) {
                        Text("Sequential").tag(ShuffleMode.sequential)
                        Text("Random").tag(ShuffleMode.random)
                        Text("Smart").tag(ShuffleMode.smart)
                    }
                }
                
                Section {
                    Button("Save Settings") {
                        saveSettings()
                    }
                    .buttonStyle(.borderedProminent)
                }
            }
            .navigationTitle("Settings")
            .preferredColorScheme(.dark)
            .onAppear {
                loadCurrentSettings()
            }
        }
    }
    
    private func loadCurrentSettings() {
        guard let prefs = preferences.first else {
            let defaultPrefs = UserPreferences()
            modelContext.insert(defaultPrefs)
            try? modelContext.save()
            return
        }
        
        selectedPackIDs = Set(prefs.selectedPackIDs)
        musicEnabled = prefs.musicEnabled
        musicVolume = prefs.musicVolume
        weatherAware = prefs.weatherAwareEnabled
        shuffleMode = prefs.shuffleMode
    }
    
    private func saveSettings() {
        guard let prefs = preferences.first else { return }
        
        prefs.selectedPackIDs = Array(selectedPackIDs)
        prefs.musicEnabled = musicEnabled
        prefs.musicVolume = musicVolume
        prefs.weatherAwareEnabled = weatherAware
        prefs.shuffleMode = shuffleMode
        
        try? modelContext.save()
        
        Logger.shared.info("Settings saved")
    }
}
