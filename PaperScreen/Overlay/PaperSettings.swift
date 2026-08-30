import Foundation
import Combine

final class PaperSettings: ObservableObject {
    @Published var opacity: Double
    @Published var warmth: Double
    @Published var texture: PaperTexture
    @Published var grainSize: Double
    @Published var textureSharpness: Double
    
    /// When enabled, PaperScreen will not show the overlay above the frontmost app
    /// whose bundle identifier matches one of these values.
    /// Example: "com.apple.Safari", "com.microsoft.VSCode".
    @Published var excludedBundleIdentifiers: Set<String>

    init(
        opacity: Double = 0.12,
        warmth: Double = 0.10,
        texture: PaperTexture = .matte,
        grainSize: Double = 1.0,
        textureSharpness: Double = 1.0,
        excludedBundleIdentifiers: Set<String> = []
    ) {
        self.opacity = opacity
        self.warmth = warmth
        self.texture = texture
        self.grainSize = grainSize
        self.textureSharpness = textureSharpness
        self.excludedBundleIdentifiers = excludedBundleIdentifiers
    }
}
