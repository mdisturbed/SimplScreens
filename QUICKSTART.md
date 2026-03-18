# SimplScreens — Quick Start Guide

## What You Have

✅ **Complete Swift codebase** — 831 lines across 15 files  
✅ **GitHub repository** — https://github.com/mdisturbed/SimplScreens  
✅ **Architecture compliance** — 100% per Domingo's spec  
✅ **Phase 1 MVP scaffold** — Ready for Xcode project creation  

## What You Need to Do

### Step 1: Create Xcode Project (15 minutes)

1. Open Xcode
2. File → New → Project
3. Choose: **tvOS → App**
4. Configure:
   - **Product Name:** SimplScreens
   - **Team:** Select your development team
   - **Organization ID:** com.sudobuiltapps
   - **Bundle ID:** com.sudobuiltapps.simplscreens
   - **Interface:** SwiftUI
   - **Storage:** SwiftData
   - **Language:** Swift
5. Save location: `/Users/conky/Desktop/SimplScreens/`
6. **Important:** Choose "Create Git repository" option (will merge with existing repo)

### Step 2: Add Source Files

1. In Xcode Project Navigator, delete the default `ContentView.swift` and `SimplScreensApp.swift`
2. Drag `Shared/` folder into project
3. Drag `tvOS/` folder into project
4. When prompted:
   - ✅ Copy items if needed
   - ✅ Create groups
   - ✅ Add to targets: SimplScreens
5. Verify all `.swift` files are blue (not red) in Project Navigator

### Step 3: Configure Build Settings

1. Select project in Navigator → SimplScreens target
2. General tab:
   - **Deployment Target:** tvOS 17.0
   - **Supported Destinations:** Apple TV
3. Build Settings tab:
   - **Swift Language Version:** Swift 6.0
   - **Enable Previews:** Yes

### Step 4: Build & Run

```bash
# From terminal:
cd /Users/conky/Desktop/SimplScreens
xcodebuild -scheme SimplScreens \
  -destination 'platform=tvOS Simulator,name=Apple TV 4K (3rd generation)' \
  clean build
```

**Or in Xcode:**
1. Select scheme: SimplScreens
2. Select destination: Apple TV 4K (3rd generation)
3. Product → Run (⌘R)

### Expected Result

App launches with 3 tabs:
- **Play:** Gradient screensaver cycling every 30s
- **Packs:** 2 pack cards (Coastal Mornings, Tropical Calm)
- **Settings:** Pack toggles, music slider, shuffle mode picker

## What's Next

### Phase 2: Add Real Content

1. **Source 4K Images:**
   - 5 images per pack × 2 packs = 10 total
   - HEIC format, 3840x2160, 85% quality
   - Themes: Coastal Mornings (beaches, fog) + Tropical Calm (waterfalls, jungle)

2. **Generate Music:**
   - 2 ambient tracks via ElevenLabs
   - AAC format, 128kbps, 44.1kHz, loopable
   - ~2 minutes each

3. **Add to App Bundle:**
   ```
   SimplScreens/Resources/
   ├── Packs/
   │   ├── coastal-mornings/
   │   │   ├── scenes/
   │   │   │   ├── scene-1.heic
   │   │   │   ├── scene-2.heic
   │   │   │   └── ...
   │   │   └── music-ambient.aac
   │   └── tropical-calm/
   │       └── ...
   ```

4. **Update ScenePlayerView:**
   - Replace gradient with `AsyncImage`
   - Add `AVPlayer` for video scenes

### Phase 3: Add Weather & IAP

1. **WeatherKit Integration:**
   - Add entitlement
   - Implement `WeatherService.swift`
   - Request location permission

2. **StoreKit 2:**
   - Configure products in App Store Connect
   - Implement `PackManager.swift`
   - Add purchase flow to PackBrowserView

## Troubleshooting

### Build Error: "Cannot find 'ContentPack' in scope"
**Fix:** Ensure all files in `Shared/Models/` are added to SimplScreens target.

### Runtime Error: SwiftData crash
**Fix:** Verify `.modelContainer(for: [ContentPack.self, Scene.self, UserPreferences.self])` is in `SimplScreensApp.swift`.

### Dark mode not enforced
**Fix:** Check `.preferredColorScheme(.dark)` is present in `SimplScreensApp.swift`.

### Simulator shows black screen
**Fix:** Wait 5-10 seconds for first scene to load. Check Console for errors.

## File Structure

```
SimplScreens/
├── Shared/              # Cross-platform code
│   ├── Models/          # SwiftData: ContentPack, Scene, UserPreferences
│   ├── Services/        # SceneEngine, MusicPlayer
│   └── Utilities/       # Logger, Constants
├── tvOS/                # tvOS-specific
│   ├── App/             # SimplScreensApp entry point
│   └── Views/           # SwiftUI views + components
├── Package.swift        # Swift Package (for organization)
├── README.md            # Detailed architecture docs
├── QUICKSTART.md        # This file
└── .gitignore           # Xcode/SPM ignores
```

## Key Metrics

- **Total Lines:** 831
- **Swift Files:** 15
- **Models:** 3 (ContentPack, Scene, UserPreferences)
- **Services:** 2 (SceneEngine, MusicPlayer)
- **Views:** 6 (ContentView, ScreensaverView, PackBrowserView, SettingsView, ScenePlayerView, InfoOverlayView)
- **Placeholder Packs:** 2
- **Placeholder Scenes:** 10

## Resources

- **GitHub:** https://github.com/mdisturbed/SimplScreens
- **Architecture Spec:** `~/clawd/uploads/simplscreens-architecture-2026-03-16.md`
- **Build Report:** `~/clawd/uploads/simplscreens-build-report-2026-03-18.md`
- **Positioning Doc:** `~/clawd/uploads/simplscreens-positioning-2026-03-16.md`

## Support

Questions? Check the full build report at:
`~/clawd/uploads/simplscreens-build-report-2026-03-18.md`

---

**Built:** 2026-03-18  
**Engineer:** Westley  
**Status:** Phase 1 Complete ✅
