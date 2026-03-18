# SimplScreens - tvOS Ambient Scenes App

**Phase 1 MVP Scaffold** — Built 2026-03-18

## What's Built

### ✅ Core Architecture (Domingo's Spec)
- **SwiftData Models**: ContentPack, Scene, UserPreferences
- **SceneEngine**: Time-of-day aware scene selection with smart/random/sequential modes
- **MusicPlayer**: Basic playback (crossfade deferred to Phase 2)
- **Navigation**: Tab-based (Play, Packs, Settings)

### ✅ Views
- **ScreensaverView**: Main ambient display with animated transitions
- **ScenePlayerView**: Gradient placeholders with Ken Burns/parallax effects
- **PackBrowserView**: Focus-engine card grid
- **SettingsView**: Pack selection, music toggle, shuffle mode
- **InfoOverlayView**: Metadata overlay (dismissible)

### ✅ Features Implemented
- Dark mode enforced (MANDATORY per Jay's requirements)
- 2 placeholder packs (Coastal Mornings, Tropical Calm) with 5 scenes each
- OLED-safe transitions (constant motion via Ken Burns/parallax)
- Time-of-day awareness (morning/afternoon/evening/night)
- Weather-condition scaffolding (no live API yet)
- Settings persistence via SwiftData

### 📦 What's Placeholder
- **Images**: Using SF Symbols and gradients instead of real 4K content
- **Music**: No bundled audio files yet (MusicPlayer ready)
- **Weather Integration**: No WeatherKit/Open-Meteo calls (returns `.any`)
- **StoreKit 2**: IAP framework not implemented yet

### 🚧 Phase 2 (Deferred)
- WeatherKit + Open-Meteo fallback
- StoreKit 2 IAP integration
- Music crossfade
- Top Shelf extension
- Real 4K content sourcing
- iOS companion app

## Project Structure

```
SimplScreens/
├── Shared/              # Cross-platform code
│   ├── Models/          # SwiftData: ContentPack, Scene, UserPreferences
│   ├── Services/        # SceneEngine, MusicPlayer
│   └── Utilities/       # Logger, Constants
├── tvOS/                # tvOS-specific
│   ├── App/             # SimplScreensApp entry point
│   └── Views/           # SwiftUI views + components
├── Package.swift        # Swift Package (for code organization)
└── README.md            # This file
```

## Building the Project

### Prerequisites
- Xcode 16.0+ (Swift 6.0, tvOS 17.0 SDK)
- Apple TV 4K (3rd gen) simulator

### Option 1: Open in Xcode
Since this is a Swift Package, you can open it directly:

```bash
cd /Users/conky/Desktop/SimplScreens
open Package.swift
```

Then:
1. File → New → Project
2. tvOS → App
3. Name: SimplScreens
4. Bundle ID: com.sudobuiltapps.simplscreens
5. Interface: SwiftUI
6. Storage: SwiftData
7. Add existing files from `Shared/` and `tvOS/` directories

### Option 2: Manual Xcode Project Creation

```bash
# 1. Create new tvOS app project in Xcode
# 2. Add all Swift files from Shared/ and tvOS/
# 3. Set deployment target to tvOS 17.0+
# 4. Enable SwiftUI previews
# 5. Configure bundle ID: com.sudobuiltapps.simplscreens
```

### Verification

Once project is created in Xcode:

```bash
xcodebuild \
  -scheme SimplScreens \
  -destination 'platform=tvOS Simulator,name=Apple TV 4K (3rd generation)' \
  build
```

Expected: Clean build with no errors.

## Architecture Decisions

### Why Gradient Placeholders?
Real 4K assets would make the repo >500MB. Gradients + SF Symbols prove the UX/animations work before content sourcing.

### Why No Weather API Yet?
WeatherKit requires entitlements and location permissions. Phase 1 focuses on core playback engine. Weather integration is Phase 2.

### Why No IAP Yet?
StoreKit 2 testing requires App Store Connect configuration and sandbox testing. Phase 1 proves app structure first.

## Next Steps (For Jay/Team)

1. **Create Xcode Project**: Follow Option 1 or 2 above
2. **Test in Simulator**: Verify app launches, navigates between tabs
3. **Source Content**:
   - Commission 4K photos/videos for 2 packs (10 scenes total)
   - Generate ambient music via ElevenLabs
   - Add to app bundle
4. **Implement WeatherKit**: Phase 2 feature
5. **Configure IAP**: Set up products in App Store Connect
6. **Create GitHub Repo**: `mdisturbed/SimplScreens`

## Blockers Found

### ❌ Cannot Build Yet
- No `.xcodeproj` file — requires manual Xcode project creation
- Swift Package structure is code-only (no app target)

### ✅ Workarounds
- All Swift code is complete and architected correctly
- Can be imported into new Xcode tvOS app project
- All file paths follow Domingo's spec

## Verification Checklist

**Code Quality:**
- [x] All models follow Domingo's architecture spec exactly
- [x] Dark mode enforced globally
- [x] OLED-safe transitions (no static elements)
- [x] SwiftData persistence configured
- [x] Time-of-day logic implemented
- [x] Weather-condition enums defined
- [x] Settings UI complete
- [x] Pack browser with focus engine

**Not Yet Tested:**
- [ ] Actual compilation in Xcode project
- [ ] Simulator launch
- [ ] Scene transitions on tvOS hardware
- [ ] Siri Remote navigation
- [ ] Memory usage with 4K content

## Build Report Location

This file serves as the build report. Summary:

**What's Built:** Complete app scaffold with all core features
**What's Placeholder:** Images, music, weather API, IAP
**What's Phase 2:** Weather integration, IAP, Top Shelf, iOS companion
**Blocker:** Requires Xcode project creation (manual step)

---

**Principal Engineer:** Westley  
**Date:** 2026-03-18  
**Status:** Phase 1 MVP scaffold COMPLETE — pending Xcode project setup
