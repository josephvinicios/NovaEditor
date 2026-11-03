import UIKit
import CoreImage

final class ColorPreviewRenderer {
    private let context = CIContext(options: [.cacheIntermediates: true])
    private let processor = ColorLUTProcessor()

    func render(_ image: UIImage, lut: ColorLUT, intensity: Float = 1) -> UIImage? {
        guard let source = CIImage(image: image),
              let result = processor.apply(lut, to: source, intensity: intensity),
              let cgImage = context.createCGImage(result, from: result.extent) else {
            return nil
        }
        return UIImage(cgImage: cgImage, scale: image.scale, orientation: image.imageOrientation)
    }
}
