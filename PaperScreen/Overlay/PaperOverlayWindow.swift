import AppKit

final class PaperOverlayWindow: NSWindow {
    private let tintLayer = CALayer()
    private let noiseLayer = NoiseTileLayer()

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
        }
    }

    func setTexture(_ image: CGImage?) {
        noiseLayer.tile = image
    }

    func configure(with texture: PaperTexture, opacity: CGFloat) {
        let settings = texture.settings
        tintLayer.backgroundColor = settings.tint.withAlphaComponent(0.14).cgColor
        tintLayer.opacity = Float(settings.opacity)
        noiseLayer.compositingFilter = settings.blendMode
        noiseLayer.opacity = Float(opacity)
    }

    func setOpacity(_ value: CGFloat) {
        noiseLayer.opacity = Float(value)
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
