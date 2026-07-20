import AppKit
import CoreImage
import CoreImage.CIFilterBuiltins

final class NoiseTextureGenerator {
    private let context = CIContext()

    func generateTile(size: Int = 1024) -> CGImage? {
        generateTile(for: .classicMatte, size: size)
    }

    func generateTile(for texture: PaperTexture, size: Int = 1024) -> CGImage? {
        let random = CIFilter.randomGenerator()
        guard let image = random.outputImage else { return nil }

        let settings = texture.settings
        let scaledImage = image.transformed(
            by: CGAffineTransform(scaleX: settings.grainScale, y: settings.grainScale)
        )

        let blurFilter = CIFilter.gaussianBlur()
        blurFilter.inputImage = scaledImage
        blurFilter.radius = Float(settings.blurRadius)

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
