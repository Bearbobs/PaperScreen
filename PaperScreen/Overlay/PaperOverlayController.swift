import AppKit
import Combine

final class PaperOverlayController: ObservableObject {
    @Published var enabled = true {
        didSet { windows.values.forEach { enabled ? $0.orderFront(nil) : $0.orderOut(nil) } }
    }

    private var windows: [String: PaperOverlayWindow] = [:]
    private let generator = NoiseTextureGenerator()

    init() {
        rebuild()
    }

    func rebuild() {
        windows.removeAll()
        let tile = generator.generateTile()
        for screen in NSScreen.screens {
            let w = PaperOverlayWindow(screen: screen, opacity: 0.12)
            w.setTexture(tile)
            w.orderFront(nil)
            windows["\(screen.hash)"] = w
        }
    }

    func setOpacity(_ value: CGFloat) {
        windows.values.forEach { $0.setOpacity(value) }
    }
}
