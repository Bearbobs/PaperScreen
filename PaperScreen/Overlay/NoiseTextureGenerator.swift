import AppKit
import CoreImage
import CoreImage.CIFilterBuiltins

final class NoiseTextureGenerator {
    private let context = CIContext()

    func generateTile(size: Int = 1024) -> CGImage? {
        let random = CIFilter.randomGenerator()
        guard let image = random.outputImage else { return nil }
        return context.createCGImage(image, from: CGRect(x: 0, y: 0, width: size, height: size))
    }
}
