import AppKit

final class PaperOverlayWindow: NSWindow {
    private let tintLayer = CALayer()
    private let noiseLayer = NoiseTileLayer()
    private let effectLayer = ColorEPaperEffectLayer()
    private var appearanceObservation: NSKeyValueObservation?

    init(screen: NSScreen, opacity: CGFloat) {
        super.init(contentRect: screen.frame, styleMask: [.borderless], backing: .buffered, defer: false)

        isOpaque = false
        backgroundColor = .clear
        ignoresMouseEvents = true
        level = .screenSaver
        collectionBehavior = [.canJoinAllSpaces,.fullScreenAuxiliary,.stationary]

        contentView?.wantsLayer = true
        if let root = contentView?.layer {
            tintLayer.frame = root.bounds
            tintLayer.backgroundColor = NSColor(calibratedRed: 247/255, green: 243/255, blue: 232/255, alpha: 0.08).cgColor
            root.addSublayer(tintLayer)

            noiseLayer.frame = root.bounds
            noiseLayer.contentsScale = screen.backingScaleFactor
            noiseLayer.needsDisplayOnBoundsChange = true
            noiseLayer.opacity = Float(opacity)
            noiseLayer.compositingFilter = "softLightBlendMode"
            root.addSublayer(noiseLayer)

            effectLayer.frame = root.bounds
            effectLayer.contentsScale = screen.backingScaleFactor
            effectLayer.needsDisplayOnBoundsChange = true
            root.addSublayer(effectLayer)
        }
        appearanceObservation = observe(\.effectiveAppearance, options: [.new]) { [weak self] window, _ in
            self?.effectLayer.updateAppearance(window.effectiveAppearance)
        }
    }

    func setTexture(_ image: CGImage?) {
        noiseLayer.tile = image
    }

    func configure(with settings: PaperSettings) {
        let texture = settings.texture.settings
        tintLayer.backgroundColor = texture.tint.withAlphaComponent(0.14).cgColor
        tintLayer.opacity = Float(texture.opacity)
        noiseLayer.compositingFilter = texture.blendMode
        noiseLayer.opacity = Float(settings.opacity)

        switch settings.mode {
        case .standard:
            effectLayer.isHidden = true
        case .colorEPaper:
            effectLayer.setPaperStyle(settings.colorEPaperStyle, appearance: effectiveAppearance)
            effectLayer.backgroundColor = nil
            effectLayer.opacity = 1
            effectLayer.isHidden = false
        case .softLight:
            effectLayer.setPaperStyle(nil, appearance: effectiveAppearance)
            effectLayer.backgroundColor = settings.softLightScene.tint.cgColor
            effectLayer.opacity = Float(min(1, max(0, settings.softLightIntensity))) * 0.6
            effectLayer.isHidden = false
        }
    }

}

private final class NoiseTileLayer: CALayer {
    var tile: CGImage? {
        didSet { setNeedsDisplay() }
    }

    override func draw(in context: CGContext) {
        guard let tile else { return }

        // Keep one texture pixel per point instead of stretching to the display bounds.
        let tileRect = CGRect(x: 0, y: 0, width: tile.width, height: tile.height)
        context.draw(tile, in: tileRect, byTiling: true)
    }
}
