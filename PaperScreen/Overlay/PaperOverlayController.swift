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
    
    private func makeTile() -> CGImage? {
        return generator.generateTile(
            for: settings.texture,
            grainSize: settings.grainSize,
            textureSharpness: settings.textureSharpness
        )
    }

    private func updateAppearance() {
        windows.values.forEach { $0.configure(with: settings) }
    }

    private func updateTexture() {
        let tile = makeTile()
        windows.values.forEach { $0.setTexture(tile) }
        updateAppearance()
    }

    @Published var enabled = true {
        didSet {
            updateVisibility()
        }
    }

    private let settings: PaperSettings
    
    private var windows: [String: PaperOverlayWindow] = [:]
    private let generator = NoiseTextureGenerator()
    private var cancellables = Set<AnyCancellable>()

    init(settings: PaperSettings) {
        self.settings = settings

        Publishers.Merge3(
            settings.$texture.dropFirst().map { _ in () },
            settings.$grainSize.dropFirst().map { _ in () },
            settings.$textureSharpness.dropFirst().map { _ in () }
        )
        .receive(on: RunLoop.main)
        .sink { [weak self] in
            guard let self else { return }
            self.updateTexture()
            self.settings.save()
        }
        .store(in: &cancellables)

        Publishers.Merge4(
            settings.$mode.dropFirst().map { _ in () },
            settings.$opacity.dropFirst().map { _ in () },
            settings.$softLightScene.dropFirst().map { _ in () },
            settings.$softLightIntensity.dropFirst().map { _ in () }
        )
        .merge(with: settings.$colorEPaperStyle.dropFirst().map { _ in () })
        .receive(on: RunLoop.main)
        .sink { [weak self] in
            guard let self else { return }
            self.updateAppearance()
            self.settings.save()
        }
        .store(in: &cancellables)

        settings.$excludedBundleIdentifiers.dropFirst()
            .receive(on: RunLoop.main)
            .sink { [weak self] _ in
                self?.updateVisibility()
                self?.settings.save()
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

        let tile = makeTile()
        for screen in NSScreen.screens {
            let w = PaperOverlayWindow(
                screen: screen,
                opacity: CGFloat(settings.opacity)
            )
            w.setTexture(tile)
            w.configure(with: settings)
            w.orderFront(nil)
            windows["\(screen.hash)"] = w
        }
        updateVisibility()
    }

}
