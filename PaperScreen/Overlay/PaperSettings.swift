import Foundation
import Combine

final class PaperSettings: ObservableObject {
    @Published var opacity: Double
    @Published var texture: PaperTexture
    @Published var grainSize: Double
    @Published var textureSharpness: Double
    @Published var mode: PaperDisplayMode
    @Published var colorEPaperStyle: ColorEPaperStyle
    @Published var softLightScene: SoftLightScene
    @Published var softLightIntensity: Double
    
    /// When enabled, PaperScreen will not show the overlay above the frontmost app
    /// whose bundle identifier matches one of these values.
    /// Example: "com.apple.Safari", "com.microsoft.VSCode".
    @Published var excludedBundleIdentifiers: Set<String>

    init(
        opacity: Double = 0.12,
        texture: PaperTexture = .matte,
        grainSize: Double = 1.0,
        textureSharpness: Double = 1.0,
        mode: PaperDisplayMode = .standard,
        colorEPaperStyle: ColorEPaperStyle = .cotton,
        softLightScene: SoftLightScene = .natural,
        softLightIntensity: Double = 0.5,
        excludedBundleIdentifiers: Set<String> = []
    ) {
        self.opacity = opacity
        self.texture = texture
        self.grainSize = grainSize
        self.textureSharpness = textureSharpness
        self.mode = mode
        self.colorEPaperStyle = colorEPaperStyle
        self.softLightScene = softLightScene
        self.softLightIntensity = softLightIntensity
        self.excludedBundleIdentifiers = excludedBundleIdentifiers
    }

    convenience init(defaults: UserDefaults) {
        self.init(
            opacity: defaults.object(forKey: "opacity") as? Double ?? 0.12,
            texture: PaperTexture(rawValue: defaults.string(forKey: "texture") ?? "") ?? .matte,
            grainSize: defaults.object(forKey: "grainSize") as? Double ?? 1.0,
            textureSharpness: defaults.object(forKey: "textureSharpness") as? Double ?? 1.0,
            mode: PaperDisplayMode(rawValue: defaults.string(forKey: "mode") ?? "") ?? .standard,
            colorEPaperStyle: ColorEPaperStyle(rawValue: defaults.string(forKey: "colorEPaperStyle") ?? "") ?? .cotton,
            softLightScene: SoftLightScene(rawValue: defaults.string(forKey: "softLightScene") ?? "") ?? .natural,
            softLightIntensity: defaults.object(forKey: "softLightIntensity") as? Double ?? 0.5,
            excludedBundleIdentifiers: Set(defaults.stringArray(forKey: "excludedBundleIdentifiers") ?? [])
        )
    }

    func save(to defaults: UserDefaults = .standard) {
        defaults.set(opacity, forKey: "opacity")
        defaults.set(texture.rawValue, forKey: "texture")
        defaults.set(grainSize, forKey: "grainSize")
        defaults.set(textureSharpness, forKey: "textureSharpness")
        defaults.set(mode.rawValue, forKey: "mode")
        defaults.set(colorEPaperStyle.rawValue, forKey: "colorEPaperStyle")
        defaults.set(softLightScene.rawValue, forKey: "softLightScene")
        defaults.set(softLightIntensity, forKey: "softLightIntensity")
        defaults.set(Array(excludedBundleIdentifiers), forKey: "excludedBundleIdentifiers")
    }
}
