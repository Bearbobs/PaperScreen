import AppKit
import Combine

final class PaperOverlayController: ObservableObject {
    
    private func updateVisibility() {

        for window in windows.values {

            if enabled {
                window.orderFrontRegardless()
            } else {
                window.orderOut(nil)
            }

        }

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

        settings.$opacity
            .sink { [weak self] value in
                self?.windows.values.forEach {
                    $0.setOpacity(CGFloat(value))
                }
            }
            .store(in: &cancellables)

        rebuild()
    }

    func rebuild() {
        windows.removeAll()
        let tile = generator.generateTile()
        for screen in NSScreen.screens {
            let w = PaperOverlayWindow(
                screen: screen,
                opacity: CGFloat(settings.opacity)
            )
            w.setTexture(tile)
            w.orderFront(nil)
            windows["\(screen.hash)"] = w
        }
        updateVisibility()
    }

    func setOpacity(_ value: CGFloat) {
        windows.values.forEach { $0.setOpacity(value) }
    }
}
