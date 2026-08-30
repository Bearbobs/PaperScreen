import AppKit
import CoreImage
import CoreImage.CIFilterBuiltins

final class NoiseTextureGenerator {
    private let context = CIContext()

    func generateTile(size: Int = 1024) -> CGImage? {
        generateTile(for: .matte, grainSize: 1.0, textureSharpness: 1.0, size: size)
    }

    func generateTile(for texture: PaperTexture, grainSize: Double, textureSharpness: Double, size: Int = 1024) -> CGImage? {
        let random = CIFilter.randomGenerator()
        guard let image = random.outputImage else { return nil }

        let settings = texture.settings
        let effectiveScale = settings.grainScale * CGFloat(grainSize)
        let scaledImage = image.transformed(
            by: CGAffineTransform(scaleX: effectiveScale, y: effectiveScale)
        )

        let blurFilter = CIFilter.gaussianBlur()
        blurFilter.inputImage = scaledImage
        let effectiveBlur = settings.blurRadius / CGFloat(textureSharpness)
        blurFilter.radius = Float(effectiveBlur)

        let contrastFilter = CIFilter.colorControls()
        contrastFilter.inputImage = blurFilter.outputImage
        contrastFilter.contrast = Float(settings.contrast)
        contrastFilter.saturation = 0

        let tintFilter = CIFilter.colorMonochrome()
        tintFilter.inputImage = contrastFilter.outputImage
        guard let tintColor = CIColor(color: settings.tint) else { return nil }
        tintFilter.color = tintColor
        tintFilter.intensity = 1.0

        guard let outputImage = tintFilter.outputImage else { return nil }

        return context.createCGImage(
            outputImage,
            from: CGRect(x: 0, y: 0, width: size, height: size)
        )
    }
}
