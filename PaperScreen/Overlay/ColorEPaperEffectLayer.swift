import AppKit

final class ColorEPaperEffectLayer: CALayer {
    private struct PatternKey: Hashable {
        let style: ColorEPaperStyle
        let isDark: Bool
    }

    // Four styles in two appearances; pattern images supply backing-scale representations.
    private static var patterns: [PatternKey: NSColor] = [:]
    private var paperStyle: ColorEPaperStyle?
    private var isDark = false
    private var profile: ColorEPaperProfile?
    private var pattern: NSColor?

    func setPaperStyle(_ style: ColorEPaperStyle?, appearance: NSAppearance) {
        let isDark = appearance.bestMatch(from: [.aqua, .darkAqua]) == .darkAqua
        guard paperStyle != style || self.isDark != isDark else { return }
        paperStyle = style
        self.isDark = isDark
        profile = style?.profile(isDark: isDark)
        if let style, let profile {
            let key = PatternKey(style: style, isDark: isDark)
            if let cached = Self.patterns[key] {
                pattern = cached
            } else {
                let size = Self.tileSize(for: style)
                let image = NSImage(size: CGSize(width: size, height: size), flipped: false) { _ in
                    guard let context = NSGraphicsContext.current?.cgContext else { return false }
                    Self.drawTexture(style: style, profile: profile, in: context)
                    return true
                }
                let color = NSColor(patternImage: image)
                Self.patterns[key] = color
                pattern = color
            }
        } else {
            pattern = nil
        }
        setNeedsDisplay()
    }

    func updateAppearance(_ appearance: NSAppearance) {
        setPaperStyle(paperStyle, appearance: appearance)
    }

    override func draw(in context: CGContext) {
        guard let profile, let pattern else { return }
        context.saveGState()
        let previousContext = NSGraphicsContext.current
        NSGraphicsContext.current = NSGraphicsContext(cgContext: context, flipped: false)
        defer {
            NSGraphicsContext.current = previousContext
            context.restoreGState()
        }

        // The reference painter uses source-over: dim, paper color, then transparent fibers/grain.
        context.setBlendMode(.normal)
        context.setFillColor(NSColor(calibratedWhite: 0, alpha: profile.dimmingOpacity).cgColor)
        context.fill(bounds)
        context.setFillColor(profile.tint.cgColor)
        context.fill(bounds)
        pattern.setFill()
        bounds.fill(using: .sourceOver)
    }

    private static func tileSize(for style: ColorEPaperStyle) -> CGFloat {
        switch style {
        case .cotton, .recycled: return 240
        case .matte, .newsprint: return 160
        }
    }

    private static func drawTexture(style: ColorEPaperStyle, profile: ColorEPaperProfile, in context: CGContext) {
        context.setShouldAntialias(true)
        context.setBlendMode(.normal)
        let size = tileSize(for: style)
        let opacity = profile.textureOpacity
        let lightness = profile.textureLightness
        let seed: UInt64
        let count: Int
        switch style {
        case .cotton: (seed, count) = (0xC0770A47, 190)
        case .recycled: (seed, count) = (0x48A6DC0DE, 84)
        case .matte: (seed, count) = (0xA11CE, 90)
        case .newsprint: (seed, count) = (0xC0FFEE, 150)
        }
        var random = PaperRandom(state: seed)

        if style == .matte || style == .newsprint {
            let light = NSColor(calibratedWhite: lightness, alpha: 0.58 * opacity).cgColor
            let dark = NSColor(calibratedWhite: 0.14, alpha: 0.82 * opacity).cgColor
            let radiusRange: CGFloat = style == .matte ? 0.24 : 0.36
            for _ in 0..<count {
                let x = size * random.next()
                let y = size * random.next()
                context.setFillColor(random.next() > 0.78 ? light : dark)
                let radius = 0.12 + radiusRange * random.next()
                context.fillEllipse(in: CGRect(x: x, y: y, width: 2 * radius, height: 2 * radius))
            }
            return
        }

        let recycled = style == .recycled
        let lightFiber = NSColor(calibratedWhite: lightness, alpha: 0.52 * opacity).cgColor
        let darkFiber = NSColor(calibratedWhite: 0.16, alpha: (recycled ? 0.80 : 0.68) * opacity).cgColor
        let widthBase: CGFloat = recycled ? 0.32 : 0.22
        let widthRange: CGFloat = recycled ? 0.58 : 0.36
        let lengthBase: CGFloat = recycled ? 5 : 3
        let lengthRange: CGFloat = recycled ? 18 : 11
        let bendRange: CGFloat = recycled ? 5.5 : 2.4
        context.setLineCap(.round)
        for _ in 0..<count {
            let x = size * random.next()
            let y = size * random.next()
            context.setStrokeColor(random.next() > 0.64 ? lightFiber : darkFiber)
            context.setLineWidth(widthBase + widthRange * random.next())
            let length = lengthBase + lengthRange * random.next()
            let angle = 2 * CGFloat.pi * random.next()
            let bend = bendRange * (random.next() - 0.5)
            let sine = sin(angle)
            let cosine = cos(angle)
            let dx = length * cosine
            let dy = length * sine
            let nx = -sine * bend
            let ny = cosine * bend
            context.beginPath()
            context.move(to: CGPoint(x: x, y: y))
            context.addCurve(
                to: CGPoint(x: x + dx, y: y + dy),
                control1: CGPoint(x: x + 0.33 * dx + nx, y: y + 0.33 * dy + ny),
                control2: CGPoint(x: x + 0.67 * dx - 0.45 * nx, y: y + 0.67 * dy - 0.45 * ny)
            )
            context.strokePath()
        }

        let lightFleck = NSColor(calibratedWhite: lightness, alpha: (recycled ? 0.28 : 0.22) * opacity).cgColor
        let darkFleck = NSColor(calibratedWhite: 0.18, alpha: (recycled ? 0.38 : 0.28) * opacity).cgColor
        let threshold: CGFloat = recycled ? 0.74 : 0.72
        let radiusBase: CGFloat = recycled ? 0.35 : 0.18
        let radiusRange: CGFloat = recycled ? 0.95 : 0.42
        let widthScale: CGFloat = recycled ? 2.4 : 2.2
        let heightScale: CGFloat = recycled ? 1.35 : 1.45
        for _ in 0..<(recycled ? 78 : 76) {
            context.setFillColor(random.next() > threshold ? lightFleck : darkFleck)
            let radius = radiusBase + radiusRange * random.next()
            let x = size * random.next()
            let y = size * random.next()
            context.fillEllipse(in: CGRect(x: x, y: y, width: widthScale * radius, height: heightScale * radius))
        }
    }
}

private struct PaperRandom {
    var state: UInt64

    mutating func next() -> CGFloat {
        state = state &* 0x5851F42D4C957F2D &+ 0x14057B7EF767814F
        return CGFloat((state >> 33) & 0xFFFF) / 65535
    }
}
