import AppKit
import Combine

final class PaperOverlayController: ObservableObject {
    
    private func updateVisibility() {
        guard enabled else {
            windows.values.forEach { $0.orderOut(nil) }
            return
        }

        // If the currently active app is in the exclusion list, hide the overlay
        if let frontApp = NSWorkspace.shared.frontmostApplication,
           let bundleID = frontApp.bundleIdentifier,
           settings.excludedBundleIdentifiers.contains(bundleID) {
            windows.values.forEach { $0.orderOut(nil) }
        } else {
            windows.values.forEach { $0.orderFrontRegardless() }
        }
    }
    
    func setTexture(_ texture: PaperTexture) {
        let tile = generator.generateTile(for: texture, grainSize: settings.grainSize, textureSharpness: settings.textureSharpness)

        windows.values.forEach { window in
            window.setTexture(tile)
            window.configure(with: texture, opacity: CGFloat(settings.opacity))
        }
    }

    @Published var enabled = true {
        didSet {
            updateVisibility()
        }
    }

    private let settings: PaperSettings
    
    private static func saveSettings(_ settings: PaperSettings?) {
        guard let settings else { return }
        let defaults = UserDefaults.standard
        defaults.set(settings.opacity, forKey: "opacity")
        defaults.set(settings.warmth, forKey: "warmth")
        defaults.set(settings.texture.rawValue, forKey: "texture")
        defaults.set(settings.grainSize, forKey: "grainSize")
        defaults.set(settings.textureSharpness, forKey: "textureSharpness")
        defaults.set(Array(settings.excludedBundleIdentifiers), forKey: "excludedBundleIdentifiers")
    }
    private var windows: [String: PaperOverlayWindow] = [:]
    private let generator = NoiseTextureGenerator()
    private var cancellables = Set<AnyCancellable>()

    init(settings: PaperSettings) {
        self.settings = settings

        settings.$opacity
            .sink { [weak self] value in
                self?.windows.values.forEach {
                    $0.setOpacity(CGFloat(value))
                }
                Self.saveSettings(self?.settings)
            }
            .store(in: &cancellables)
        
        settings.$texture
            .receive(on: RunLoop.main)
            .sink { [weak self] texture in
                self?.setTexture(texture)
                Self.saveSettings(self?.settings)
            }
            .store(in: &cancellables)

        settings.$grainSize
            .receive(on: RunLoop.main)
            .sink { [weak self] _ in
                guard let self else { return }
                self.setTexture(self.settings.texture)
                Self.saveSettings(self.settings)
            }
            .store(in: &cancellables)

        settings.$textureSharpness
            .receive(on: RunLoop.main)
            .sink { [weak self] _ in
                guard let self else { return }
                self.setTexture(self.settings.texture)
                Self.saveSettings(self.settings)
            }
            .store(in: &cancellables)

        settings.$excludedBundleIdentifiers
            .receive(on: RunLoop.main)
            .sink { [weak self] _ in
                self?.updateVisibility()
                Self.saveSettings(self?.settings)
            }
            .store(in: &cancellables)

        // React to active app changes to support per-app exclusion
        NSWorkspace.shared.notificationCenter.publisher(for: NSWorkspace.didActivateApplicationNotification)
            .receive(on: RunLoop.main)
            .sink { [weak self] _ in
                self?.updateVisibility()
            }
            .store(in: &cancellables)

        // Rebuild overlay windows when display configuration changes
        NotificationCenter.default.publisher(for: NSApplication.didChangeScreenParametersNotification)
            .receive(on: RunLoop.main)
            .sink { [weak self] _ in
                self?.rebuild()
            }
            .store(in: &cancellables)

        rebuild()
    }
    

    func rebuild() {
        windows.values.forEach { window in
            window.orderOut(nil)
            window.close()
        }
        windows.removeAll()

        let texture = settings.texture
        let tile = generator.generateTile(for: texture, grainSize: settings.grainSize, textureSharpness: settings.textureSharpness)
        for screen in NSScreen.screens {
            let w = PaperOverlayWindow(
                screen: screen,
                opacity: CGFloat(settings.opacity)
            )
            w.setTexture(tile)
            w.configure(with: texture, opacity: CGFloat(settings.opacity))
            w.orderFront(nil)
            windows["\(screen.hash)"] = w
        }
        updateVisibility()
    }

    func setOpacity(_ value: CGFloat) {
        windows.values.forEach { $0.setOpacity(value) }
    }
}
