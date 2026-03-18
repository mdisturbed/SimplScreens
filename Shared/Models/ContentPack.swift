import SwiftData
import Foundation

@Model
final class ContentPack {
    @Attribute(.unique) var id: UUID
    var name: String
    var theme: String           // "Nature Escapes", "Urban Vistas"
    var price: Decimal?         // nil = bundled/free, else $0.99-$1.99
    var productID: String?      // StoreKit product ID
    var isPurchased: Bool
    var downloadedAt: Date?     // Timestamp of last successful download
    var version: Int            // Content version for updates
    
    @Relationship(deleteRule: .cascade)
    var scenes: [Scene]
    
    var musicTrackFilename: String? // "nature-escapes-ambient.aac"
    var thumbnailFilename: String   // For pack store UI
    
    var isAvailable: Bool {
        isPurchased || price == nil // Bundled packs always available
    }
    
    init(id: UUID = UUID(), name: String, theme: String, price: Decimal?, 
         productID: String?, isPurchased: Bool = false, scenes: [Scene] = [], 
         musicTrackFilename: String?, thumbnailFilename: String, version: Int = 1) {
        self.id = id
        self.name = name
        self.theme = theme
        self.price = price
        self.productID = productID
        self.isPurchased = isPurchased
        self.scenes = scenes
        self.musicTrackFilename = musicTrackFilename
        self.thumbnailFilename = thumbnailFilename
        self.version = version
    }
}
